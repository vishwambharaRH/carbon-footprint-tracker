-- ==========================

-- 1. User Table

-- ==========================

CREATE TABLE User (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    street VARCHAR(150),
    city VARCHAR(100),
    state VARCHAR(100)
);

-- ==========================

-- 2. Organisation Table

-- ==========================

CREATE TABLE Organisation (
    org_id INT PRIMARY KEY,
    org_name VARCHAR(150) NOT NULL
);

-- ==========================

-- 3. Region Table

-- ==========================

CREATE TABLE Region (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(150) NOT NULL,
    grid_type VARCHAR(100),
    country VARCHAR(100)
);

-- ==========================

-- 4. Emission_factor Table

-- ==========================

CREATE TABLE Emission_factor (
    factor_id INT PRIMARY KEY,
    activity_type VARCHAR(100) NOT NULL,
    unit VARCHAR(50),
    factor_value DECIMAL(12,6) NOT NULL
);

-- ==========================

-- 5. Activity Table

-- ==========================

CREATE TABLE Activity (
    activity_id INT PRIMARY KEY,
    act_name VARCHAR(150) NOT NULL,
    act_type VARCHAR(100),
    date DATE,
    quantity DECIMAL(12,3) NOT NULL
);

-- ==========================

-- 6. CarbonFootprint Table

-- ==========================

CREATE TABLE CarbonFootprint (
    cfp_id INT PRIMARY KEY,
    emission_val DECIMAL(12,3) NOT NULL,
    calc_date DATE NOT NULL,
    activity_id INT,
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);

-- ==========================

-- 7. Recommendation Table

-- ==========================

CREATE TABLE Recommendation (
    rec_id INT PRIMARY KEY,
    suggestion_text TEXT NOT NULL,
    activity_id INT,
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);

-- ==========================

-- 8. UserOrganisation (member_of)

-- ==========================

CREATE TABLE UserOrganisation (
    user_id INT,
    org_id INT,
    PRIMARY KEY (user_id, org_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (org_id) REFERENCES Organisation(org_id)

);

-- ==========================

-- 9. UserRegion (BelongsTo)

-- ==========================

CREATE TABLE UserRegion (
    user_id INT,
    region_id INT,
    PRIMARY KEY (user_id, region_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

-- ==========================

-- 10. UserActivityLogs (Logs)

-- ==========================

CREATE TABLE UserActivityLogs (
    user_id INT,
    activity_id INT,
    PRIMARY KEY (user_id, activity_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);

-- ==========================
-- Organisation
-- ==========================
INSERT INTO Organisation (org_id, org_name) VALUES
(1, 'NTPC Limited'),
(2, 'Tata Power'),
(3, 'Adani Green Energy'),
(4, 'JSW Energy'),
(5, 'Neyveli Lignite Corporation');

-- ==========================
-- User
-- ==========================
INSERT INTO User (user_id, name, email, street, city, state) VALUES
(1, 'Rohit Sharma', 'rohit.sharma@example.com', '12 MG Road', 'Bengaluru', 'Karnataka'),
(2, 'Ananya Iyer', 'ananya.iyer@example.com', '45 Anna Salai', 'Chennai', 'Tamil Nadu'),
(3, 'Arjun Patel', 'arjun.patel@example.com', '56 Marine Drive', 'Mumbai', 'Maharashtra'),
(4, 'Kavita Reddy', 'kavita.reddy@example.com', '78 Banjara Hills', 'Hyderabad', 'Telangana'),
(5, 'Siddharth Mehta', 'siddharth.mehta@example.com', '90 Park Street', 'Kolkata', 'West Bengal'),
(6, 'Priya Nair', 'priya.nair@example.com', '21 Fort Rd', 'Delhi', 'Delhi'),
(7, 'Vikram Singh', 'vikram.singh@example.com', '8 Connaught Place', 'Delhi', 'Delhi'),
(8, 'Neha Gupta', 'neha.gupta@example.com', '19 Salt Lake', 'Kolkata', 'West Bengal'),
(9, 'Rakesh Yadav', 'rakesh.yadav@example.com', '67 Civil Lines', 'Lucknow', 'Uttar Pradesh'),
(10,'Meera Joshi', 'meera.joshi@example.com', '34 FC Road', 'Pune', 'Maharashtra');

-- ==========================
-- Region
-- ==========================
INSERT INTO Region (region_id, region_name, grid_type, country) VALUES
(1, 'Southern Grid', 'Thermal + Hydro', 'India'),
(2, 'Northern Grid', 'Thermal + Renewable', 'India'),
(3, 'Western Grid', 'Thermal + Solar', 'India'),
(4, 'Eastern Grid', 'Coal + Hydro', 'India'),
(5, 'North Eastern Grid', 'Hydro + Thermal', 'India');

-- ==========================
-- Emission_factor
-- ==========================
INSERT INTO Emission_factor (factor_id, activity_type, unit, factor_value) VALUES
(1, 'Coal Power', 'kWh', 0.82),
(2, 'Natural Gas Power', 'kWh', 0.45),
(3, 'Steel Production', 'ton', 2.10),
(4, 'Cement Production', 'ton', 0.95),
(5, 'Petroleum Refining', 'barrel', 0.36),
(6, 'Diesel Transport', 'km', 0.21),
(7, 'Passenger Train', 'km', 0.04),
(8, 'Aviation', 'hour', 90.2),
(9, 'Cooking LPG', 'kg', 2.95),
(10,'Electricity Renewable Mix', 'kWh', 0.08);

-- ==========================
-- Activity
-- ==========================
INSERT INTO Activity (activity_id, act_name, act_type, date, quantity) VALUES
(1, 'Coal Plant Operation', 'Coal Power', '2025-09-01', 100000),
(2, 'Gas Power Generation', 'Natural Gas Power', '2025-09-02', 50000),
(3, 'Steel Batch 1', 'Steel Production', '2025-09-03', 200),
(4, 'Cement Kiln Run', 'Cement Production', '2025-09-04', 300),
(5, 'Refining Cycle', 'Petroleum Refining', '2025-09-05', 1000),
(6, 'Truck Fleet Logistics', 'Diesel Transport', '2025-09-06', 12000),
(7, 'Rail Passenger Service', 'Passenger Train', '2025-09-07', 5000),
(8, 'Domestic Flight Mumbai-Delhi', 'Aviation', '2025-09-08', 2),
(9, 'Household LPG Use', 'Cooking LPG', '2025-09-09', 100),
(10,'Solar Plant Operation', 'Electricity Renewable Mix', '2025-09-10', 75000);

-- ==========================
-- CarbonFootprint
-- ==========================
INSERT INTO CarbonFootprint (cfp_id, emission_val, calc_date, activity_id) VALUES
(1, 82000.0, '2025-09-01', 1),
(2, 22500.0, '2025-09-02', 2),
(3, 420.0, '2025-09-03', 3),
(4, 285.0, '2025-09-04', 4),
(5, 360.0, '2025-09-05', 5),
(6, 2520.0, '2025-09-06', 6),
(7, 200.0, '2025-09-07', 7),
(8, 180.4, '2025-09-08', 8),
(9, 295.0, '2025-09-09', 9),
(10, 6000.0, '2025-09-10', 10);

-- ==========================
-- Recommendation
-- ==========================
INSERT INTO Recommendation (rec_id, suggestion_text, activity_id) VALUES
(1, 'Switch to supercritical coal technology to reduce emissions.', 1),
(2, 'Consider combined-cycle turbines for gas plants.', 2),
(3, 'Adopt electric arc furnaces for steel production.', 3),
(4, 'Use clinker substitutes to cut cement emissions.', 4),
(5, 'Implement carbon capture at refinery stacks.', 5),
(6, 'Shift freight from trucks to trains for efficiency.', 6),
(7, 'Increase train electrification with renewable energy.', 7),
(8, 'Promote biofuel blending in aviation.', 8),
(9, 'Encourage induction cooktops to replace LPG.', 9),
(10,'Expand renewable capacity to reduce grid intensity.', 10);

-- ==========================
-- UserOrganisation
-- ==========================
INSERT INTO UserOrganisation (user_id, org_id) VALUES
(1, 1),
(2, 2),
(3, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 1),
(8, 3),
(9, 4),
(10,5);

-- ==========================
-- UserRegion
-- ==========================
INSERT INTO UserRegion (user_id, region_id) VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 2),
(5, 4),
(6, 2),
(7, 1),
(8, 4),
(9, 2),
(10,5);

-- ==========================
-- UserActivityLogs
-- ==========================
INSERT INTO UserActivityLogs (user_id, activity_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10,10);
