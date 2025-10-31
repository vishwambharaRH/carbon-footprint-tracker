/* Corrected functions_triggers.sql */
USE carbon_capture;

DELIMITER $$
CREATE FUNCTION GetEmissionFactor(
    activity_type_in VARCHAR(100), region_id_in INT
)
RETURNS DECIMAL(12,6) DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE factor_val DECIMAL(12,6);
    SELECT factor_value INTO factor_val
    FROM emission_factor
    WHERE activity_type = activity_type_in AND region_id = region_id_in;
    
    IF factor_val IS NULL THEN
        SET factor_val = 1.0; 
    END IF;
    RETURN factor_val;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE LogUserActivity(
    IN user_id_in INT, IN act_name_in VARCHAR(150),
    IN act_type_in VARCHAR(100), IN quantity_in DECIMAL(12,3),
    IN date_in DATE
)
BEGIN
    DECLARE user_region_id INT;
    DECLARE new_emission_factor DECIMAL(12,6);
    DECLARE calculated_emission DECIMAL(12,3);
    DECLARE new_activity_id INT;

    SELECT region_id INTO user_region_id
    FROM userregion WHERE user_id = user_id_in LIMIT 1;

    IF user_region_id IS NULL THEN
        SET user_region_id = 1; -- Default region
    END IF;

    SET new_emission_factor = GetEmissionFactor(act_type_in, user_region_id);
    SET calculated_emission = quantity_in * new_emission_factor;
    
    INSERT INTO activity (act_name, act_type, date, quantity)
    VALUES (act_name_in, act_type_in, date_in, quantity_in);
    
    SET new_activity_id = LAST_INSERT_ID();
    
    INSERT INTO carbonfootprint (emission_val, calc_date, activity_id)
    VALUES (calculated_emission, date_in, new_activity_id);
    
    INSERT INTO useractivitylogs (user_id, activity_id)
    VALUES (user_id_in, new_activity_id);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER AfterFootprintInsert
AFTER INSERT ON carbonfootprint
FOR EACH ROW
BEGIN
    IF NEW.emission_val > 50 THEN
        INSERT INTO recommendation (activity_id, suggestion_text)
        VALUES (NEW.activity_id, 
                'Your recent activity had a high carbon impact. Consider exploring alternatives.');
    END IF;
END$$
DELIMITER ;