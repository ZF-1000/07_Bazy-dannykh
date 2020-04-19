# ========================================= Представления =========================================
USE auto_ru;


-- найдём автомобили с автоматической кпп, с пробегом не больше 50 000 км, хозяина объявления с контактными данными и отзыв об авто
-- DROP VIEW IF EXISTS view_automatic_gearbox;
CREATE OR REPLACE VIEW view_automatic_gearbox AS
(SELECT 
	CONCAT(users.lastname, ' ', users.firstname, '___', users.phone, '___', users.email ) AS owner,
	CONCAT(car_brand, '  <<', car_model, '>>') AS car,
	gear_box,
	car_mileage,
	review.body
	FROM vehicle
		JOIN users ON (vehicle.user_id = users.id)
		JOIN review ON (vehicle.user_id = review.vehicle_id)
	WHERE gear_box = 'Автоматическая' AND car_mileage <= '50000'
	ORDER BY car_mileage DESC)
;

SELECT * FROM view_automatic_gearbox;



-- найдём ценовой диапазон для машин каждого производителя, а также среднюю цену
-- DROP VIEW IF EXISTS view_car_price;
CREATE OR REPLACE VIEW view_car_price AS
(SELECT 
	id,
	car_brand,
	max(price) as max_price,
	min(price) as min_price,
	avg(price) as avg_price
	FROM vehicle
GROUP BY car_brand)
;

SELECT * FROM view_car_price;