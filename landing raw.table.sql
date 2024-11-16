-- Створення бази даних
CREATE DATABASE IF NOT EXISTS landing;
USE landing;

-- Створення таблиці raw_table
CREATE TABLE raw_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    metal_name VARCHAR(50) NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    date_entry VARCHAR(20) NOT NULL  -- Дата зберігається у вихідному форматі як текст
);


-- Імпорт даних з CSV файлу
LOAD DATA LOCAL INFILE 'E:/ІПЗ/3 КУРС/Інженерія даних/Lab6/DAILY_PGM_Prices_London_9_30_2024.csv'
INTO TABLE raw_table
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(metal_name, price_per_unit, unit, date_entry);
-- Додавання даних вручну
INSERT INTO raw_table (metal_name, price_per_unit, unit, date_entry)
VALUES 
('Palladium', 1450.75, 'troy ounce', '2024-10-01'),
('Gold', 1920.40, 'ounce', '2024-10-02');

-- Приклад вибірки даних
SELECT * FROM raw_table;

-- Додавання прикладу зі стовпцем DOUBLE
ALTER TABLE raw_table ADD COLUMN price_in_double DOUBLE;

-- Оновлення значень для стовпця price_in_double
UPDATE raw_table
SET price_in_double = CAST(price_per_unit AS DOUBLE);

-- Перевірка нових значень
SELECT id, metal_name, price_per_unit, price_in_double, unit, date_entry
FROM raw_table;

-- Видалення таблиці
DROP TABLE IF EXISTS raw_table;

-- Видалення бази даних
DROP DATABASE IF EXISTS landing;