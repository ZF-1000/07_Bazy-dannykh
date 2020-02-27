# ======================== Практическое задание по теме “Оптимизация запросов” ========================


/*1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
catalogs и products в таблицу logs помещается время и дата создания записи, название
таблицы, идентификатор первичного ключа и содержимое поля name.
*/


DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
	created_at DATETIME NOT NULL, -- время и дата создания записи
	target_id BIGINT NOT NULL, -- идентификатор первичного ключа
	table_name ENUM('users', 'catalogs' ,'products') NOT NULL, -- название таблицы
	name VARCHAR(255) -- содержимое поля name
) ENGINE = Archive;


DELIMITER //

DROP TRIGGER IF EXISTS trg_users_logs_create//
CREATE TRIGGER trg_users_logs_create AFTER INSERT ON users
FOR EACH ROW 
BEGIN
	INSERT INTO logs SET created_at = NOW(), 
   						target_id = NEW.id,
   						table_name = 'users',
   						name = NEW.name;
END//

DROP TRIGGER IF EXISTS trg_catalogs_logs_create//
CREATE TRIGGER trg_catalogs_logs_create AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN
	INSERT INTO logs SET created_at = NOW(), 
   						target_id = NEW.id,
   						table_name = 'catalogs',
   						name = NEW.name;
END//


DROP TRIGGER IF EXISTS trg_products_logs_create//
CREATE TRIGGER trg_products_logs_create AFTER INSERT ON products
FOR EACH ROW 
BEGIN
	INSERT INTO logs SET created_at = NOW(), 
   						target_id = NEW.id,
   						table_name = 'products',
   						name = NEW.name;
END//

DELIMITER ;


# внесём данные для проверки триггера
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1);

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20');
 
INSERT INTO catalogs (name) VALUES
  ('1Процессоры'),
  ('1Материнские платы'),
  ('1Видеокарты');
 

SELECT * FROM logs;


/*
2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
*/


# ======================== Практическое задание по теме “NoSQL” ========================
/*
1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных
IP-адресов.
*/

HSET ip_addres 127.0.0.1 1		-- HSET имя_ключа имя_атрибута значение

/*
2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному
адресу и наоборот, поиск электронного адреса пользователя по его имени.
*/

-- поиск имени по эл.адресу 
HSET name_mail n.shanin@mail.ru nik
HGET name_mail n.shanin@mail.ru

-- поиск эл.адреса по имени
HSET mail_name nik n.shanin@mail.ru
HGET mail_name nik

/*
3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД
MongoDB.
*/


shop.products.insert({
	name: 'Intel Core i3-8100',
	description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel',
	price: 7890.00,
	catalog: 'Процессоры'
})