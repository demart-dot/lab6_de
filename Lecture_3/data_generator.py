import csv
import random
from datetime import datetime, timedelta

# Sample data
surnames = ['Smith', 'Johnson', 'Williams', 'Jones', 'Brown']
names = ['John', 'Michael', 'Linda', 'Karen', 'Sarah']
products = ['Laptop', 'Phone', 'Headphones', 'Camera', 'Watch']
date_formats = ['%Y-%m-%d', '%d/%m/%Y', '%m-%d-%Y', '%Y/%m/%d']


# Function to create a random name
def random_name():
    return ''.join(random.choice([c.upper(), c.lower()]) for c in random.choice(surnames) + " " + random.choice(names))


# Function to create a random date
def random_date():
    start_date = datetime(2024, 1, 1)  # Start date
    end_date = datetime.today()  # End date
    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    random_date = start_date + timedelta(days=random_number_of_days)
    return random_date.strftime(random.choice(date_formats))


# Function to create a random price
def random_price():
    price = random.choice([round(random.uniform(10, 1000), 2), random.randint(10, 1000)])
    if random.choice([True, False]):
        price = str(price) + random.choice([' USD', ' EURO'])
    return price


# Create and write to csv
with open('data/sales_dirty.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Name', 'Purchase Date', 'Product', 'Price'])

    for _ in range(100):  # Generating 100 rows
        writer.writerow([random_name(), random_date(), random.choice(products), random_price()])

print("CSV file generated successfully.")
