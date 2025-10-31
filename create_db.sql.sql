/* Corrected create.sql */
CREATE DATABASE IF NOT EXISTS carbon_capture;
USE carbon_capture;

CREATE TABLE User (
    user_id INT PRIMARY KEY, name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL, street VARCHAR(150),
    city VARCHAR(100), state VARCHAR(100)
);
CREATE TABLE Organisation (
    org_id INT PRIMARY KEY, org_name VARCHAR(150) NOT NULL
);
CREATE TABLE Region (
    region_id INT PRIMARY KEY, region_name VARCHAR(150) NOT NULL,
    grid_type VARCHAR(100), country VARCHAR(100)
);
CREATE TABLE Emission_factor (
    factor_id INT PRIMARY KEY,
    activity_type VARCHAR(100) NOT NULL,
    unit VARCHAR(50),
    factor_value DECIMAL(12,6) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);
CREATE TABLE Activity (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    act_name VARCHAR(150) NOT NULL, act_type VARCHAR(100),
    date DATE, quantity DECIMAL(12,3) NOT NULL
);
CREATE TABLE CarbonFootprint (
    cfp_id INT PRIMARY KEY AUTO_INCREMENT,
    emission_val DECIMAL(12,3) NOT NULL, calc_date DATE NOT NULL,
    activity_id INT,
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);
CREATE TABLE Recommendation (
    rec_id INT PRIMARY KEY AUTO_INCREMENT,
    suggestion_text TEXT NOT NULL, activity_id INT,
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);
CREATE TABLE UserOrganisation (
    user_id INT, org_id INT, PRIMARY KEY (user_id, org_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (org_id) REFERENCES Organisation(org_id)
);
CREATE TABLE UserRegion (
    user_id INT, region_id INT, PRIMARY KEY (user_id, region_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);
CREATE TABLE UserActivityLogs (
    user_id INT, activity_id INT, PRIMARY KEY (user_id, activity_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (activity_id) REFERENCES Activity(activity_id)
);

-- Insert Data
INSERT INTO Region (region_id, region_name, grid_type, country) VALUES
(1, 'Southern Grid', 'Thermal + Hydro', 'India'),
(2, 'Northern Grid', 'Thermal + Renewable', 'India'),
(3, 'Western Grid', 'Thermal + Solar', 'India');

INSERT INTO User (user_id, name, email) VALUES
(1, 'Rohit Sharma', 'rohit.sharma@example.com'),
(2, 'Ananya Iyer', 'ananya.iyer@example.com'),
(3, 'Arjun Patel', 'arjun.patel@example.com');

INSERT INTO UserRegion (user_id, region_id) VALUES (1, 1), (2, 1), (3, 3);

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