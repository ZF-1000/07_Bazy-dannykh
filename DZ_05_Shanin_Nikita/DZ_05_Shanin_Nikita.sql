/*
1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
Заполните их текущими датой и временем.
*/

DROP DATABASE IF EXISTS DZ_05;
CREATE DATABASE DZ_05;
USE DZ_05;


DROP TABLE IF EXISTS users1;
CREATE TABLE users1 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT NULL,
  updated_at DATETIME DEFAULT NULL
) COMMENT = 'Покупатели';


INSERT INTO users1 (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
  

UPDATE users1 SET created_at = NOW(), updated_at = NOW();


SELECT * FROM users1;

/*
2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
*/

-- DROP DATABASE IF EXISTS DZ_05;
-- CREATE DATABASE DZ_05;
-- USE DZ_05;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';


INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Наталья', '1984-11-12', '14.05.2012 12:45', '14.05.2012 12:45'),
  ('Александр', '1985-05-20', '02.12.2010 6:00', '02.12.2010 6:00'),
  ('Сергей', '1988-02-14', '18.01.2016 15:23', '18.01.2016 15:23'),
  ('Иван', '1998-01-12', '11.06.2015 11:55', '11.06.2015 11:55'),
  ('Мария', '1992-08-29', '27.05.2013 18:34', '27.05.2013 18:34');

 
 UPDATE users SET 
 created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
 updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i'); -- преобразуем к формату DATETIME
 
-- изменим тип полей created_at и updated_at на DATETIME и установим заначение по умолчанию
ALTER TABLE users MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

SELECT * FROM users;
DESCRIBE users; -- проверим типы полей created_at и updated_at


/*
3. В таблице складских запасов storehouses_products в поле value могут встречаться самые
разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке
увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех
записей.
*/

-- DROP DATABASE IF EXISTS DZ_05;
-- CREATE DATABASE DZ_05;
-- USE DZ_05;


DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';


INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
(1, 363, 0),
(1, 124, 2500),
(1, 974, 0),
(1, 733, 30),
(1, 23, 500),
(1, 568, 1);


SELECT * FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;


/*
4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и
мае. Месяцы заданы в виде списка английских названий ('may', 'august')
*/


-- SELECT * FROM users;
SELECT name, date_format(birthday_at, '%M') FROM users; 
SELECT name FROM users WHERE date_format(birthday_at, '%M')  IN ('may', 'august');


/*
5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM
catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
*/


DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
  
SELECT * FROM catalogs WHERE id IN (5, 1, 2);
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD (id, 5, 1, 2); -- FIELD возвращает позицию значения в списке значений


/*
“Агрегация данных”

6. Подсчитайте средний возраст пользователей в таблице users
*/

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS average_age FROM users;


/*
7. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
Следует учесть, что необходимы дни недели текущего года, а не года рождения.
*/
INSERT INTO users (name, birthday_at) VALUES
  ('Юрий', '1992-08-27'),
  ('Павел', '1992-08-30'),
  ('Ольга', '1992-08-28');
 
SELECT name, birthday_at FROM users;
SELECT DATE(CONCAT_WS('-', YEAR(NOW()), MONTH (birthday_at), DAY(birthday_at))) AS day FROM users; -- дни рождения в текущем году
SELECT name, DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH (birthday_at), DAY(birthday_at))), '%W') AS day FROM users; -- дни недели ДР-ов
SELECT GROUP_CONCAT(name SEPARATOR ', '), DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH (birthday_at), DAY(birthday_at))), '%W') AS day,
COUNT(*) AS total
FROM users 
GROUP BY day
ORDER BY total DESC;


/*
(по желанию) Подсчитайте произведение чисел в столбце таблицы
*/

-- суть решения: логарифм произведения равен сумме логарифмов
SELECT id FROM catalogs;
SELECT ROUND(EXP(SUM(LN(id)))) AS product_of_number FROM catalogs;