# ========================================= Хранимые процедуры =========================================
USE auto_ru;


-- процедура, которая в качестве параметра получает фамилию человека и выводит все машины, которые он продаёт
-- (все однофамильцы тоже будут выведены)
DROP PROCEDURE IF EXISTS procedure_search_lastname;

DELIMITER //

CREATE PROCEDURE procedure_search_lastname (search_lastname CHAR(50))
BEGIN
	SELECT
	users.id,
	CONCAT (users.firstname, ' ', users.lastname) as owner,
	CONCAT(car_brand, ' <<', car_model, '>>') AS car
	FROM vehicle
		JOIN users ON (users.id = vehicle.user_id)
	WHERE users.lastname = search_lastname
ORDER BY users.id;
END//

DELIMITER ;

CALL procedure_search_lastname('Raynor');
CALL procedure_search_lastname('Fahey');



-- процедура, которая в качестве параметра получает номер месяца и номер года и выводит все машины, которые опубликовались за указанный период
DROP PROCEDURE IF EXISTS procedure_find_by_month_and_year;

DELIMITER //

CREATE PROCEDURE procedure_find_by_month_and_year (v_month INT, v_year INT)
BEGIN
	SELECT
	vehicle.id,
	CONCAT(car_brand, ' <<', car_model, '>>') AS car,
	vehicle.price,
	CONCAT (users.firstname, ' ', users.lastname) as owner
	FROM vehicle
		JOIN advert ON (advert.vehicle_id = vehicle.id)
		JOIN users ON (users.id = vehicle.user_id)
	WHERE MONTH(advert.created_at) = v_month AND YEAR(advert.created_at) = v_year;

END//

DELIMITER ;

CALL procedure_find_by_month_and_year('04','2000');
CALL procedure_find_by_month_and_year('02','2001');



# ========================================= Триггеры =========================================

-- проверка на добавление и обновление пробега авто и его цены на NULL значения
DELIMITER //
DROP TRIGGER IF EXISTS trigger_check_mileage_and_price_before_insert//
CREATE TRIGGER trigger_check_mileage_and_price_before_insert BEFORE INSERT ON vehicle
FOR EACH ROW
BEGIN
	IF (NEW.car_mileage IS NULL) AND (NEW.price IS NULL)
    	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "car_mileage or price can`t be NULL"; 
  	END IF;
END//

DROP TRIGGER IF EXISTS trigger_check_mileage_and_price_before_update//
CREATE TRIGGER trigger_check_mileage_and_price_before_update BEFORE UPDATE ON vehicle 
FOR EACH ROW
BEGIN
  	IF (NEW.car_mileage IS NULL) AND (NEW.price IS NULL)
    	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "car_mileage or price can`t be NULL"; 
  	END IF;
END//

DELIMITER ;

-- для проверки
INSERT INTO vehicle (car_mileage, price) VALUES (NULL, NULL);	-- проверка на добавление двух NULL значений
UPDATE vehicle SET car_mileage = NULL, price = NULL; -- проверка на обновление двух NULL значений

