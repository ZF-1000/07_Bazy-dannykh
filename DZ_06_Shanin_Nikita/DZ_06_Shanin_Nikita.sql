/*
1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
который больше всех общался с нашим пользователем.
 */

/*
Запись MAX в общем виде
SELECT MAX (поле) FROM имя_таблицы WHERE условие

Общая запись
SELECT 
	best_friend, 
	count_messages
GROUP BY best_friend
ORDER BY  count_messages DESC
LIMIT 1;
 */
use vk;


SELECT 
	(SELECT firstname from users WHERE id = best_friend_id) AS best_friend,
	MAX(count_messages) as count_messages 
		FROM 
			(SELECT best_friend_id, COUNT(*) AS count_messages -- пользователи с которыми переписывается пользоватлеь №1 + подсчет кто сколько сообщений написал
				FROM 
					(SELECT to_user_id AS best_friend_id FROM messages WHERE from_user_id = 1 -- пользователи которым пишет сообщения пользователь №1
						UNION ALL SELECT from_user_id  FROM messages WHERE to_user_id = 1) as FRIENDS -- пользователи которые пишут сообщения пользователю №1
			GROUP BY best_friend_id) AS BF
GROUP BY best_friend
ORDER BY  count_messages DESC
LIMIT 1; -- пользователь который написал больше всего сообщений пользователю №1


/*
2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
 */

/*
--пользователи моложе 10 лет
SELECT user_id, birthday FROM profiles 
WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) <= 10;

-- пользователи с лайками
SELECT * 
FROM 
	(SELECT user_id, 
		(SELECT birthday FROM profiles as B WHERE B.user_id = L.user_id) as birthday
	FROM likes as L) AS UL;
*/ 


SELECT count(*)
FROM 
	(SELECT * 
	FROM 
		(SELECT user_id, 
			(SELECT birthday FROM profiles as B WHERE B.user_id = L.user_id) as birthday
		FROM likes as L) AS T) as UL
WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) <= 10;


/*
3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
 */

/*
IF (condition, [value_if_true], [value_if_faulse])
 */

SELECT IF(
	(SELECT COUNT(id) FROM likes WHERE user_id IN 
		(SELECT user_id FROM profiles WHERE gender = "m")) -- количество пользователей male (мужской род)
	> 
	(SELECT COUNT(id) FROM likes WHERE user_id IN 
		(SELECT user_id FROM profiles WHERE gender = "f")), -- количество пользователей female (женский род)
   'male', 'female');
   
  
  