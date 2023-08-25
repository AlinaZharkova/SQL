USE homework;

-- Создание и заполнение таблицы для домашнего задания
CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    car_model VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
 FROM cars;


-- Домашнее задание к семинару № 5
-- Задание 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов; 

CREATE VIEW CheapCars 
  AS SELECT id, car_model, cost 
       FROM Cars 
      WHERE Cost <= 25000;
    
     SELECT *
       FROM CheapCars;    


-- Задание 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (исп. оператор ALTER VIEW) 

ALTER VIEW CheapCars 
  AS SELECT id, car_model, cost 
       FROM Cars 
      WHERE Cost <= 30000;
      
     SELECT *
       FROM CheapCars;      


-- Задание 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” (аналогично).

CREATE VIEW Skoda_Audi 
  AS SELECT id, car_model, cost 
       FROM Cars 
      WHERE car_model IN ('Skoda','Audi');

     SELECT *
       FROM Skoda_Audi; 
