/*-----------------------------Повторить все действия CRUD-----------------------------*/   

-- Аналезируем и редактируем таблицу communities
SELECT * FROM communities; 
DESC communities;
DELETE FROM communities WHERE id > 15;

-- Аналезируем и редактируем таблицу communities_users
SELECT * FROM communities_users;
DESC communities_users;
	/* Добовляем случайные группы в community_id */
UPDATE communities_users set community_id = FLOOR(1 + rand() * 15);

-- Аналезируем и редактируем таблицу friendship
SELECT * FROM friendship;
DESC friendship;

	/* Добовляем случайных друзей в friend_id */
UPDATE friendship set user_id = floor(1 + rand() * 100),
					friend_id = floor(1 + rand() * 100); 

	/*Исправляем случай когда user_id = friend_id*/

UPDATE friendship SET friend_id = friend_id + 1 WHERE user_id = friend_id;
 	/*!40000 ALTER TABLE `friendship` ENABLE KEYS */;

	/* Обновляем ссылки на статус */
UPDATE friendship SET status_id = FLOOR(1 + RAND() * 5);

-- Аналезируем и редактируем таблицу friendship_statuses
SELECT * FROM friendship_statuses;
DESC friendship_statuses;

	/* Удаляем лишние строки */
TRUNCATE friendship_statuses;

	/* Добавляем статусы */
INSERT INTO friendship_statuses(name) VALUES 
  ('Requested'),
  ('Confirmed'),
  ('Requested1'),
  ('Confirmed1'),
  ('Rejected');
	/* Обновляем список */
INSERT  INTO friendship_statuses (id, name) VALUES
	  (1,'Requested123'),
	  (2,'Confirmed213'),
	  (3,'Requested1312'),
	  (4,'Confirmed131'),
	  (5,'Rejected2131')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Аналезируем и редактируем таблицу media
SELECT * FROM media;
DESC media;

	/* Обновляем ссылку на пользователя - владельца */
UPDATE media SET user_id = FLOOR(1+ RAND() * 100);

	 /* Обновляем данные для ссылки на тип */
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

	/* Создаём временную таблицу форматов медиафайлов */
DROP TABLE IF EXISTS extensions;
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
	/* Заполняем значениями */
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');

	/* Обновляем ссылку на файл */
UPDATE media SET filename = CONCAT(
  'http://dropbox.net/vk/',
  filename,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

	/* Обновляем размер файлов */
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

	/* Заполняем метаданные */
UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');  

	/* Возвращаем столбцу метеданных правильный тип */
ALTER TABLE media MODIFY COLUMN metadata JSON;

-- Аналезируем и редактируем таблицу media_tupes
SELECT * FROM media_types; 
DESC media_types ;

	/* Удаляем данные из таблицы вместе с auto_increment */
TRUNCATE media_types;

	/* Вставляем новые данные */
INSERT INTO media_types(name, id) VALUES 
			  		('photo', 1),
			  		('video', 2),
			  		('audio', 3)
ON DUPLICATE KEY UPDATE name=VALUES(name);

	/* Обновляем данные для ссылки на тип */
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

-- Аналезируем и редактируем таблицу media_tupes
SELECT * FROM messages; 
DESC messages;

	/* Обновляем значения ссылок на отправителя и получателя сообщения */
UPDATE messages SET 
  from_user_id = FLOOR(1 + RAND() * 100),
  to_user_id = FLOOR(1 + RAND() * 100);

	/* Приводим в порядок временные метки */
UPDATE messages SET updated_at = NOW() WHERE updated_at < created_at;

-- Анализируем данные
SELECT * FROM profiles;
DESC profiles;

	/* Выставляем всем пол */
CREATE TEMPORARY TABLE genders (name CHAR(1));
INSERT INTO genders VALUES ('m'),('w');
UPDATE profiles SET 
	gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);


-- Анализируем данные
SELECT * FROM users;
DESC users;

	/* Приводим в порядок временные метки */
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;  

	/* Обновляем телефоны */
UPDATE users SET phone= CONCAT( 
		"+7",
		" (",
		FLOOR(1 + RAND() * 1000),
		") ",
		FLOOR(1 + RAND() * 10000000)
	); 

								 	  
/*-----------------------------Заполнить новые таблицы. - делаем справочник стран, городов-----------------------------*/      

-- Создаем таблицу contry
CREATE TABLE country(
	code CHAR(3) NOT NULL PRIMARY KEY COMMENT 'Код страны',
	name CHAR(60) NOT NULL COMMENT 'название страны'
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Страны';

	/* Добавляем данные в таблицу */
INSERT INTO `country`(code,name) VALUES ('AUS','Australia'),
								 	   ('ESP','Spain'),
								 	   ('CAN','Canada'),
								 	   ('RUS','Russian Federation');
								 	  
-- Создаем таблицу city
CREATE TABLE city(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'ID ГОРОДА',
	name VARCHAR(128) NOT NULL COMMENT 'Название города',
	contry_code CHAR(3) NOT NULL COMMENT 'Код страны',
	FOREIGN KEY (contry_code) REFERENCES country (code)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Города';

	/* Добавляем данные в таблицу */
INSERT INTO city(name,country_code) values('Sydney','AUS'),
										 ('Melbourne','AUS'),
			 							 ('Brisbane','AUS'),
										 ('Perth','AUS'),
										 ('Adelaide','AUS');
INSERT INTO city(name,country_code) values('Madrid','ESP'),
										 ('Barcelona','ESP'),
										 ('Valencia','ESP'),
										 ('Zaragoza','ESP'),
										 ('Vigo','ESP');
INSERT INTO city(name,country_code) values('Barrie','CAN'),
										 ('Kelowna','CAN'),
										 ('Sudbury','CAN'),
										 ('Delta','CAN'),
										 ('Gatineau','CAN');
INSERT INTO city(name,country_code) values('Moscow','RUS'),
									 	 ('Nizni Novgorod','RUS'),
										 ('Perm','RUS'),
										 ('Krasnodar','RUS'),
										 ('Tjumen','RUS');
										

-- Добавляем в profiles города и страны
UPDATE profiles SET country =(SELECT code FROM country ORDER BY rand() LIMIT 1),
					city = (SELECT name FROM city WHERE country_code = profiles.country ORDER BY RAND() limit 1);
				

/*-----------------------------Подобрать сервис-образец для курсовой работы-----------------------------*/ 

Так как моя нынешняя работа связана с промышленностью 
хочу немного отойти от привычных тем и сделать базу данных,
которую можно будет применить в работе, для различных видов арматуры (краны, вентиля, обратные клапаны, предохранительных устройств).
у каждого вида арматуры будут как свои индивидуальные параметры, так и общие для всех в зависимости от мест применения и физических характеристик рабочей среды.
База данных для начала из 10 таблиц, буду стараться ее делать с возможность в дальнейшем добавления новых возможностей (к примеру, логистических).

SELECT * FROM users;
select distinct last_name from users;














