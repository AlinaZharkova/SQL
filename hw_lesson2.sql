USE homework;
/* 1. Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными */

CREATE TABLE sales
(
    id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    order_date DATE, 
    count_product INT DEFAULT 0
);

INSERT INTO sales (order_date, count_product)
VALUES ('2022-01-01', 156),
	   ('2022-01-02', 180),
	   ('2022-01-03', 21),
	   ('2022-01-04', 124),
	   ('2022-01-05', 341);
SELECT * FROM sales;


/* 2. Сгруппируйте значений количества в 3 сегмента — меньше 100, 100-300 и больше 300. */

SELECT id AS "id заказа",
    IF(count_product < 100, "Маленький заказ", 
        IF(count_product BETWEEN 100 AND 300, "Средний заказ", "Большой заказ")) 
    AS "Тип заказа"
  FROM sales;


/* 3.Создайте таблицу “orders”, заполните ее значениями. Покажите “полный” статус заказа, используя оператор CASE */

CREATE TABLE orders
(
    id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
	employee_id VARCHAR(20) UNIQUE,
    amount DECIMAL(5,2) DEFAULT 0.00,
    order_status VARCHAR(20)
);

INSERT INTO orders (employee_id, amount, order_status)
VALUES ('e03', 15.00, 'OPEN'),
       ('e01', 25.50, 'OPEN'),
       ('e05', 100.70, 'CLOSED'),
       ('e02', 22.18, 'OPEN'),
       ('e04', 9.50, 'CANCELLED');

SELECT * FROM orders;

SELECT employee_id, amount, order_status,
  CASE
      WHEN order_status = 'OPEN' THEN "Order is in open state"
      WHEN order_status = 'CLOSED' THEN "Order is closed"
      ELSE "Order is cancelled"
   END AS full_order_status
FROM orders;


/* 4.Чем 0 отличается от NULL? */

/*
0 - это вполне себе определенное значение, 
а NULL - это отсутствие каких-либо значений/ значение не определено.
С 0 возможно совершать какие-либо операции, с NULL же нет.
*/


