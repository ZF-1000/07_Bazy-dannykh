# ========================================= Характерные выборки =========================================
USE auto_ru;

-- 5 человек у которых больше всего объявлений о продаже автомобилей 
SELECT CONCAT (users.firstname, ' ', users.lastname) as owner, count(*) as car_count FROM users
	JOIN vehicle ON (users.id = vehicle.user_id)
GROUP BY users.id
ORDER BY car_count DESC
LIMIT 5
;


-- найдём все автомобили марки LADA с фотографией из объявления, владельца авто и информацию в каком сервисе обслуживали машину
SELECT
	users.id,
	CONCAT(car_brand, ' <<', car_model, '>>') AS car,
	price,
	CONCAT(users.lastname, ' ', users.firstname) AS owner,
	car_service.name AS service_name,
	photos.photo_name AS car_photo
	FROM vehicle
		JOIN users ON (vehicle.user_id = users.id)
		JOIN car_service ON (vehicle.id = car_service.id)
		JOIN photos ON (vehicle.id = photos.id)
WHERE car_brand = 'LADA'
ORDER BY price DESC
;


-- найдём автомобили возрастом больше 45 лет, год выпуска авто, каким экспертом проводилась оценка авто, год написания объявления
SELECT 
	vehicle.id,
	CONCAT(' Год выпуска: ', year_manufacture,' ', car_brand, '  <<', car_model, '>>') AS car,
	expert.name,
	YEAR(advert.created_at) AS year_advert
	FROM vehicle
		JOIN expert ON (vehicle.id = expert.id)
		JOIN advert ON (vehicle.id = advert.vehicle_id)
	WHERE (YEAR(NOW()) - year_manufacture) >= 45
;


-- найдём среди автомобилей отечественного производства машины моложе 10 лет ИЛИ машины с пробегом не больше 30000 км
SELECT 
	'Авто моложе 10 лет',
	concat(car_brand, '<< ', car_model, '>>'),
	year_manufacture,
	car_mileage
	FROM vehicle
	WHERE (car_brand LIKE 'LADA' OR car_brand LIKE 'GAZ') and
	(YEAR(NOW()) - year_manufacture) <= 10
UNION
SELECT
	'Авто с пробегом не больше 30000 км',
	concat(car_brand, '<< ', car_model, '>>'),
	year_manufacture,
	car_mileage
	FROM vehicle
	WHERE (car_brand LIKE 'LADA' OR car_brand LIKE 'GAZ') and
	(car_mileage <= '30000')
ORDER BY year_manufacture DESC
;


