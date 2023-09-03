USE homework;

-- Домашнее задание к семинару 6

/* Задание 1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, 
с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно). */

-- создаем таблицу users_old, для создания аналога users
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
    id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

-- создаем процедуру для переноса данных пользователя
DROP PROCEDURE IF EXISTS sp_move_user;
DELIMITER //
CREATE PROCEDURE sp_move_user(IN user_id BIGINT)
  BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
   ROLLBACK;
   END;
-- в случае ошибки будет отмена всех изменений в таблицах

   START TRANSACTION; 
   -- Вытаскиваем все данные из начальной таблицы
   SELECT *
     INTO @user_id, @firstname, @lastname, @email
     FROM users
    WHERE id = user_id;
   
   -- Вставляем полученные данные в нашу новую таблицу
   INSERT INTO users_old
   VALUES (@user_id, @firstname, @lastname, @email);
   
   -- Удаляем скопированного пользователя из начальной таблицы, т.к. задание было переместить данные, а не скопировать
   DELETE FROM users 
    WHERE id = user_id;
   COMMIT;
END //
DELIMITER ;


-- Вызов функции отвечающей за перемещение данных пользователя с id = число
CALL sp_move_user(7);

-- Начальная таблица
SELECT * FROM users;
-- Новая таблица, куда перемещаем данные
SELECT * FROM users_old;


/* Задание 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости 
от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер",
 с 00:00 до 6:00 — "Доброй ночи". */
 
 DROP FUNCTION IF EXISTS sp_greetings;
 DELIMITER //
 CREATE FUNCTION sp_greetings()
   RETURNS VARCHAR(15)
   DETERMINISTIC
 
 BEGIN
   DECLARE greeting_text VARCHAR(15);
   DECLARE curr_time TIME;
   SET curr_time = CURRENT_TIME;
   SET greeting_text = CASE
      WHEN curr_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Доброе утро'
      WHEN curr_time BETWEEN '12:00:00' AND '17:59:59' THEN 'Добрый день'
      WHEN curr_time BETWEEN '18:00:00' AND '23:59:59' THEN 'Добрый вечер'
      ELSE 'Доброй ночи'
 END;     
 RETURN greeting_text;
END//
DELIMITER ;
   
SELECT CURRENT_TIME AS `Текущее время`, sp_greetings() AS `Приветствие`;  


 /* 
 Задание 3. (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
 communities и messages в таблицу logs помещается время и дата создания записи, название таблицы, 
 идентификатор первичного ключа.
*/

USE lesson_4;
DROP TABLE IF EXISTS logs_1;
CREATE TABLE logs_1 (
    created_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    tabl_name VARCHAR(30) NOT NULL,
    pk_id INT UNSIGNED NOT NULL
) ENGINE = ARCHIVE;

-- триггер для таблицы users
DROP TRIGGER IF EXISTS users_log;
DELIMITER //
CREATE TRIGGER users_log AFTER INSERT 
    ON users FOR EACH ROW 
BEGIN
   INSERT INTO logs_1 (created_datetime, tabl_name, pk_id)
   VALUES (NOW(), 'users', new.id);
END//
DELIMITER ;

-- триггер для таблицы communities
DROP TRIGGER IF EXISTS communities_log;
DELIMITER //
CREATE TRIGGER communities_log AFTER INSERT 
    ON communities FOR EACH ROW 
BEGIN
   INSERT INTO logs_1 (created_datetime, tabl_name, pk_id)
   VALUES (NOW(), 'communities', new.id);
END//
DELIMITER ;

-- триггер для таблицы messages
DROP TRIGGER IF EXISTS messages_log;
DELIMITER //
CREATE TRIGGER messages_log AFTER INSERT 
    ON messages FOR EACH ROW 
BEGIN
   INSERT INTO logs_1 (created_at, table_name, pk_id)
   VALUES (NOW(), 'messages', new.id);
END//
DELIMITER ;

-- Попробуем внести запись в таблицу users для порверки
INSERT INTO users (firstname, email) 
VALUES ('Biba', 'biba@mail.ru');

-- Выводим результат работы триггера
SELECT created_datetime AS `Дата и время создания записи`, 
       tabl_name AS `Название таблицы`,
       pk_id AS `Первичный ключ` 
  FROM logs_1;
