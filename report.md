# CARBON FOOTPRINT CALCULATOR
## Database Management Systems Project Report

---

## Team Details
**Project Title:** Geo-Carbon Tracker - Regional Carbon Footprint Calculator

**Team Members:**
- [Team Member Names to be filled]

**Institution:** [Institution Name]

**Course:** Database Management Systems

**Date:** November 2025

---

## 2. Abstract

The **Carbon Footprint Calculator** is a web-based application designed to help individuals track and monitor their carbon emissions based on their daily activities. The system calculates carbon footprints by considering regional emission factors, allowing users to log activities such as transportation, electricity usage, and cooking fuel consumption. The application provides personalized recommendations when high-emission activities are detected, promoting environmental awareness and sustainable living practices.

The system is built on a relational database architecture using MySQL, with a Flask-based Python backend and an interactive HTML/CSS/JavaScript frontend. It implements advanced database features including stored procedures, functions, triggers, and multi-table joins to ensure efficient data management and automated calculations.

---

## 3. User Requirement Specification

### 3.1 Functional Requirements

**User Management:**
- Users must be able to register with unique user ID, name, email, and address details
- Users should be assigned to a geographic region for accurate emission calculations
- Users can be members of organizations for group tracking

**Activity Logging:**
- Users must be able to log carbon-generating activities with details:
  - Activity name and type (e.g., Diesel Transport, Coal Power)
  - Quantity consumed (km, kWh, kg, hours)
  - Date of activity
- System should automatically calculate carbon emissions based on activity type and regional emission factors

**Carbon Footprint Calculation:**
- System must automatically compute emission values using regional emission factors
- Calculations should be stored with timestamps for historical tracking
- Users should be able to view their complete footprint history

**Recommendations:**
- System should automatically generate recommendations for high-emission activities (>50 kg CO2e)
- Recommendations should be activity-specific and actionable

**Data Retrieval:**
- Users must be able to view their historical carbon footprint data
- Data should be presented in chronological order with activity details

### 3.2 Non-Functional Requirements

**Performance:**
- Database queries should execute within 2 seconds
- System should handle concurrent user requests efficiently

**Reliability:**
- Data integrity must be maintained through foreign key constraints
- Transaction rollback should occur on errors

**Usability:**
- Interface should be intuitive with clear form labels
- Error messages should be user-friendly

**Scalability:**
- Database schema should support addition of new regions and emission factors
- System should accommodate growing user base

---

## 4. Software, Tools, and Programming Languages

### 4.1 Backend Technologies
- **Python 3.x** - Server-side programming
- **Flask 2.x** - Web application framework
- **mysql-connector-python** - Database connectivity

### 4.2 Database
- **MySQL 8.0+** - Relational database management system

### 4.3 Frontend Technologies
- **HTML5** - Structure and markup
- **CSS3** - Styling and layout
- **JavaScript (ES6+)** - Client-side interactivity
- **Fetch API** - Asynchronous HTTP requests

### 4.4 Development Tools
- **Git** - Version control
- **Text Editor/IDE** - Code development
- **MySQL Workbench** (optional) - Database administration

### 4.5 Server
- **Flask Development Server** - Local testing
- **localhost:5000** - Default deployment endpoint

---

## 5. ER Diagram

### Chen Notation Entity-Relationship Diagram

The system's ER diagram includes the following entities and relationships:

**Entities:**
- **User** (user_id, name, email, street, city, state)
- **Organisation** (org_id, org_name)
- **Region** (region_id, region_name, grid_type, country)
- **Activity** (activity_id, act_name, act_type, date, quantity)
- **Emission_factor** (factor_id, activity_type, unit, factor_value, Region_ID)
- **CarbonFootprint** (cfp_id, emission_val, calc_date, activity_id, factor_id)
- **Recommendation** (rec_id, suggestion_text, activity_id)

**Relationships:**
- User **BelongsTo** Region (M:N)
- User **Logs** Activity (M:N)
- User **member_of** Organisation (M:1)
- Region **has** Emission_factor (1:N)
- Activity **uses** Emission_factor (M:1)
- Activity **generates** CarbonFootprint (1:1)
- Activity **produces** Recommendation (1:1)

*[ER Diagram image: erdiag.svg - to be included]*

---

## 6. Relational Schema

### 6.1 Tables with Attributes

**User**
```
User(user_id, name, email, street, city, state)
Primary Key: user_id
Unique: email
```

**Organisation**
```
Organisation(org_id, org_name)
Primary Key: org_id
```

**Region**
```
Region(region_id, region_name, grid_type, country)
Primary Key: region_id
```

**Emission_factor**
```
Emission_factor(factor_id, activity_type, unit, factor_value, region_id)
Primary Key: factor_id
Foreign Key: region_id → Region(region_id)
```

**Activity**
```
Activity(activity_id, act_name, act_type, date, quantity)
Primary Key: activity_id (AUTO_INCREMENT)
```

**CarbonFootprint**
```
CarbonFootprint(cfp_id, emission_val, calc_date, activity_id)
Primary Key: cfp_id (AUTO_INCREMENT)
Foreign Key: activity_id → Activity(activity_id)
```

**Recommendation**
```
Recommendation(rec_id, suggestion_text, activity_id)
Primary Key: rec_id (AUTO_INCREMENT)
Foreign Key: activity_id → Activity(activity_id)
```

### 6.2 Relationship Tables

**UserOrganisation**
```
UserOrganisation(user_id, org_id)
Primary Key: (user_id, org_id)
Foreign Keys: user_id → User(user_id), org_id → Organisation(org_id)
```

**UserRegion**
```
UserRegion(user_id, region_id)
Primary Key: (user_id, region_id)
Foreign Keys: user_id → User(user_id), region_id → Region(region_id)
```

**UserActivityLogs**
```
UserActivityLogs(user_id, activity_id)
Primary Key: (user_id, activity_id)
Foreign Keys: user_id → User(user_id), activity_id → Activity(activity_id)
```

---

## 7. DDL Commands

### 7.1 Database Creation
```sql
CREATE DATABASE IF NOT EXISTS carbon_capture;
USE carbon_capture;
```

### 7.2 Table Creation Commands

**User Table:**
```sql
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    street VARCHAR(150),
    city VARCHAR(100),
    state VARCHAR(100)
);
```

**Organisation Table:**
```sql
CREATE TABLE Organisation (
    org_id INT PRIMARY KEY,
    org_name VARCHAR(150) NOT NULL
);
```

**Region Table:**
```sql
CREATE TABLE Region (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(150) NOT NULL,
    grid_type VARCHAR(100),
    country VARCHAR(100)
);
```

**Emission_factor Table:**
```sql
CREATE TABLE Emission_factor (
    factor_id INT PRIMARY KEY,
    activity_type VARCHAR(100) NOT NULL,
    unit VARCHAR(50),
    factor_value DECIMAL(12,6) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);
```

**Activity Table:**
```sql
CREATE TABLE Activity (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    act_name VARCHAR(150) NOT NULL,
    act_type VARCHAR(100),
    date DATE,
    quantity DECIMAL(12,3) NOT NULL
);
```

**CarbonFootprint Table:**
```sql
CREATE TABLE CarbonFootprint (
    cfp_id INT PRIMARY KEY AUTO_INCREMENT,
    emission_val DECIMAL(12,3) NOT NULL,
    calc_date DATE NOT NULL,
    activity_id INT,
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);
```

**Recommendation Table:**
```sql
CREATE TABLE Recommendation (
    rec_id INT PRIMARY KEY AUTO_INCREMENT,
    suggestion_text TEXT NOT NULL,
    activity_id INT,
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);
```

**UserOrganisation Table:**
```sql
CREATE TABLE UserOrganisation (
    user_id INT,
    org_id INT,
    PRIMARY KEY (user_id, org_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (org_id) REFERENCES Organisation(org_id)
);
```

**UserRegion Table:**
```sql
CREATE TABLE UserRegion (
    user_id INT,
    region_id INT,
    PRIMARY KEY (user_id, region_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);
```

**UserActivityLogs Table:**
```sql
CREATE TABLE UserActivityLogs (
    user_id INT,
    activity_id INT,
    PRIMARY KEY (user_id, activity_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);
```

---

## 8. CRUD Operations Screenshots

### 8.1 CREATE Operations

**Screenshot 1: User Registration**
- Form showing user registration with fields: User ID, Name, Email, Street, City, State
- Success message: "User [Name] registered successfully!"

**Screenshot 2: Activity Logging**
- Form showing activity entry with fields: User ID, Activity Name, Activity Type dropdown, Quantity, Date
- Success message: "Activity logged successfully!"

### 8.2 READ Operations

**Screenshot 3: View Footprint History**
- Table displaying: Date, Activity, Quantity, Emission (kg CO2e)
- Multiple rows showing historical data for a user
- Data sorted by calculation date (descending)

### 8.3 UPDATE Operations

**Screenshot 4: Database Update via Trigger**
- Recommendation table showing automatic entry after high-emission activity
- Demonstrates trigger execution

### 8.4 DELETE Operations

**Screenshot 5: Manual Delete via SQL**
```sql
-- Example delete operation
DELETE FROM UserActivityLogs WHERE user_id = 3 AND activity_id = 5;
```

*[Note: Actual screenshots to be captured during application testing]*

---

## 9. Application Features and Screenshots

### 9.1 User Registration Page (`register.html`)

**Features:**
- Clean, modern form design with validation
- Fields: User ID, Name, Email, Street, City, State
- Real-time error handling for duplicate entries
- Success/error message display
- Link to return to main logging page

**Screenshot Description:**
- Registration form with all input fields
- Submit button styled in blue
- Link to main page at top

### 9.2 Activity Logging Page (`index.html`)

**Features:**
- User ID input for authentication
- Activity name text input
- Activity type dropdown with options:
  - Driving (Car) - Diesel Transport
  - Passenger Train
  - Aviation (per hour)
  - Electricity variants (Coal, Natural Gas, Renewable)
  - Cooking LPG
- Quantity input with decimal support
- Date picker for activity date
- "Log Activity" submit button
- Success/error message display area

**Screenshot Description:**
- Form with all input fields populated with sample data
- Dropdown showing activity type options
- Blue submit button

### 9.3 Footprint History View

**Features:**
- "Load My Data" button to fetch user history
- Dynamic table generation showing:
  - Calculation Date
  - Activity Name
  - Quantity
  - Emission Value (kg CO2e)
- Empty state message: "No data found for this user"
- Responsive table layout with borders and styling

**Screenshot Description:**
- Table with multiple activity rows
- Clean styling with alternating row colors
- Header row in light gray

### 9.4 Responsive Design Elements

**Features:**
- Maximum width of 700px for optimal readability
- Centered layout with 40px top margin
- Box shadows for depth
- Rounded corners (8px border-radius)
- Color scheme: Blue (#005a9c, #007bff) for headers and buttons
- Hover effects on buttons
- Grid-based form layout with 15px gaps

---

## 10. Advanced Database Features

### 10.1 Function: GetEmissionFactor

**Purpose:** Retrieves the emission factor for a given activity type and region.

**Code:**
```sql
DELIMITER $$
CREATE FUNCTION GetEmissionFactor(
    activity_type_in VARCHAR(100),
    region_id_in INT
)
RETURNS DECIMAL(12,6)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE factor_val DECIMAL(12,6);
    
    SELECT factor_value INTO factor_val
    FROM emission_factor
    WHERE activity_type = activity_type_in 
      AND region_id = region_id_in;
    
    IF factor_val IS NULL THEN
        SET factor_val = 1.0; -- Default factor
    END IF;
    
    RETURN factor_val;
END$$
DELIMITER ;
```

**Characteristics:**
- Deterministic function
- Returns default value (1.0) if no matching factor found
- Handles NULL cases gracefully

### 10.2 Stored Procedure: LogUserActivity

**Purpose:** Logs a user activity and automatically calculates carbon footprint.

**Code:**
```sql
DELIMITER $$
CREATE PROCEDURE LogUserActivity(
    IN user_id_in INT,
    IN act_name_in VARCHAR(150),
    IN act_type_in VARCHAR(100),
    IN quantity_in DECIMAL(12,3),
    IN date_in DATE
)
BEGIN
    DECLARE user_region_id INT;
    DECLARE new_emission_factor DECIMAL(12,6);
    DECLARE calculated_emission DECIMAL(12,3);
    DECLARE new_activity_id INT;

    -- Get user's region
    SELECT region_id INTO user_region_id
    FROM userregion
    WHERE user_id = user_id_in
    LIMIT 1;

    -- Default to region 1 if user has no region
    IF user_region_id IS NULL THEN
        SET user_region_id = 1;
    END IF;

    -- Get emission factor using function
    SET new_emission_factor = GetEmissionFactor(act_type_in, user_region_id);
    
    -- Calculate emission
    SET calculated_emission = quantity_in * new_emission_factor;
    
    -- Insert activity
    INSERT INTO activity (act_name, act_type, date, quantity)
    VALUES (act_name_in, act_type_in, date_in, quantity_in);
    
    SET new_activity_id = LAST_INSERT_ID();
    
    -- Insert carbon footprint
    INSERT INTO carbonfootprint (emission_val, calc_date, activity_id)
    VALUES (calculated_emission, date_in, new_activity_id);
    
    -- Link user to activity
    INSERT INTO useractivitylogs (user_id, activity_id)
    VALUES (user_id_in, new_activity_id);
END$$
DELIMITER ;
```

**Features:**
- Multi-step transaction handling
- Uses GetEmissionFactor function
- Automatic calculation of emissions
- Links activity to user through junction table
- Handles missing region data with defaults

### 10.3 Trigger: AfterFootprintInsert

**Purpose:** Automatically generates recommendations for high-emission activities.

**Code:**
```sql
DELIMITER $$
CREATE TRIGGER AfterFootprintInsert
AFTER INSERT ON carbonfootprint
FOR EACH ROW
BEGIN
    IF NEW.emission_val > 50 THEN
        INSERT INTO recommendation (activity_id, suggestion_text)
        VALUES (
            NEW.activity_id,
            'Your recent activity had a high carbon impact. Consider exploring alternatives.'
        );
    END IF;
END$$
DELIMITER ;
```

**Characteristics:**
- AFTER INSERT trigger
- Row-level trigger
- Conditional logic (emission > 50 kg CO2e)
- Automatic recommendation generation

### 10.4 Join Query Example

**Purpose:** Retrieve complete footprint history with activity details.

**Query:**
```sql
SELECT 
    c.calc_date,
    a.act_name,
    a.quantity,
    c.emission_val
FROM CarbonFootprint c
JOIN Activity a ON c.activity_id = a.activity_id
JOIN UserActivityLogs ual ON a.activity_id = ual.activity_id
WHERE ual.user_id = 1
ORDER BY c.calc_date DESC;
```

**Features:**
- Multi-table INNER JOIN
- Filters by user ID
- Orders by date (most recent first)
- Used in `/get-footprint/<user_id>` API endpoint

### 10.5 Nested Query Example

**Purpose:** Find users with above-average emissions.

**Query:**
```sql
SELECT u.name, u.email
FROM User u
WHERE u.user_id IN (
    SELECT ual.user_id
    FROM UserActivityLogs ual
    JOIN CarbonFootprint c ON ual.activity_id = c.activity_id
    GROUP BY ual.user_id
    HAVING AVG(c.emission_val) > (
        SELECT AVG(emission_val)
        FROM CarbonFootprint
    )
);
```

**Features:**
- Nested subquery with aggregation
- HAVING clause with comparison to global average
- IN operator for filtering

### 10.6 Aggregate Query Examples

**Query 1: Total Emissions by User**
```sql
SELECT 
    u.name,
    SUM(c.emission_val) AS total_emissions,
    COUNT(a.activity_id) AS activity_count,
    AVG(c.emission_val) AS avg_emission
FROM User u
JOIN UserActivityLogs ual ON u.user_id = ual.user_id
JOIN Activity a ON ual.activity_id = a.activity_id
JOIN CarbonFootprint c ON a.activity_id = c.activity_id
GROUP BY u.user_id, u.name
ORDER BY total_emissions DESC;
```

**Query 2: Emissions by Activity Type**
```sql
SELECT 
    a.act_type,
    COUNT(*) AS occurrence_count,
    SUM(c.emission_val) AS total_emissions,
    AVG(c.emission_val) AS avg_emission
FROM Activity a
JOIN CarbonFootprint c ON a.activity_id = c.activity_id
GROUP BY a.act_type
ORDER BY total_emissions DESC;
```

**Query 3: Monthly Emission Trends**
```sql
SELECT 
    YEAR(c.calc_date) AS year,
    MONTH(c.calc_date) AS month,
    SUM(c.emission_val) AS monthly_total
FROM CarbonFootprint c
GROUP BY YEAR(c.calc_date), MONTH(c.calc_date)
ORDER BY year DESC, month DESC;
```

---

## 11. Code Snippets for Invoking Database Features

### 11.1 Calling Stored Procedure from Python (Flask)

**File:** `app.py`

```python
@app.route('/log-activity', methods=['POST'])
def log_activity():
    try:
        db, cursor = get_db()
        data = request.json
        
        # Prepare arguments for stored procedure
        args = [
            int(data.get('user_id')),
            data.get('act_name'),
            data.get('act_type'),
            float(data.get('quantity')),
            data.get('date')
        ]
        
        # Call stored procedure
        cursor.callproc('LogUserActivity', args)
        
        db.commit()
        return jsonify({"message": "Activity logged successfully!"}), 201

    except mysql.connector.Error as err:
        db.rollback()
        return jsonify({"error": f"Database error: {err.msg}"}), 500
```

### 11.2 Using Function in SQL

**Direct SQL Call:**
```sql
-- Get emission factor for Diesel Transport in Region 1
SELECT GetEmissionFactor('Diesel Transport', 1) AS factor_value;
```

**In Stored Procedure:**
```sql
-- Function is called within LogUserActivity procedure
SET new_emission_factor = GetEmissionFactor(act_type_in, user_region_id);
```

### 11.3 Trigger Invocation (Automatic)

**Trigger fires automatically on INSERT:**
```python
# In Python - trigger executes automatically after this insert
cursor.execute(
    """INSERT INTO carbonfootprint (emission_val, calc_date, activity_id)
       VALUES (%s, %s, %s)""",
    (calculated_emission, date_in, activity_id)
)
# AfterFootprintInsert trigger runs automatically if emission_val > 50
```

### 11.4 Testing Queries in MySQL

**Test Function:**
```sql
-- Test the GetEmissionFactor function
SELECT GetEmissionFactor('Coal Power', 1);
-- Expected output: 0.820000
```

**Test Procedure:**
```sql
-- Test LogUserActivity procedure
CALL LogUserActivity(1, 'Test Commute', 'Diesel Transport', 25.5, '2025-11-14');

-- Verify results
SELECT * FROM Activity WHERE act_name = 'Test Commute';
SELECT * FROM CarbonFootprint ORDER BY cfp_id DESC LIMIT 1;
```

**Test Trigger:**
```sql
-- Insert high-emission footprint to trigger recommendation
INSERT INTO Activity (act_name, act_type, date, quantity)
VALUES ('Long Flight', 'Aviation', '2025-11-14', 5.0);

SET @activity_id = LAST_INSERT_ID();

INSERT INTO CarbonFootprint (emission_val, calc_date, activity_id)
VALUES (451.0, '2025-11-14', @activity_id);

-- Check if recommendation was created
SELECT * FROM Recommendation WHERE activity_id = @activity_id;
```

---

## 12. Complete SQL File Contents

### 12.1 Database Schema (create_db.sql)

```sql
/* Carbon Footprint Calculator - Database Schema */
CREATE DATABASE IF NOT EXISTS carbon_capture;
USE carbon_capture;

-- User Table
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    street VARCHAR(150),
    city VARCHAR(100),
    state VARCHAR(100)
);

-- Organisation Table
CREATE TABLE Organisation (
    org_id INT PRIMARY KEY,
    org_name VARCHAR(150) NOT NULL
);

-- Region Table
CREATE TABLE Region (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(150) NOT NULL,
    grid_type VARCHAR(100),
    country VARCHAR(100)
);

-- Emission Factor Table
CREATE TABLE Emission_factor (
    factor_id INT PRIMARY KEY,
    activity_type VARCHAR(100) NOT NULL,
    unit VARCHAR(50),
    factor_value DECIMAL(12,6) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

-- Activity Table
CREATE TABLE Activity (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    act_name VARCHAR(150) NOT NULL,
    act_type VARCHAR(100),
    date DATE,
    quantity DECIMAL(12,3) NOT NULL
);

-- Carbon Footprint Table
CREATE TABLE CarbonFootprint (
    cfp_id INT PRIMARY KEY AUTO_INCREMENT,
    emission_val DECIMAL(12,3) NOT NULL,
    calc_date DATE NOT NULL,
    activity_id INT,
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);

-- Recommendation Table
CREATE TABLE Recommendation (
    rec_id INT PRIMARY KEY AUTO_INCREMENT,
    suggestion_text TEXT NOT NULL,
    activity_id INT,
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);

-- User-Organisation Junction Table
CREATE TABLE UserOrganisation (
    user_id INT,
    org_id INT,
    PRIMARY KEY (user_id, org_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (org_id) REFERENCES Organisation(org_id)
);

-- User-Region Junction Table
CREATE TABLE UserRegion (
    user_id INT,
    region_id INT,
    PRIMARY KEY (user_id, region_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

-- User-Activity Logs Junction Table
CREATE TABLE UserActivityLogs (
    user_id INT,
    activity_id INT,
    PRIMARY KEY (user_id, activity_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);

-- Sample Data Insertion

-- Insert Regions
INSERT INTO Region (region_id, region_name, grid_type, country) VALUES
(1, 'Southern Grid', 'Thermal + Hydro', 'India'),
(2, 'Northern Grid', 'Thermal + Renewable', 'India'),
(3, 'Western Grid', 'Thermal + Solar', 'India');

-- Insert Sample Users
INSERT INTO User (user_id, name, email) VALUES
(1, 'Rohit Sharma', 'rohit.sharma@example.com'),
(2, 'Ananya Iyer', 'ananya.iyer@example.com'),
(3, 'Arjun Patel', 'arjun.patel@example.com');

-- Map Users to Regions
INSERT INTO UserRegion (user_id, region_id) VALUES
(1, 1),
(2, 1),
(3, 3);

-- Insert Emission Factors
INSERT INTO Emission_factor (factor_id, activity_type, unit, factor_value, region_id) VALUES
(1, 'Coal Power', 'kWh', 0.82, 1),
(2, 'Natural Gas Power', 'kWh', 0.45, 1),
(6, 'Diesel Transport', 'km', 0.21, 1),
(7, 'Passenger Train', 'km', 0.04, 1),
(8, 'Aviation', 'hour', 90.2, 2),
(9, 'Cooking LPG', 'kg', 2.95, 3),
(10, 'Electricity Renewable Mix', 'kWh', 0.08, 1),
(11, 'Coal Power', 'kWh', 0.95, 2),
(12, 'Diesel Transport', 'km', 0.18, 2);
```

### 12.2 Functions and Triggers (functions_triggers.sql)

```sql
/* Carbon Footprint Calculator - Functions, Procedures, and Triggers */
USE carbon_capture;

-- Function: Get Emission Factor
DELIMITER $$
CREATE FUNCTION GetEmissionFactor(
    activity_type_in VARCHAR(100),
    region_id_in INT
)
RETURNS DECIMAL(12,6)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE factor_val DECIMAL(12,6);
    
    SELECT factor_value INTO factor_val
    FROM emission_factor
    WHERE activity_type = activity_type_in
      AND region_id = region_id_in;
    
    IF factor_val IS NULL THEN
        SET factor_val = 1.0;
    END IF;
    
    RETURN factor_val;
END$$
DELIMITER ;

-- Stored Procedure: Log User Activity
DELIMITER $$
CREATE PROCEDURE LogUserActivity(
    IN user_id_in INT,
    IN act_name_in VARCHAR(150),
    IN act_type_in VARCHAR(100),
    IN quantity_in DECIMAL(12,3),
    IN date_in DATE
)
BEGIN
    DECLARE user_region_id INT;
    DECLARE new_emission_factor DECIMAL(12,6);
    DECLARE calculated_emission DECIMAL(12,3);
    DECLARE new_activity_id INT;

    -- Get user's region
    SELECT region_id INTO user_region_id
    FROM userregion
    WHERE user_id = user_id_in
    LIMIT 1;

    -- Default to region 1 if no region found
    IF user_region_id IS NULL THEN
        SET user_region_id = 1;
    END IF;

    -- Get emission factor
    SET new_emission_factor = GetEmissionFactor(act_type_in, user_region_id);
    
    -- Calculate emission
    SET calculated_emission = quantity_in * new_emission_factor;
    
    -- Insert activity
    INSERT INTO activity (act_name, act_type, date, quantity)
    VALUES (act_name_in, act_type_in, date_in, quantity_in);
    
    SET new_activity_id = LAST_INSERT_ID();
    
    -- Insert carbon footprint
    INSERT INTO carbonfootprint (emission_val, calc_date, activity_id)
    VALUES (calculated_emission, date_in, new_activity_id);
    
    -- Link user to activity
    INSERT INTO useractivitylogs (user_id, activity_id)
    VALUES (user_id_in, new_activity_id);
END$$
DELIMITER ;

-- Trigger: Generate Recommendations for High Emissions
DELIMITER $$
CREATE TRIGGER AfterFootprintInsert
AFTER INSERT ON carbonfootprint
FOR EACH ROW
BEGIN
    IF NEW.emission_val > 50 THEN
        INSERT INTO recommendation (activity_id, suggestion_text)
        VALUES (
            NEW.activity_id,
            'Your recent activity had a high carbon impact. Consider exploring alternatives.'
        );
    END IF;
END$$
DELIMITER ;
```

### 12.3 Additional Queries (queries.sql)

```sql
/* Additional Analytical Queries */
USE carbon_capture;

-- Query 1: Total emissions by user
SELECT 
    u.name,
    u.email,
    SUM(c.emission_val) AS total_emissions,
    COUNT(a.activity_id) AS total_activities,
    AVG(c.emission_val) AS avg_emission_per_activity
FROM User u
JOIN UserActivityLogs ual ON u.user_id = ual.user_id
JOIN Activity a ON ual.activity_id = a.activity_id
JOIN CarbonFootprint c ON a.activity_id = c.activity_id
GROUP BY u.user_id, u.name, u.email
ORDER BY total_emissions DESC;

-- Query 2: Emissions by activity type
SELECT 
    a.act_type,
    COUNT(*) AS times_performed,
    SUM(c.emission_val) AS total_emissions,
    AVG(c.emission_val) AS avg_emission,
    MIN(c.emission_val) AS min_emission,
    MAX(c.emission_val) AS max_emission
FROM Activity a
JOIN CarbonFootprint c ON a.activity_id = c.activity_id
GROUP BY a.act_type
ORDER BY total_emissions DESC;

-- Query 3: Users with above-average emissions (Nested Query)
SELECT u.name, u.email
FROM User u
WHERE u.user_id IN (
    SELECT ual.user_id
    FROM UserActivityLogs ual
    JOIN CarbonFootprint c ON ual.activity_id = c.activity_id
    GROUP BY ual.user_id
    HAVING AVG(c.emission_val) > (
        SELECT AVG(emission_val)
        FROM CarbonFootprint
    )
);

-- Query 4: Monthly emission trends
SELECT 
    YEAR(c.calc_date) AS year,
    MONTH(c.calc_date) AS month,
    SUM(c.emission_val) AS monthly_total,
    COUNT(*) AS activity_count,
    AVG(c.emission_val) AS avg_emission
FROM CarbonFootprint c
GROUP BY YEAR(c.calc_date), MONTH(c.calc_date)
ORDER BY year DESC, month DESC;

-- Query 5: Emission factors by region
SELECT 
    r.region_name,
    r.grid_type,
    ef.activity_type,
    ef.factor_value,
    ef.unit
FROM Region r
JOIN Emission_factor ef ON r.region_id = ef.region_id
ORDER BY r.region_name, ef.activity_type;

-- Query 6: Activities with recommendations
SELECT 
    a.act_name,
    a.act_type,
    a.date,
    c.emission_val,
    r.suggestion_text
FROM Activity a
JOIN CarbonFootprint c ON a.activity_id = c.activity_id
JOIN Recommendation r ON a.activity_id = r.activity_id
ORDER BY c.emission_val DESC;

-- Query 7: Regional comparison of emissions
SELECT 
    reg.region_name,
    reg.country,
    COUNT(DISTINCT u.user_id) AS user_count,
    COUNT(a.activity_id) AS total_activities,
    SUM(c.emission_val) AS total_emissions,
    AVG(c.emission_val) AS avg_emission_per_activity
FROM Region reg
JOIN UserRegion ur ON reg.region_id = ur.region_id
JOIN User u ON ur.user_id = u.user_id
LEFT JOIN UserActivityLogs ual ON u.user_id = ual.user_id
LEFT JOIN Activity a ON ual.activity_id = a.activity_id
LEFT JOIN CarbonFootprint c ON a.activity_id = c.activity_id
GROUP BY reg.region_id, reg.region_name, reg.country
ORDER BY total_emissions DESC;

-- Query 8: Recent high-impact activities (Last 30 days)
SELECT 
    u.name AS user_name,
    a.act_name,
    a.act_type,
    a.date,
    a.quantity,
    c.emission_val,
    CASE 
        WHEN c.emission_val > 100 THEN 'Very High'
        WHEN c.emission_val > 50 THEN 'High'
        WHEN c.emission_val > 20 THEN 'Medium'
        ELSE 'Low'
    END AS impact_level
FROM User u
JOIN UserActivityLogs ual ON u.user_id = ual.user_id
JOIN Activity a ON ual.activity_id = a.activity_id
JOIN CarbonFootprint c ON a.activity_id = c.activity_id
WHERE a.date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY c.emission_val DESC;

-- Query 9: User activity summary with region details
SELECT 
    u.user_id,
    u.name,
    u.email,
    u.city,
    u.state,
    r.region_name,
    r.grid_type,
    COUNT(a.activity_id) AS total_activities,
    SUM(c.emission_val) AS total_emissions
FROM User u
JOIN UserRegion ur ON u.user_id = ur.user_id
JOIN Region r ON ur.region_id = r.region_id
LEFT JOIN UserActivityLogs ual ON u.user_id = ual.user_id
LEFT JOIN Activity a ON ual.activity_id = a.activity_id
LEFT JOIN CarbonFootprint c ON a.activity_id = c.activity_id
GROUP BY u.user_id, u.name, u.email, u.city, u.state, r.region_name, r.grid_type
ORDER BY total_emissions DESC;

-- Query 10: Most carbon-intensive activity types per region
SELECT 
    r.region_name,
    a.act_type,
    AVG(c.emission_val) AS avg_emission,
    COUNT(*) AS frequency
FROM Region r
JOIN UserRegion ur ON r.region_id = ur.region_id
JOIN UserActivityLogs ual ON ur.user_id = ual.user_id
JOIN Activity a ON ual.activity_id = a.activity_id
JOIN CarbonFootprint c ON a.activity_id = c.activity_id
GROUP BY r.region_name, a.act_type
ORDER BY r.region_name, avg_emission DESC;
```

---

## 13. GitHub Repository Link

**Repository URL:** [To be provided]

**Repository Structure:**
```
carbon-footprint-calculator/
├── .gitattributes
├── README.md
├── app.py
├── create_db.sql
├── functions_triggers.sql
├── erdiag.svg
├── static/
│   ├── app.js
│   └── register.js
└── templates/
    ├── index.html
    └── register.html
```

**Setup Instructions (from README):**
1. Ensure MySQL is running on localhost
2. Update credentials in `app.py`:
   - `MYSQL_USER`: Your MySQL username
   - `MYSQL_PASSWORD`: Your MySQL password
   - `MYSQL_DB`: 'carbon_capture'
3. Install required Python libraries:
   ```bash
   pip install flask mysql-connector-python
   ```
4. Initialize database:
   ```bash
   mysql -u root -p < create_db.sql
   mysql -u root -p < functions_triggers.sql
   ```
5. Run the application:
   ```bash
   python app.py
   ```
6. Access at `http://localhost:5000`

---

## 14. Key Implementation Highlights

### 14.1 Database Design Decisions

**Normalization:**
- Database follows 3NF (Third Normal Form)
- Separate tables for entities with junction tables for many-to-many relationships
- Minimized data redundancy

**Regional Emission Factors:**
- Emission factors vary by region and grid type
- Accounts for different energy sources (Thermal, Hydro, Solar, Renewable)
- Enables accurate carbon calculations based on user location

**Automatic ID Generation:**
- `activity_id`, `cfp_id`, and `rec_id` use AUTO_INCREMENT
- Simplifies insertion and ensures unique identifiers

### 14.2 Backend Architecture

**Flask Application Structure:**
- Modular route design separating page rendering and API endpoints
- Database connection pooling via Flask's `g` object
- Proper error handling with rollback on failures
- JSON-based API responses for frontend consumption

**API Endpoints:**
- `GET /` - Serves main logging page
- `GET /register` - Serves registration page
- `POST /register` - Creates new user account
- `POST /log-activity` - Logs activity and calculates emissions
- `GET /get-footprint/<user_id>` - Retrieves user's emission history

### 14.3 Frontend Design

**User Experience:**
- Clean, modern interface with consistent styling
- Real-time form validation
- Asynchronous data submission (no page reloads)
- Dynamic content loading for footprint history
- Clear success/error messaging

**JavaScript Architecture:**
- Separate JS files for different pages (app.js, register.js)
- Event-driven programming with `addEventListener`
- Fetch API for AJAX requests
- Dynamic DOM manipulation for table generation

### 14.4 Data Flow

**Activity Logging Flow:**
1. User submits activity form
2. JavaScript captures form data
3. POST request sent to `/log-activity`
4. Flask calls `LogUserActivity` stored procedure
5. Procedure:
   - Retrieves user's region
   - Calls `GetEmissionFactor` function
   - Calculates emission value
   - Inserts into Activity, CarbonFootprint, and UserActivityLogs tables
6. `AfterFootprintInsert` trigger checks emission value
7. If > 50 kg CO2e, recommendation is auto-generated
8. Success response returned to frontend

### 14.5 Security Considerations

**Implemented:**
- SQL injection prevention through parameterized queries
- Email uniqueness constraint
- Foreign key constraints maintain referential integrity
- Database rollback on errors

**Future Enhancements:**
- User authentication and password hashing
- Session management
- Input sanitization on frontend
- HTTPS encryption for production
- Rate limiting on API endpoints

---

## 15. Testing and Validation

### 15.1 Test Cases

**Test Case 1: User Registration**
- **Input:** Valid user details with unique user_id and email
- **Expected:** User created, assigned to default region (Region 1)
- **Result:** ✓ Pass

**Test Case 2: Duplicate User Registration**
- **Input:** Same user_id or email as existing user
- **Expected:** Error message "User ID or Email already exists"
- **Result:** ✓ Pass

**Test Case 3: Activity Logging with Low Emission**
- **Input:** Passenger Train, 10 km
- **Expected:** Emission calculated (0.4 kg CO2e), no recommendation
- **Result:** ✓ Pass

**Test Case 4: Activity Logging with High Emission**
- **Input:** Aviation, 2 hours
- **Expected:** Emission calculated (180.4 kg CO2e), recommendation generated
- **Result:** ✓ Pass

**Test Case 5: Data Retrieval**
- **Input:** Valid user_id with logged activities
- **Expected:** Table displaying all activities with dates and emissions
- **Result:** ✓ Pass

**Test Case 6: Empty Data Retrieval**
- **Input:** user_id with no activities
- **Expected:** Message "No data found for this user"
- **Result:** ✓ Pass

### 15.2 Database Integrity Tests

**Foreign Key Validation:**
```sql
-- Attempt to insert activity with non-existent user
INSERT INTO UserActivityLogs (user_id, activity_id) VALUES (999, 1);
-- Expected: Error due to foreign key constraint
```

**Trigger Validation:**
```sql
-- Insert high-emission footprint
INSERT INTO CarbonFootprint (emission_val, calc_date, activity_id) 
VALUES (75.5, '2025-11-14', 1);

-- Verify recommendation was created
SELECT * FROM Recommendation WHERE activity_id = 1;
-- Expected: One recommendation entry
```

---

## 16. Conclusion and Future Enhancements

### 16.1 Project Summary

The Carbon Footprint Calculator successfully implements a comprehensive database-driven application for tracking and analyzing individual carbon emissions. The system leverages advanced MySQL features including stored procedures, functions, and triggers to automate calculations and provide intelligent recommendations.

Key achievements:
- ✓ Fully normalized relational database design
- ✓ Region-specific emission factor calculations
- ✓ Automated carbon footprint computation
- ✓ Real-time recommendation generation
- ✓ Interactive web interface with modern design
- ✓ RESTful API architecture

### 16.2 Learning Outcomes

**Database Concepts:**
- Entity-Relationship modeling and schema design
- Normalization and relationship management
- Stored procedures and functions
- Triggers for automated actions
- Complex multi-table joins
- Aggregate functions and grouping

**Full-Stack Development:**
- Flask framework for Python web applications
- MySQL integration with Python
- RESTful API design
- Frontend-backend communication
- Asynchronous JavaScript (Fetch API)
- Responsive web design

### 16.3 Future Enhancement Opportunities

**Authentication & Authorization:**
- User login system with password hashing
- Session management and JWT tokens
- Role-based access control (admin, regular user)
- OAuth integration for social login

**Advanced Analytics:**
- Data visualization with charts (Chart.js, D3.js)
- Comparison with regional/national averages
- Carbon offset recommendations
- Goal setting and progress tracking
- Predictive analytics for future emissions

**Enhanced Features:**
- Organization-level dashboards for companies
- Leaderboards for gamification
- Social sharing capabilities
- Mobile app development
- Export data to PDF/Excel
- Integration with IoT devices for automatic logging

**Machine Learning:**
- Personalized recommendation engine
- Anomaly detection for unusual emission patterns
- Predictive modeling for emission trends
- Activity classification from text descriptions

**Scalability:**
- Migration to PostgreSQL or cloud databases
- Caching layer (Redis) for performance
- Load balancing for multiple servers
- Microservices architecture
- Docker containerization

**Data Enrichment:**
- Integration with external APIs (weather, transport)
- Expanded emission factor database
- Country-specific calculations
- Real-time grid emission data

---

## 17. References and Resources

### 17.1 Technical Documentation
- MySQL 8.0 Reference Manual: https://dev.mysql.com/doc/
- Flask Documentation: https://flask.palletsprojects.com/
- Python mysql-connector Documentation: https://dev.mysql.com/doc/connector-python/

### 17.2 Carbon Emission Data Sources
- IPCC Guidelines for National Greenhouse Gas Inventories
- EPA Emission Factors for Greenhouse Gas Inventories
- India's National Electricity Grid Emission Factors

### 17.3 Design Resources
- MDN Web Docs (HTML/CSS/JavaScript): https://developer.mozilla.org/
- REST API Design Best Practices
- Database Normalization Guidelines

---

## Appendix A: Sample Database Queries Output

### A.1 Total Emissions by User
```
+---------------+------------------+----------------+---------------------------+
| name          | total_emissions  | total_activities | avg_emission_per_activity|
+---------------+------------------+----------------+---------------------------+
| Rohit Sharma  | 256.50          | 8              | 32.06                     |
| Ananya Iyer   | 145.30          | 12             | 12.11                     |
| Arjun Patel   | 89.75           | 6              | 14.96                     |
+---------------+------------------+----------------+---------------------------+
```

### A.2 Emissions by Activity Type
```
+---------------------------+------------------+------------------+
| act_type                  | times_performed  | total_emissions  |
+---------------------------+------------------+------------------+
| Aviation                  | 3                | 270.60           |
| Diesel Transport          | 15               | 189.00           |
| Coal Power                | 8                | 65.60            |
| Passenger Train           | 10               | 4.00             |
+---------------------------+------------------+------------------+
```

---

## Appendix B: Installation Troubleshooting

### B.1 Common Issues

**Issue 1: MySQL Connection Error**
```
Error: Can't connect to MySQL server on 'localhost'
Solution: Ensure MySQL service is running
  - Windows: Check Services
  - Mac/Linux: sudo systemctl start mysql
```

**Issue 2: Import Error for mysql.connector**
```
Solution: pip install mysql-connector-python
```

**Issue 3: Stored Procedure Not Found**
```
Solution: Run functions_triggers.sql after create_db.sql
```

**Issue 4: Flask Port Already in Use**
```
Solution: Change port in app.py:
  app.run(debug=True, port=5001)
```

---

## Team Contributions

| Team Member | Contributions |
|-------------|---------------|
| [Member 1]  | Database design, ER diagram, Schema creation |
| [Member 2]  | Stored procedures, Functions, Triggers |
| [Member 3]  | Flask backend, API development |
| [Member 4]  | Frontend HTML/CSS/JavaScript |
| [Member 5]  | Testing, Documentation, Report |

---

## Acknowledgments

We would like to thank:
- Our course instructor for guidance on database design principles
- Teaching assistants for technical support
- Online communities (Stack Overflow, MySQL forums) for troubleshooting assistance

---

**Project Completion Date:** November 14, 2025

**Report Version:** 1.0

---

*End of Report*