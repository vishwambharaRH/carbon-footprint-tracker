# Corrected app.py
import mysql.connector
from flask import Flask, render_template, request, jsonify, g

app = Flask(__name__)

# --- CONFIG: SET YOUR PASSWORD AND DB NAME ---
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'vrishsql' # <-- PUT YOUR PASSWORD HERE
app.config['MYSQL_DB'] = 'carbon_capture'      # <-- YOUR DB NAME
# ---

# --- Database Setup ---
def get_db():
    if 'db' not in g:
        try:
            g.db = mysql.connector.connect(
                host=app.config['MYSQL_HOST'],
                user=app.config['MYSQL_USER'],
                password=app.config['MYSQL_PASSWORD'],
                database=app.config['MYSQL_DB']
            )
            g.cursor = g.db.cursor(dictionary=True) 
        except mysql.connector.Error as err:
            print(f"Error connecting to MySQL: {err}")
            raise
    return g.db, g.cursor

@app.teardown_appcontext
def close_db(e=None):
    cursor = g.pop('cursor', None)
    db = g.pop('db', None)
    if cursor is not None: cursor.close()
    if db is not None: db.close()

# --- Main Application Route ---
@app.route('/')
def index():
    return render_template('index.html')

# --- API Routes (Matching app.js) ---
@app.route('/log-activity', methods=['POST'])
def log_activity():
    """
    API endpoint that calls the 'LogUserActivity' stored procedure.
    """
    try:
        db, cursor = get_db()
        data = request.json
        
        args = [
            int(data.get('user_id')),
            data.get('act_name'),
            data.get('act_type'),
            float(data.get('quantity')),
            data.get('date')
        ]
        
        # This one command runs your entire SQL procedure
        cursor.callproc('LogUserActivity', args)
        
        db.commit()
        return jsonify({"message": "Activity logged successfully!"}), 201

    except mysql.connector.Error as err:
        db.rollback()
        return jsonify({"error": f"Database error: {err.msg}"}), 500
    except Exception as e:
        db.rollback()
        return jsonify({"error": "An internal server error occurred"}), 500

@app.route('/get-footprint/<int:user_id>', methods=['GET'])
def get_footprint_data(user_id):
    """
    API endpoint to fetch all footprint data for a specific user.
    """
    try:
        db, cursor = get_db()
        query = """
            SELECT c.calc_date, a.act_name, a.quantity, c.emission_val
            FROM CarbonFootprint c
            JOIN Activity a ON c.activity_id = a.activity_id
            JOIN UserActivityLogs ual ON a.activity_id = ual.activity_id
            WHERE ual.user_id = %s
            ORDER BY c.calc_date DESC
        """
        cursor.execute(query, (user_id,))
        data = cursor.fetchall()
        return jsonify(data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# --- Run the Application ---
if __name__ == '__main__':
    app.run(debug=True)