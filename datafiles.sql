-- ----------------------------------------------------
-- Geo-Specific Carbon Tracker - Database Logic (Phase 1)
-- ----------------------------------------------------

-- This script creates:
-- 1. The GetEmissionFactor FUNCTION
-- 2. The LogUserActivity PROCEDURE
-- 3. The AfterFootprintInsert TRIGGER
-- ----------------------------------------------------

--
-- Step 1: The Calculator FUNCTION
-- Finds the correct emission factor for a specific activity and region.
--
DELIMITER $$

CREATE FUNCTION GetEmissionFactor(
    activity_type_in VARCHAR(100),
    region_id_in INT
)
RETURNS DECIMAL(12,6)
DETERMINISTIC READS SQL DATA
BEGIN
    -- 1. Declare the variable to hold the factor
    DECLARE factor_val DECIMAL(12,6);
    
    -- 2. Find the one specific factor
    SELECT factor_value INTO factor_val
    FROM emission_factor
    WHERE activity_type = activity_type_in 
      AND region_id = region_id_in;
    
    -- 3. (Safety Net) If no specific factor is found
    -- for that region, we must return a default.
    IF factor_val IS NULL THEN
        SET factor_val = 1.0; 
    END IF;

    -- 4. Return the value
    RETURN factor_val;
    
END$$

DELIMITER ;

--
-- Step 2: The Main "Recipe" PROCEDURE
-- Called by the API to log a user's activity and calculate the footprint.
--
DELIMITER $$

CREATE PROCEDURE LogUserActivity(
    -- These are the inputs from the user
    IN user_id_in INT,
    IN act_name_in VARCHAR(150),   -- e.g., "Morning Commute"
    IN act_type_in VARCHAR(100),   -- e.g., "Driving (Car)"
    IN quantity_in DECIMAL(12,3),  -- e.g., 50.5
    IN date_in DATE                -- e.g., '2025-10-28'
)
BEGIN
    -- 1. Declare all variables
    DECLARE user_region_id INT;
    DECLARE new_emission_factor DECIMAL(12,6);
    DECLARE calculated_emission DECIMAL(12,3);
    DECLARE new_activity_id INT;

    -- 2. Get the user's region
    SELECT region_id INTO user_region_id
    FROM userregion
    WHERE user_id = user_id_in
    LIMIT 1; -- Get the first region if they have multiple

    -- 3. Call your function to get the geo-specific factor
    SET new_emission_factor = GetEmissionFactor(act_type_in, user_region_id);
    
    -- 4. Do the final calculation
    SET calculated_emission = quantity_in * new_emission_factor;
    
    -- 5. Insert the new activity into the 'activity' table
    INSERT INTO activity (act_name, act_type, date, quantity)
    VALUES (act_name_in, act_type_in, date_in, quantity_in);
    
    -- 6. Get the new 'activity_id' we just created
    SET new_activity_id = LAST_INSERT_ID();
    
    -- 7. Insert the final result into the 'carbonfootprint' table
    INSERT INTO carbonfootprint (emission_val, calc_date, activity_id)
    VALUES (calculated_emission, date_in, new_activity_id);
    
    -- 8. Link the user to this new activity
    INSERT INTO useractivitylogs (user_id, activity_id)
    VALUES (user_id_in, new_activity_id);

END$$

DELIMITER ;

--
-- Step 3: The Automatic "Assistant" TRIGGER
-- Watches the carbonfootprint table and adds recommendations automatically.
--
DELIMITER $$

CREATE TRIGGER AfterFootprintInsert
AFTER INSERT ON carbonfootprint
FOR EACH ROW
BEGIN
    -- 'NEW' refers to the row just inserted into 'carbonfootprint'
    
    -- Check if the new emission value is above our threshold
    IF NEW.emission_val > 50 THEN
    
        -- If it is, automatically insert a new recommendation,
        -- linking it via the 'activity_id'
        INSERT INTO recommendation (activity_id, suggestion_text)
        VALUES (NEW.activity_id, 
                'Your recent activity had a high carbon impact. Consider exploring alternatives to reduce this footprint.');
    END IF;
    
END$$

DELIMITER ;