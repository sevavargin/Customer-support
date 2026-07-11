CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    customer_email TEXT UNIQUE NOT NULL,
    customer_age INTEGER CHECK(customer_age >= 0),
    customer_gender TEXT
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL UNIQUE,
    purchase_date DATE
);


CREATE TABLE ticket_types (
    ticket_type_id INTEGER PRIMARY KEY,
    ticket_type_name TEXT NOT NULL UNIQUE
);


CREATE TABLE tickets (

    ticket_id INTEGER PRIMARY KEY,

    customer_id INTEGER NOT NULL,

    product_id INTEGER NOT NULL,

    ticket_type_id INTEGER NOT NULL,

    ticket_subject TEXT NOT NULL,

    ticket_description TEXT,

    ticket_status TEXT NOT NULL,

    resolution TEXT,

    ticket_priority TEXT NOT NULL,

    ticket_channel TEXT NOT NULL,

    first_response_time REAL,

    time_to_resolution REAL,

    customer_satisfaction_rating INTEGER
        CHECK(customer_satisfaction_rating BETWEEN 1 AND 5),

    FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY(product_id)
        REFERENCES products(product_id),

    FOREIGN KEY(ticket_type_id)
        REFERENCES ticket_types(ticket_type_id)

);