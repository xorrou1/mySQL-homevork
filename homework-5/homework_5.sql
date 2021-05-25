
/*Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.*/
SELECT * FROM users;

UPDATE users SET created_at = NOW(),
				 updated_at = LOCALTIME();

/*Таблица users была неудачно спроектирована. 
  Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
  Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.		*/
				
-- Аналезируем таблицу 				
DESC users;

-- Привели к неправельному типу данных VARCHAR
ALTER TABLE users MODIFY COLUMN created_at VARCHAR(128) NULL COMMENT 'Время создания строки';
ALTER TABLE users MODIFY COLUMN updated_at VARCHAR(128) NULL COMMENT 'Время обновления строки';

-- Привели к правельному типу данных DATETIME
ALTER TABLE users MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки';
ALTER TABLE users MODIFY COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки';

/* В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
 * 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
 * чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей  */

SELECT * FROM storehouses_products;
-- Добавляем данные в таблицу
INSERT INTO storehouses_products(storehouse_id,product_id,value) VALUES (FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)),
																		(FLOOR(1+ RAND() *3),FLOOR(1+ RAND() *7),FLOOR(1+ RAND() *100)
);

-- добовляем в столбец value значение 0
UPDATE storehouses_products SET value = 0 WHERE id%3 = 0;

-- Делаем запрос
SELECT *, IF(value <> 0,'товар есть','товар отсутсвует') AS `group` FROM storehouses_products ORDER BY  `group`,value ;

/*Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
 * Месяцы заданы в виде списка английских названий (may, august)
*/

SELECT *, CASE 
			WHEN SUBSTRING(birthday_at,6,2) = 05
				THEN "may"
			WHEN SUBSTRING(birthday_at,6,2) = 08
				THEN "august"
			END AS `month`
		FROM users  HAVING SUBSTRING(birthday_at,6,2) IN (5,8) ;

/*Из таблицы catalogs извлекаются записи при помощи запроса. 
 * SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN*/
	
-- Порылся в интернете и пришел к выводу что как не крути придётся приводить искомый порядок к строковому виду и сортировать уже по нему
	-- Первый вариан
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIND_IN_SET(id, '5,1,2') ;
	-- Второй вариант
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY field(id , 5,1,2) ;


-- Практическое задание теме «Агрегация данных»

/*Подсчитайте средний возраст пользователей в таблице users.*/

select AVG(TIMESTAMPDIFF(year,birthday_at,NOW())) from users;

/*Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/
select * from users;

select SUM(sup) AS number_of_birthdays FROM (
	select count(birthday_at) AS sup  from users 
		GROUP BY birthday_at WITH ROLLUP
		HAVING   birthday_at
		IN (SELECT birthday_at FROM users 
					   		  	  HAVING SUBSTRING(birthday_at,6,5) 
					   		  	   	between SUBSTRING('2021-01-01',6,5) 
					   		  	   	AND (SELECT SUBSTRING(created_at,6,5) FROM users LIMIT 1)
		   ) 
) AS number_of_birthdays;

/* Подсчитайте произведение чисел в столбце таблицы */
-- Задача на вычесление факториала
CREATE TABLE factorial(
	`value` INT NOT NULL	
);

INSERT INTO factorial(`value`) VALUES (1),(2),(3),(4),(5);

SELECT (select 1
			* (`value` -4) 
			* (`value` -3) 
			* (`value` -2)
			* (`value` -1)
			* `value`
) FROM factorial where `value` = 5;










