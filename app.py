import mysql.connector
from flask import Flask, render_template, request, jsonify, g

# --- App Configuration ---

app = Flask(__name__)

# --- TODO: UPDATE THESE ---
# Set your MySQL connection details
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root' # or your specific username
app.config['MYSQL_PASSWORD'] = 'your_password' # Set your password
app.config['MYSQL_DB'] = 'carbon_db' # We will create this DB
# ---

# --- Database Setup ---

def get_db():
    """
    Opens a new database connection if there is none yet for the
    current application context.
    """
    if 'db' not in g:
        try:
            g.db = mysql.connector.connect(
                host=app.config['MYSQL_HOST'],
                user=app.config['MYSQL_USER'],
                password=app.config['MYSQL_PASSWORD'],
                database=app.config['MYSQL_DB']
            )
            # We use dictionary=True to get results as dictionaries
            g.cursor = g.db.cursor(dictionary=True) 
        except mysql.connector.Error as err:
            print(f"Error connecting to MySQL: {err}")
            # In a real app, you'd handle this more gracefully
            raise
    return g.db, g.cursor

@app.teardown_appcontext
def close_db(e=None):
    """Closes the database again at the end of the request."""
    cursor = g.pop('cursor', None)
    db = g.pop('db', None)
    if cursor is not None:
        cursor.close()
    if db is not None:
        db.close()

# --- Main Application Route ---

@app.route('/')
def index():
    """Serves the main 'index.html' file."""
    return render_template('index.html')

# --- API Routes (Matching app.js) ---

@app.route('/log-activity', methods=['POST'])
def log_activity():
    """
    API endpoint to log a new user activity.
    This logic is now updated to match your new schema
    and replaces the old stored procedure call.
    """
    try:
        db, cursor = get_db()
        
        # 1. Get data from the form (sent by app.js)
        data = request.json
        user_id = int(data.get('user_id'))
        act_name = data.get('act_name')
        act_type = data.get('act_type')
        quantity = float(data.get('quantity'))
        date = data.get('date')

        # 2. Get the emission factor (Logic based on new schema)
        # Note: Region is no longer part of the factor calculation
        cursor.execute(
            "SELECT factor_value FROM Emission_factor WHERE activity_type = %s",
            (act_type,)
        )
        factor_row = cursor.fetchone()
        
        # 3. (Safety Net) If no specific factor, use 1.0 or error
        if not factor_row:
            # You could also use 1.0, but failing fast is often better
            return jsonify({"error": f"Emission factor for '{act_type}' not found"}), 400
            
        factor_val = factor_row['factor_value']

        # 4. Do the final calculation
        calculated_emission = quantity * factor_val
        
        # 5. Insert the new activity
        cursor.execute(
            "INSERT INTO Activity (act_name, act_type, date, quantity) VALUES (%s, %s, %s, %s)",
            (act_name, act_type, date, quantity)
        )
        new_activity_id = cursor.lastrowid
        
        # 6. Insert the final footprint result
        cursor.execute(
            "INSERT INTO CarbonFootprint (emission_val, calc_date, activity_id) VALUES (%s, %s, %s)",
            (calculated_emission, date, new_activity_id)
        )
        
        # 7. Link the user to this new activity
        cursor.execute(
            "INSERT INTO UserActivityLogs (user_id, activity_id) VALUES (%s, %s)",
            (user_id, new_activity_id)
        )
        
        # 8. Re-implement the 'AfterFootprintInsert' TRIGGER logic
        # (This was in your old queries.sql, so we put it here)
        if calculated_emission > 50:
            suggestion = 'Your recent activity had a high carbon impact. Consider exploring alternatives to reduce this footprint.'
            cursor.execute(
                "INSERT INTO Recommendation (activity_id, suggestion_text) VALUES (%s, %s)",
                (new_activity_id, suggestion)
            )
        
        # 9. Commit all changes and return success
        db.commit()
        
        return jsonify({"message": "Activity logged successfully!"}), 201

    except mysql.connector.Error as err:
        print(f"MySQL Error: {err}")
        db.rollback()
        return jsonify({"error": f"Database error: {err.msg}"}), 500
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
        return jsonify({"error": "An internal server error occurred"}), 500

@app.route('/get-footprint/<int:user_id>', methods=['GET'])
def get_footprint_data(user_id):
    """
    API endpoint to fetch all footprint data for a specific user.
    """
    try:
        db, cursor = get_db()
        
        # This query JOINS the tables to get the data app.js needs
        # Updated table names to match your new schema (e.g., CarbonFootprint)
        query = """
            SELECT c.calc_date, a.act_name, a.quantity, c.emission_val
            FROM CarbonFootprint c
            JOIN Activity a ON c.activity_id = a.activity_id
            JOIN UserActivityLogs ual ON a.activity_id = ual.activity_id
            WHERE ual.user_id = %s
            ORDER BY c.calc_date DESC
        """
        
        cursor.execute(query, (user_id,))
        
        # Fetch all rows (cursor returns dictionaries)
        data = cursor.fetchall()
        
        return jsonify(data), 200

    except mysql.connector.Error as err:
        print(f"MySQL Error: {err}")
        return jsonify({"error": f"Database error: {err.msg}"}), 500
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "An internal server error occurred"}), 500


# --- Run the Application ---

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

