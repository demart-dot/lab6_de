import pandas as pd
import numpy as np
import random
import string

# Helper functions to create dirty data
def random_string(length):
    """Generate a random string of fixed length."""
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def dirty_names(name):
    """Randomly mess up names (lowercase, uppercase, or mixed case)."""
    return random.choice([name.upper(), name.lower(), name.capitalize(), name[::-1]])

def random_email(name):
    """Create random emails with incorrect domains or messed-up formats."""
    domains = ["@example.com", "@sample.com", "@mail.com", "@website.org"]
    if random.random() < 0.2:  # 20% chance of wrong domain
        return name.lower() + random_string(3) + random.choice(domains)
    return name.lower() + random.choice(["@", "_"]) + random.choice(domains)

def dirty_values(val, chance_of_null=0.1, chance_of_error=0.05):
    """Introduce random NULLs or incorrect values."""
    if random.random() < chance_of_null:
        return None
    if random.random() < chance_of_error:
        return random.choice([val * -1, None, random_string(5)])  # Error scenarios
    return val


def dirty_timestamp():
    """Generate dirty timestamps with diverse formats."""
    # Common date and time formats
    formats = [
        "%Y-%m-%d %H:%M:%S",  # Standard ISO format
        "%m/%d/%Y %I:%M %p",  # US format with AM/PM
        "%Y/%m/%d",  # Just date
        "%d-%b-%Y",  # Day-Month-Year format with month abbreviation
        "%B %d, %Y",  # Full month name format
        "%Y-%m-%d",  # Date only (ISO format)
        "%m/%d/%y",  # US short year format
        "%d-%m-%Y %H:%M:%S",  # European format with 24-hour time
        "%d/%m/%Y",  # European format date only
        "INVALID DATE"  # Simulating an invalid timestamp
    ]

    # Randomly select a format and generate a timestamp
    base_date = pd.to_datetime(np.random.choice(pd.date_range('2024-01-01', '2024-09-30')))

    # 10% chance of an invalid date or format
    if random.random() < 0.1:
        return "INVALID DATE"

    chosen_format = random.choice(formats)

    return base_date.strftime(chosen_format)

if __name__ == "__main__":
    # Create larger datasets with dirty data (each around 10 MB)
    n_records = 500000  # Number of records for 10 MB size datasets

    # Customers dataset
    first_names = ['John', 'Jane', 'Jim', 'Jill', 'Jack', 'Alex', 'Anna', 'Mike', 'Lucy', 'Sam']
    last_names = ['Doe', 'Beam', 'Smith', 'Daniels', 'Lee', 'Don', 'Tyson', 'Rogers', 'Parker', 'Williams']
    cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Miami', 'Seattle', 'Boston', 'Austin']
    customers_data = {
        "customer_id": range(1, n_records + 1),
        "first_name": [dirty_names(random.choice(first_names)) for _ in range(n_records)],
        "last_name": [dirty_names(random.choice(last_names)) for _ in range(n_records)],
        "city": [random.choice(cities) for _ in range(n_records)],
        "age": [dirty_values(random.randint(18, 70), 0.1, 0.02) for _ in range(n_records)],
        "email": [random_email(random.choice(first_names)) for _ in range(n_records)]
    }

    customers_df = pd.DataFrame(customers_data)
    customers_df.to_csv('data/dbt/customers_dirty.csv', index=False)

    # Products dataset
    product_names = ['Laptop', 'Smartphone', 'Headphones', 'Monitor', 'Keyboard']
    categories = ['Electronics', 'Accessories']
    products_data = {
        "product_id": range(1001, 1001 + n_records),
        "product_name": [dirty_names(random.choice(product_names)) for _ in range(n_records)],
        "category": [random.choice(categories) for _ in range(n_records)],
        "price": [dirty_values(random.uniform(10.0, 1000.0), 0.05, 0.01) for _ in range(n_records)]
    }

    products_df = pd.DataFrame(products_data)
    products_df.to_csv('data/dbt/products_dirty.csv', index=False)

    # Orders dataset
    orders_data = {
        "order_id": range(101, 101 + n_records),
        "customer_id": [random.randint(1, n_records) for _ in range(n_records)],
        "order_date": [dirty_timestamp() for _ in range(n_records)],  # Using the dirty timestamp generator
        "total_amount": [random.uniform(50.0, 5000.0) for _ in range(n_records)]
    }

    orders_df = pd.DataFrame(orders_data)
    orders_df.to_csv('data/dbt/orders_dirty.csv', index=False)

    # Order Details dataset
    order_details_data = {
        "order_id": [random.randint(101, 101 + n_records) for _ in range(n_records)],
        "product_id": [random.randint(1001, 1001 + n_records) for _ in range(n_records)],
        "quantity": [dirty_values(random.randint(1, 10), 0.05, 0.01) for _ in range(n_records)],
        "unit_price": [dirty_values(random.uniform(5.0, 1500.0), 0.05, 0.02) for _ in range(n_records)]
    }

    order_details_df = pd.DataFrame(order_details_data)
    order_details_df.to_csv('data/dbt/order_details_dirty.csv', index=False)

    # Payments dataset
    payment_methods = ['Credit Card', 'PayPal', 'Debit Card', 'Cash']
    payment_statuses = ['Completed', 'Pending', 'Failed']
    payments_data = {
        "payment_id": range(501, 501 + n_records),
        "order_id": [random.randint(101, 101 + n_records) for _ in range(n_records)],
        "payment_method": [random.choice(payment_methods) for _ in range(n_records)],
        "payment_status": [random.choice(payment_statuses) for _ in range(n_records)]
    }

    payments_df = pd.DataFrame(payments_data)
    payments_df.to_csv('data/dbt/payments_dirty.csv', index=False)