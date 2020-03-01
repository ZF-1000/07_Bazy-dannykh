DROP DATABASE IF EXISTS auto_ru;
CREATE DATABASE auto_ru;
USE auto_ru;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone BIGINT NOT NULL,
    
    INDEX users_phone_idx(phone), 
    INDEX users_firstname_lastname_idx(firstname, lastname)
) comment = 'Владелец авто';


DROP TABLE IF EXISTS vehicle;
CREATE TABLE vehicle (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
    car_brand ENUM ('LADA', 'Audi', 'BMW', 'Ford', 'Honda', 'Hyundai', 'Jeep', 'Kia', 'Lexus', 'Mazda', 'Mercedes-Benz', 'Mitsubishi',
    'Nissan', 'Opel', 'Peugeot', 'Porsche', 'Renault', 'Skoda', 'SsangYong', 'Subaru', 'Suzuki', 'Toyota', 'Volkswagen',
    'Volvo', 'GAZ', 'other') NOT NULL DEFAULT 'other', -- марка авто
    car_model VARCHAR(50) NOT NULL, -- модель авто
    car_body ENUM ('Седан', 'Хэтчбек', 'Внедорожник', 'Универсал', 'Купе', 'Минивэн', 'Пикап', 
    'Лимузин', 'Фургон', 'Кабриолет') NOT NULL, -- кузов авто
    gear_box ENUM ('Автоматическая', 'Робот', 'Вариатор', 'Механическая') NOT NULL, -- кпп
    engine ENUM ('Бензин', 'Дизель', 'Гибрид', 'Электро') NOT NULL, -- двигатель
    drive ENUM ('Передний', 'Задний', 'Полный') NOT NULL, -- привод
    engine_capacity ENUM ('0.2', '0.4', '0.6', '0.8', '1.0', '1.2', '1.4', '1.6', '1.8', '2.0', '2.2', '2.4', '2.6', '2.8', '3.0',
    '3.2', '3.4', '3.6', '3.8', '4.0', '4.5', '5.0', '5.5', '6.0', '7.0', '8.0', '9.0', '10.0') NOT NULL, --  объём двигателя
    year_manufacture YEAR NOT NULL DEFAULT '1901', -- год выпуска
    car_mileage MEDIUMINT UNSIGNED DEFAULT NULL, -- пробег
    price INT UNSIGNED DEFAULT NULL, -- цена
    engine_power SMALLINT UNSIGNED DEFAULT NULL, -- мощность двигателя
    
    INDEX vehicle_car_model_idx(car_model),
    INDEX vehicle_year_manufacture_idx(year_manufacture),
    INDEX vehicle_car_mileage_idx(car_mileage),
    INDEX vehicle_price_idx(price),
    INDEX vehicle_engine_power_idx(engine_power),
    
    FOREIGN KEY (user_id) REFERENCES users(id)
) comment = 'Транспортное средство'; 


DROP TABLE IF EXISTS dealer;
CREATE TABLE dealer (
	id SERIAL PRIMARY KEY,
	vehicle_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(50) NOT NULL,
    phone BIGINT NOT NULL,
    
    INDEX dealer_name_idx(name),
    
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(id)
) comment = 'Дилер'; -- СВЯЗЬ один ко многим (dealer-vehicle)


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,	-- кто писал сообщение
    to_user_id BIGINT UNSIGNED NOT NULL,	-- кому писал 
    body TEXT,	-- тело сообщение
    created_at DATETIME DEFAULT NOW(),	-- когда написали сообщение
    
    INDEX messages_from_user_id (from_user_id),
    INDEX messages_to_user_id (to_user_id),
    
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
)comment = 'Сообщение'; -- СВЯЗЬ один ко многим (users-messages)


DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	
	INDEX communities_name_idx(name)
)comment = 'Сообщество автовладельцев'; -- СВЯЗЬ многие ко многим (users-communities)


DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  	PRIMARY KEY (user_id, community_id),
	
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
)comment = 'Связь между сообществами и владельцами авто'; -- СВЯЗЬ многие ко многим (users-communities) промежуточная таблица


DROP TABLE IF EXISTS spare_part;
CREATE TABLE spare_part(
	id SERIAL PRIMARY KEY,
	name ENUM ('Запчасти', 'Шины и диски', 'Масла и автохимия', 'Аккумуляторы', 'Аксессуары', 'Автоинструменты')
)comment = 'Запчасти'; -- СВЯЗЬ многие ко многим (spare_part-vehicle)


DROP TABLE IF EXISTS vehicle_spare_part;
CREATE TABLE vehicle_spare_part(
	vehicle_id BIGINT UNSIGNED NOT NULL,
	spare_part_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (vehicle_id, spare_part_id),
	
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(id),
    FOREIGN KEY (spare_part_id) REFERENCES spare_part(id)
)comment = 'Связь между транспортным средством и запчастями'; -- СВЯЗЬ многие ко многим (spare_part-vehicle) промежуточная таблица


DROP TABLE IF EXISTS advert;
CREATE TABLE advert(
	id SERIAL PRIMARY KEY,
	vehicle_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255), -- название
    body TEXT,	-- тело объявления
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
    
    INDEX advert_name_idx(name),
    INDEX advert_created_at_idx(created_at),
    INDEX advert_updated_at_idx(updated_at),
    
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(id)
)comment = 'Объявление'; -- СВЯЗЬ один к одному (vehicle-advert)


DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
	id SERIAL PRIMARY KEY,
	photo_name VARCHAR(150) DEFAULT NULL,
	
    FOREIGN KEY (id) REFERENCES advert(id)
)comment = 'Фотографии'; -- СВЯЗЬ один ко многим (advert-photos)


DROP TABLE IF EXISTS review;
CREATE TABLE review (
	id SERIAL PRIMARY KEY,
	vehicle_id BIGINT UNSIGNED NOT NULL,
	from_user_id BIGINT UNSIGNED NOT NULL,	-- кто писал сообщение 
    body TEXT,	-- тело сообщение
    created_at DATETIME DEFAULT NOW(),	-- когда написали сообщение
    
    INDEX review_created_at_id (created_at),
    
	FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(id)
)comment = 'Отзыв';


DROP TABLE IF EXISTS car_service;
CREATE TABLE car_service(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	
	INDEX car_service_name_idx(name)
)comment = 'Автосервис'; -- СВЯЗЬ многие ко многим (vehicle-car_service)


DROP TABLE IF EXISTS vehicle_car_service;
CREATE TABLE vehicle_car_service(
	vehicle_id BIGINT UNSIGNED NOT NULL,
	car_service_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (vehicle_id, car_service_id),
	
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(id),
    FOREIGN KEY (car_service_id) REFERENCES car_service(id)
)comment = 'Связь между транспортным средством и автосервисом'; -- СВЯЗЬ многие ко многим (vehicle-car_service) промежуточная таблица



DROP TABLE IF EXISTS expert;
CREATE TABLE expert(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	
	INDEX expert_name_idx(name)
)comment = 'Автоэксперт'; -- СВЯЗЬ многие ко многим (vehicle-expert)


DROP TABLE IF EXISTS vehicle_expert;
CREATE TABLE vehicle_expert(
	vehicle_id BIGINT UNSIGNED NOT NULL,
	expert_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (vehicle_id, expert_id),
	
	FOREIGN KEY (vehicle_id) REFERENCES vehicle(id),
    FOREIGN KEY (expert_id) REFERENCES expert(id)
)comment = 'Связь между транспортным средством и автоэкспертом'; -- СВЯЗЬ многие ко многим (vehicle-expert) промежуточная таблица


DROP TABLE IF EXISTS advert_expert;
CREATE TABLE advert_expert(
	advert_id BIGINT UNSIGNED NOT NULL,
	expert_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (advert_id, expert_id),
	
    FOREIGN KEY (advert_id) REFERENCES advert(id),
    FOREIGN KEY (expert_id) REFERENCES expert(id)
)comment = 'Связь между объявлением и автоэкспертом'; -- СВЯЗЬ многие ко многим (advert-expert) промежуточная таблица

