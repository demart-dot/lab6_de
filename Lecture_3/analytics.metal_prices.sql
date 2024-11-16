-- Створення бази даних
CREATE DATABASE IF NOT EXISTS analytics;
USE analytics;

-- Створення таблиці metal_prices
CREATE TABLE metal_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    metal_name VARCHAR(50) NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    date_entry DATE NOT NULL
);

-- Додавання даних
INSERT INTO metal_prices (metal_name, price_per_unit, unit, date_entry)
VALUES 
('Gold', 1900.50, 'ounce', '2024-11-01'),
('Silver', 24.35, 'ounce', '2024-11-02'),
('Platinum', 950.75, 'troy ounce', '2024-11-03'),
('Gold', 1915.20, 'troy ounce', '2024-11-04'),
('Silver', 24.50, 'troy ounce', '2024-11-05');

-- Запит для приведення дат до єдиного формату та конвертації цін до тройської унції
SELECT 
    id,
    metal_name,
    -- Конвертація ціни до однієї одиниці виміру (тройська унція = унція)
    CASE 
        WHEN unit = 'ounce' THEN price_per_unit
        WHEN unit = 'troy ounce' THEN price_per_unit * 1.0
        ELSE NULL
    END AS price_per_troy_ounce,
    DATE_FORMAT(date_entry, '%Y-%m-%d') AS formatted_date
FROM metal_prices;

-- Видалення таблиці та бази даних для очищення
DROP TABLE IF EXISTS metal_prices;
DROP DATABASE IF EXISTS analytics;