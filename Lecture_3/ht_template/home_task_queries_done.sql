-- Видалення таблиць
DROP TABLE IF EXISTS MovieActors;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Actors;

-- Видалення бази даних
DROP DATABASE IF EXISTS MovieDatabase;

-- Створення бази даних
CREATE DATABASE IF NOT EXISTS MovieDatabase;

-- Вибір бази даних
USE MovieDatabase;

-- Створення таблиці для категорій фільмів
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Створення таблиці для фільмів
CREATE TABLE IF NOT EXISTS Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category_id INT,
    rental_revenue DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Створення таблиці для акторів
CREATE TABLE IF NOT EXISTS Actors (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Створення таблиці для акторів у фільмах
CREATE TABLE IF NOT EXISTS MovieActors (
    movie_id INT,
    actor_id INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)
);

-- Створення таблиці для інвентарю фільмів
CREATE TABLE IF NOT EXISTS Inventory (
    movie_id INT,
    quantity INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Додавання категорій
INSERT INTO Categories (name) 
VALUES 
    ('Action'), 
    ('Comedy'), 
    ('Drama'), 
    ('Children');

-- Додавання фільмів
INSERT INTO Movies (title, category_id, rental_revenue) 
VALUES 
    ('Movie 1', 1, 50000.00), 
    ('Movie 2', 2, 30000.00), 
    ('Movie 3', 1, 70000.00), 
    ('Movie 4', 3, 20000.00), 
    ('Movie 5', 4, 15000.00);

-- Додавання акторів
INSERT INTO Actors (name) 
VALUES 
    ('Actor 1'), 
    ('Actor 2'), 
    ('Actor 3'), 
    ('Actor 4');

-- Додавання акторів у фільми
INSERT INTO MovieActors (movie_id, actor_id) 
VALUES 
    (1, 1), (1, 2), 
    (2, 2), (2, 3), 
    (3, 1), (3, 4), 
    (4, 3), 
    (5, 4);

-- Додавання інвентарю
INSERT INTO Inventory (movie_id, quantity) 
VALUES 
    (1, 10), 
    (2, 0), 
    (3, 5), 
    (4, 2), 
    (5, 0);
    
-- Додавання категорій
INSERT INTO Categories (name) 
VALUES 
    ('Horror'), 
    ('Thriller'), 
    ('Romance'), 
    ('Sci-Fi');

-- Додавання фільмів
INSERT INTO Movies (title, category_id, rental_revenue) 
VALUES 
    ('Movie 6', 1, 60000.00), 
    ('Movie 7', 2, 45000.00), 
    ('Movie 8', 1, 80000.00), 
    ('Movie 9', 3, 25000.00), 
    ('Movie 10', 4, 20000.00),
    ('Movie 11', 5, 35000.00), 
    ('Movie 12', 6, 55000.00),
    ('Movie 13', 7, 30000.00),
    ('Movie 14', 8, 70000.00);
    
-- Додавання акторів
INSERT INTO Actors (name) 
VALUES 
    ('Actor 5'), 
    ('Actor 6'), 
    ('Actor 7'), 
    ('Actor 8'),
    ('Actor 9'),
    ('Actor 10');
    
-- Додавання акторів у фільми
INSERT INTO MovieActors (movie_id, actor_id) 
VALUES 
    (6, 1), (6, 2), 
    (7, 3), (7, 4),
    (8, 5), (8, 6),
    (9, 7), (9, 8),
    (10, 9), (10, 10),
    (11, 1), (11, 2), 
    (12, 3), (12, 4), 
    (13, 5), (13, 6),
    (14, 7), (14, 8);
    
-- Додавання інвентарю
INSERT INTO Inventory (movie_id, quantity) 
VALUES 
    (6, 12), 
    (7, 5), 
    (8, 8), 
    (9, 6), 
    (10, 7),
    (11, 3), 
    (12, 10), 
    (13, 0),
    (14, 9);
    
-- Перевірка фільмів, яких немає в інвентарі (не доступні)
SELECT m.title
FROM Movies m
LEFT JOIN Inventory i ON m.movie_id = i.movie_id
WHERE i.movie_id IS NULL;

-- Найбільш вигідна категорія за загальними доходами від прокату
SELECT c.name AS category, SUM(m.rental_revenue) AS total_revenue
FROM Categories c
JOIN Movies m ON c.category_id = m.category_id
WHERE m.rental_revenue > 0  -- Виключаємо фільми без прокату
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 1;

-- Підрахунок акторів у категорії 'Children' за їх кількістю появ
SELECT a.name AS actor, COUNT(ma.movie_id) AS appearance_count
FROM Actors a
JOIN MovieActors ma ON a.actor_id = ma.actor_id
JOIN Movies m ON ma.movie_id = m.movie_id
JOIN Categories c ON m.category_id = c.category_id
WHERE c.name = 'Children'
GROUP BY a.name
ORDER BY appearance_count DESC
LIMIT 3;

-- Створення індексів
CREATE INDEX idx_category_id ON Movies (category_id);
CREATE INDEX idx_actor_id ON MovieActors (actor_id);

-- Завдання на SQL до лекції 03.

/*
1. Вивести кількість фільмів в кожній категорії.
Результат відсортувати за спаданням.
*/
SELECT c.name AS category, COUNT(m.movie_id) AS movie_count
FROM Categories c
LEFT JOIN Movies m ON c.category_id = m.category_id
GROUP BY c.name
ORDER BY movie_count DESC;

/*
2. Вивести 10 акторів, чиї фільми брали на прокат найбільше.
Результат відсортувати за спаданням.
*/
SELECT a.name AS actor, SUM(m.rental_revenue) AS total_revenue
FROM Actors a
JOIN MovieActors ma ON a.actor_id = ma.actor_id
JOIN Movies m ON ma.movie_id = m.movie_id
GROUP BY a.name
ORDER BY total_revenue DESC
LIMIT 10;

/*
3. Вивести категорію фільмів, на яку було витрачено найбільше грошей
в прокаті
*/
SELECT c.name AS category, SUM(m.rental_revenue) AS total_revenue
FROM Categories c
JOIN Movies m ON c.category_id = m.category_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 1;

/*
4. Вивести назви фільмів, яких не має в inventory.
Запит має бути без оператора IN
*/
SELECT m.title
FROM Movies m
LEFT JOIN Inventory i ON m.movie_id = i.movie_id
WHERE i.movie_id IS NULL;

/*
5. Вивести топ 3 актори, які найбільше зʼявлялись в категорії фільмів “Children”.
*/
SELECT a.name AS actor, COUNT(ma.movie_id) AS appearance_count
FROM Actors a
JOIN MovieActors ma ON a.actor_id = ma.actor_id
JOIN Movies m ON ma.movie_id = m.movie_id
JOIN Categories c ON m.category_id = c.category_id
WHERE c.name = 'Children'
GROUP BY a.name
ORDER BY appearance_count DESC
LIMIT 3; 

