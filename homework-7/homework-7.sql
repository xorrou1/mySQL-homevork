/*  Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине */

SELECT users.id,users.name,count(users.id) AS 'number of orders', orders.created_at 
	FROM orders  
	LEFT JOIN  users  
		ON users.id = orders.user_id 
	GROUP BY users.id ;

/* Выведите список товаров products и разделов catalogs, который соответствует товару */

SELECT products.id, products.name,catalogs.name 
	FROM products 
	LEFT JOIN catalogs 
		ON catalogs.id = products.catalog_id ;

/* Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
   Поля from, to и label содержат английские названия городов, поле name — русское. 
   Выведите список рейсов flights с русскими названиями городов.
 */
 
CREATE TABLE fights (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`from` VARCHAR(100) NOT NULL COMMENT 'Город отправления',
	`to` VARCHAR(100) NOT NULL COMMENT 'Город пирбытия',
	 PRIMARY KEY (`id`),
  	 UNIQUE KEY `id` (`id`)
)ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Таблица полетов';

truncate fights;

CREATE TABLE cities (
	label VARCHAR(100) NOT NULL COMMENT 'Название города на английском',
	name VARCHAR(100) NOT NULL COMMENT 'название города на русском',
	PRIMARY KEY (label)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Таблица транслитерации городом';

ALTER TABLE shop2.fights ADD CONSTRAINT fights_FK FOREIGN KEY (`from`) REFERENCES shop2.cities(label);

INSERT INTO fights (`from`, `to`) VALUES ('moscow', 'omsc'),
										 ('novgorod','kazan'),
										 ('irkutsk','moscow'),
										 ('omsc','irkutsk'),
										 ('moscow','kazan');
										
INSERT INTO cities (label,name) VALUES  ('moscow','Москва'),
										('irkutsk', 'Иркутск'),
										('novgorod','Новгород'),
										('kazan','Казань'),
										('omsc','Омск');
									


SELECT cities.name FROM fights LEFT JOIN cities ON fights.`from` = cities.label  ORDER BY fights.id  ;
SELECT fights.id, cities.name FROM fights LEFT JOIN cities ON fights.`to` = cities.label ORDER BY fights.id  ;


	
										
