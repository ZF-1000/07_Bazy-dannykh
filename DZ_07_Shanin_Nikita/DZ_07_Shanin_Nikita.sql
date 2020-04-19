/*
1. Составьте список пользователей users, которые осуществили хотя бы один 
заказ orders в интернет магазине.
*/

INSERT INTO orders (user_id) VALUES (4),(6),(4),(1); -- заполним табличку заказов orders

-- Вар_1 (вложенный запрос)
SELECT 
	id,
	name
FROM users
WHERE id IN (SELECT user_id FROM orders);


-- Вар_2 (JOIN)
SELECT
	users.id,
	users.name
FROM orders
LEFT JOIN users ON (users.id=orders.user_id)
GROUP by user_id;


/*
2. Выведите список товаров products и разделов catalogs, который соответствует товару.
*/

SELECT 
	products.name, 
	catalogs.name
FROM products 
LEFT JOIN catalogs 
ON products.catalog_id = catalogs.id;


/*
3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label,
name). Поля from, to и label содержат английские названия городов, поле name — русское.
Выведите список рейсов flights с русскими названиями городов.
*/


DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS cities;

CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	`from` VARCHAR(255) NOT NULL,
	`to` VARCHAR(255) NOT NULL
);

CREATE TABLE cities (
	label VARCHAR(255) NOT NULL PRIMARY KEY,
	name VARCHAR(255) NOT NULL
);


INSERT INTO flights VALUES 
	(1,'moscow','omsk'),
	(2,'novgorod','kazan'),
	(3,'irkutsk','moscow'),
	(4,'omsk','irkutsk'),
	(5,'moscow','kazan')
;

INSERT INTO cities VALUES 
	('moscow','Москва'),
	('irkutsk','Иркутск'),
	('novgorod','Новгород'),
	('kazan','Казань'),
	('omsk','Омск')
;


SELECT 
	f.id, c1.name as from_,
	c2.name as to_ 
FROM flights as f
LEFT JOIN cities as c1 ON (c1.label = f.`from`)
LEFT JOIN cities as c2 ON (c2.label = f.`to`)
;