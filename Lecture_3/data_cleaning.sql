-- 1. create new database
CREATE DATABASE super_brand;

-- 2. create schemas
CREATE SCHEMA sales;

CREATE SCHEMA analytics;

CREATE SCHEMA marketing;

CREATE SCHEMA landing;

-- 3. create landing table
CREATE TABLE super_brand.landing.raw_sales
(
    client        VARCHAR(50),
    purchase_date VARCHAR(50),
    product       VARCHAR(50),
    price         VARCHAR(50)
);

SELECT *
FROM super_brand.landing.raw_sales;

-- 4. create clean data table
CREATE TABLE super_brand.sales.product_sales
(
    client        VARCHAR(50),
    purchase_date DATE,
    product       VARCHAR(50),
    price         DECIMAL
);

-- 5. first step clean dates
SELECT client,
       CASE
           -- If the format is '%Y-%m-%d'
           WHEN purchase_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
               TO_DATE(purchase_date, 'YYYY-MM-DD')

           -- If the format is '%d/%m/%Y'
           WHEN purchase_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
               TO_DATE(purchase_date, 'DD/MM/YYYY')

           -- If the format is '%m-%d-%Y'
           WHEN purchase_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
               TO_DATE(purchase_date, 'MM-DD-YYYY')

           -- If the format is '%Y/%m/%d'
           WHEN purchase_date ~ '^\d{4}/\d{2}/\d{2}$' THEN
               TO_DATE(purchase_date, 'YYYY/MM/DD')
           END::date,
       product
FROM super_brand.landing.raw_sales;

-- 6. second step clean price
SELECT client,
       product,
       CASE
           WHEN price LIKE '%EURO' THEN
               RTRIM(price, 'EURO')::DECIMAL(10, 2)
           WHEN price LIKE '%USD' THEN
               RTRIM(price, 'USD')::DECIMAL(10, 2)
           ELSE
               price::DECIMAL(10, 2)
           END,
       CASE
           WHEN price LIKE '%EURO' THEN
               'EURO'
           WHEN price LIKE '%USD' THEN
               'USD'
           END
FROM super_brand.landing.raw_sales;

-- 7. third step fix issue with price
SELECT client,
       product,
       CASE
           WHEN price LIKE '%EURO' THEN
               RTRIM(price, 'EURO')::DECIMAL(10, 2) * 1.2
           WHEN price LIKE '%USD' THEN
               RTRIM(price, 'USD')::DECIMAL(10, 2)
           ELSE
               price::DECIMAL(10, 2)
           END
FROM super_brand.landing.raw_sales;

-- 8. fourth step fix client name and save data
INSERT INTO super_brand.sales.product_sales_1
SELECT INITCAP(client),
       CASE
           -- If the format is '%Y-%m-%d'
           WHEN purchase_date ~ '^\d{4}-\d{2}-\d{2}$' THEN
               TO_DATE(purchase_date, 'YYYY-MM-DD')

           -- If the format is '%d/%m/%Y'
           WHEN purchase_date ~ '^\d{2}/\d{2}/\d{4}$' THEN
               TO_DATE(purchase_date, 'DD/MM/YYYY')

           -- If the format is '%m-%d-%Y'
           WHEN purchase_date ~ '^\d{2}-\d{2}-\d{4}$' THEN
               TO_DATE(purchase_date, 'MM-DD-YYYY')

           -- If the format is '%Y/%m/%d'
           WHEN purchase_date ~ '^\d{4}/\d{2}/\d{2}$' THEN
               TO_DATE(purchase_date, 'YYYY/MM/DD')
           END::date,
       lower(product),
       CASE
           WHEN price LIKE '%EURO' THEN
               RTRIM(price, 'EURO')::DECIMAL(10, 2) * 1.2
           WHEN price LIKE '%USD' THEN
               RTRIM(price, 'USD')::DECIMAL(10, 2)
           ELSE
               price::DECIMAL(10, 2)
           END
FROM super_brand.landing.raw_sales;

-- 8. Verify data
SELECT *
FROM super_brand.sales.product_sales_1;


-- 9. Create views
CREATE OR REPLACE VIEW plant_department AS
SELECT TO_CHAR(purchase_date, 'YYYY Month') AS month,
       product,
       COUNT(*)                             AS product_count
FROM super_brand.sales.product_sales_1
GROUP BY TO_CHAR(purchase_date, 'YYYY Month'),
         product;


select * from plant_department;
