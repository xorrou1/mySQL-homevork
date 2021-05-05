1. Создал my.cnf:
[client]
user=root
password=4uuo4ayjis
port=3360

2. Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, 
числового id и строкового name :
CREATE database example;
use example;
CREATE TABLE `users` (
  `id` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'USERS ID',
  `name` varchar(150) NOT NULL COMMENT 'users name'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE database sample;

3. Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample:
mysqldump example > example.sql;
mysql sample < example.sql;

4. Создайте дамп единственной таблицы help_keyword базы данных mysql. 
Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы:

mysqldump --where="true limit 100" mysql help_keyword > help_keyword.sql;