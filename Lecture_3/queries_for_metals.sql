-- 1. Видалення існуючої бази даних, якщо вона існує
DROP DATABASE IF EXISTS metals;

-- 2. Створення бази даних
CREATE DATABASE metals;

-- 3. Вибір бази даних для роботи
USE metals;

-- 4. Видалення існуючих схем та таблиць, якщо вони є
DROP SCHEMA IF EXISTS landing;
DROP SCHEMA IF EXISTS analytics;

-- 5. Створення схем
CREATE SCHEMA landing;
CREATE SCHEMA analytics;

-- 6. Створення таблиці для сирих даних (landing)
CREATE TABLE landing.raw_sales (
    client        VARCHAR(50),
    purchase_date VARCHAR(50),
    product       VARCHAR(50),
    price         VARCHAR(50)
);

-- Перевірка даних
SELECT * FROM landing.raw_sales;

-- 7. Створення таблиці для очищених даних (analytics)
CREATE TABLE analytics.product_sales (
    client        VARCHAR(50),
    purchase_date DATE,
    product       VARCHAR(50),
    price         DECIMAL(10, 2)
);

-- 8. Перший етап очищення дат
SELECT client,
       CASE
           -- Якщо формат '%Y-%m-%d'
           WHEN purchase_date REGEXP '^\d{4}-\d{2}-\d{2}$' THEN
               STR_TO_DATE(purchase_date, '%Y-%m-%d')

           -- Якщо формат '%d/%m/%Y'
           WHEN purchase_date REGEXP '^\d{2}/\d{2}/\d{4}$' THEN
               STR_TO_DATE(purchase_date, '%d/%m/%Y')

           -- Якщо формат '%m-%d-%Y'
           WHEN purchase_date REGEXP '^\d{2}-\d{2}-\d{4}$' THEN
               STR_TO_DATE(purchase_date, '%m-%d-%Y')

           -- Якщо формат '%Y/%m/%d'
           WHEN purchase_date REGEXP '^\d{4}/\d{2}/\d{2}$' THEN
               STR_TO_DATE(purchase_date, '%Y/%m/%d')
       END AS purchase_date_cleaned,
       product
FROM landing.raw_sales;

-- 9. Другий етап очищення ціни
SELECT client,
       product,
       CASE
           WHEN price LIKE '%EURO' THEN
               CAST(REPLACE(price, 'EURO', '') AS DECIMAL(10, 2))
           WHEN price LIKE '%USD' THEN
               CAST(REPLACE(price, 'USD', '') AS DECIMAL(10, 2))
           ELSE
               CAST(price AS DECIMAL(10, 2))
       END AS price_cleaned,
       CASE
           WHEN price LIKE '%EURO' THEN 'EURO'
           WHEN price LIKE '%USD' THEN 'USD'
       END AS currency
FROM landing.raw_sales;

-- 10. Третій етап виправлення ціни (якщо потрібно)
SELECT client,
       product,
       CASE
           WHEN price LIKE '%EURO' THEN
               CAST(REPLACE(price, 'EURO', '') AS DECIMAL(10, 2)) * 1.2
           WHEN price LIKE '%USD' THEN
               CAST(REPLACE(price, 'USD', '') AS DECIMAL(10, 2))
           ELSE
               CAST(price AS DECIMAL(10, 2))
       END AS price_corrected
FROM landing.raw_sales;

-- 11. Четвертий етап очищення та збереження даних
INSERT INTO analytics.product_sales
SELECT CONCAT(UPPER(SUBSTRING(client, 1, 1)), LOWER(SUBSTRING(client, 2))) AS client,
       CASE
           -- Якщо формат '%Y-%m-%d'
           WHEN purchase_date REGEXP '^\d{4}-\d{2}-\d{2}$' THEN
               STR_TO_DATE(purchase_date, '%Y-%m-%d')

           -- Якщо формат '%d/%m/%Y'
           WHEN purchase_date REGEXP '^\d{2}/\d{2}/\d{4}$' THEN
               STR_TO_DATE(purchase_date, '%d/%m/%Y')

           -- Якщо формат '%m-%d-%Y'
           WHEN purchase_date REGEXP '^\d{2}-\d{2}-\d{4}$' THEN
               STR_TO_DATE(purchase_date, '%m-%d-%Y')

           -- Якщо формат '%Y/%m/%d'
           WHEN purchase_date REGEXP '^\d{4}/\d{2}/\d{2}$' THEN
               STR_TO_DATE(purchase_date, '%Y/%m/%d')
       END AS purchase_date_cleaned,
       LOWER(product),
       CASE
           WHEN price LIKE '%EURO' THEN
               CAST(REPLACE(price, 'EURO', '') AS DECIMAL(10, 2)) * 1.2
           WHEN price LIKE '%USD' THEN
               CAST(REPLACE(price, 'USD', '') AS DECIMAL(10, 2))
           ELSE
               CAST(price AS DECIMAL(10, 2))
       END AS price_corrected
FROM landing.raw_sales;

-- 12. Перевірка даних після очищення
SELECT * FROM analytics.product_sales;

-- 13. Видалення існуючих уявлень (якщо вони є)
DROP VIEW IF EXISTS product_sales_by_month;

-- 14. Створення уявлення (views)
CREATE OR REPLACE VIEW product_sales_by_month AS
SELECT DATE_FORMAT(purchase_date, '%Y %M') AS month,
       product,
       COUNT(*) AS product_count
FROM analytics.product_sales
GROUP BY DATE_FORMAT(purchase_date, '%Y %M'), product;

SELECT * FROM product_sales_by_month;