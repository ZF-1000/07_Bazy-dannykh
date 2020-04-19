/*
Записать скрипт, возвращающий список имён (только firstname) пользователей 
без повторений в алфавитном порядке
 */
SELECT firstname FROM users ORDER BY firstname ASC;


/*
Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных 
(поле is_active = false). Предварительно добавить такое поле в таблицу profiles 
со значением по умолчанию = true (или 1)
 */
-- ALTER TABLE profiles DROP COLUMN is_active; -- удалить поле is_active, если существует
ALTER TABLE profiles ADD COLUMN is_active TINYINT(1) DEFAULT TRUE;
UPDATE profiles SET is_active = FALSE WHERE YEAR(curdate()) - YEAR(birthday) < 18; 
SELECT user_id, birthday FROM profiles WHERE is_active = 0;


/*
Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
*/
DELETE FROM messages WHERE created_at  >= curdate();
SELECT * FROM messages;
