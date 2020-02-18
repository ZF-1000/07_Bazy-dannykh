# ================= Практическое задание по теме “Транзакции, переменные, представления” =================

/*
1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте
транзакции.
*/

DROP DATABASE IF EXISTS sample;
CREATE database sample;
use sample;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

START TRANSACTION;
	INSERT INTO sample.users (SELECT * FROM shop.users WHERE id=1);
	DELETE FROM shop.users WHERE id=1;
COMMIT;

SELECT * FROM users;


/*
2. Создайте представление, которое выводит название name товарной позиции из таблицы
products и соответствующее название каталога name из таблицы catalogs.
*/

use shop;

CREATE OR REPLACE VIEW products_catalogs_view AS 
SELECT 
	products.name AS products_name, 
	catalogs.name AS catalogs_name 
FROM products, catalogs 
WHERE products.catalog_id = catalogs.id;

SELECT * FROM products_catalogs_view;


/*
3. по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены
разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и
2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в
соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она
отсутствует.
4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте
запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих
записей.
*/



# ================= Практическое задание по теме “Хранимые процедуры и функции, триггеры" =================

/*
1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от
текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", 
с 00:00 до 6:00 — "Доброй ночи".
*/

DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello ()
RETURNS TEXT DETERMINISTIC
BEGIN
	CASE
		WHEN HOUR(NOW()) BETWEEN 6 AND 11 THEN RETURN "Доброе утро";
		WHEN HOUR(NOW()) BETWEEN 12 AND 17 THEN RETURN "Добрый день";
		WHEN HOUR(NOW()) BETWEEN 18 AND 23 THEN RETURN "Добрый вечер";
		ELSE RETURN "Доброй ночи";
	END CASE;
END//
SELECT hello(), CURTIME()//
DELIMITER ;

/*
2. В таблице products есть два текстовых поля: name с названием товара и description с его
описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля
принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь
того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
NULL-значение необходимо отменить операцию.
*/

DELIMITER //
DROP TRIGGER IF EXISTS desc_and_name_check_before_insert//
CREATE TRIGGER desc_and_name_check_before_insert BEFORE INSERT ON products  -- до вставки в таблицу
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL) AND (NEW.description IS NULL)
    	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "products name or description can`t be NULL"; 
  	END IF;
END//

DROP TRIGGER IF EXISTS desc_and_name_check_before_update//
CREATE TRIGGER desc_and_name_check_before_update BEFORE UPDATE ON products 
FOR EACH ROW
BEGIN
  	IF (NEW.name IS NULL) AND (NEW.description IS NULL)
    	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "products name or description can`t be NULL"; 
  	END IF;
END//

DELIMITER ;

INSERT INTO products (name, description) VALUES (NULL, NULL); -- проверка на добавление двух NULL значений
UPDATE products SET name = NULL, description = NULL; -- проверка на обновление двух NULL значений

/*
3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
Числами Фибоначчи называется последовательность в которой число равно сумме двух
предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.
 */