

CREATE TABLE likes (
	like_id tinyint UNSIGNED NOT null COMMENT "тип лайка",
	like_counter INT COMMENT "количество лайков",
	user_id_receiving INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, которому поставили лайки",
	user_id_giving INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который поставил лайк",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (user_id_receiving) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (user_id_giving) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (like_id) REFERENCES like_type(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT "Лайки";

-- Таблица типа лайков
CREATE table like_type (
	id tinyint unsigned NOT null PRIMARY KEY auto_increment COMMENT "идентификатор лайка",
	`type` varchar(128) NOT null COMMENT "Тип лайка: сообщение, пользователь,медиафайл",
	media_id INT UNSIGNED  COMMENT "Ссылка на медиафайл",
	messages_id INT UNSIGNED NOT NULL COMMENT "Ссылка на сообщение",
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (messages_id) REFERENCES messages(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT "Тип лайка";