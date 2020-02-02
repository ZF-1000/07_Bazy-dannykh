/*
Написать крипт, добавляющий в БД vk, которую создали на занятии, 
3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
 */
DROP TABLE IF EXISTS video_directory;
CREATE TABLE video_directory (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
)COMMENT = 'Видеокаталог';


DROP TABLE IF EXISTS video;
CREATE TABLE video (
	id SERIAL PRIMARY KEY,
	video_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (video_id) REFERENCES video_directory(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
)COMMENT = 'Видео';


DROP TABLE IF EXISTS audio_list;
CREATE TABLE audio_list (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
)COMMENT = 'Плейлисты';


DROP TABLE IF EXISTS music;
CREATE TABLE music (
	id SERIAL PRIMARY KEY,
	audio_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (audio_id) REFERENCES audio_list(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
)COMMENT = 'Музыка';


DROP TABLE IF EXISTS education;	
CREATE TABLE education (
	user_id SERIAL PRIMARY KEY,	
    country VARCHAR(255), 
    city VARCHAR(255),
	university VARCHAR(255),
	faculty VARCHAR(255),
    release_date DATE NOT NULL,
	
    INDEX education_university_faculty_idx(university, faculty),
    FOREIGN KEY (user_id) REFERENCES users(id)		
) COMMENT = 'Образование';	