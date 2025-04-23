-- Active: 1745382075315@@127.0.0.1@5432@bookstore_db

-- create database
CREATE DATABASE bookstore_db;


-- create the books table

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    author VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) CHECK(price >= 0),
    stock INT CHECK(stock >= 0),
    published_year INT 
)


-- create the customers table
CREATE TABLE customers (
    id  SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
)



-- create the orders table
CREATE TABLE orders(
     id  SERIAL PRIMARY KEY,
     customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
     book_id INT REFERENCES books(id) ON DELETE CASCADE,
     quantity INT CHECK(quantity > 0),
     order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

-- insert sample data into books
INSERT INTO books (title, author, price, stock, published_year) VALUES
('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
('You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);



-- insert customers data into books
INSERT INTO customers (name, email, joined_date) VALUES
('Alice', 'alice@email.com', '2023-01-10'),
('Bob', 'bob@email.com', '2022-05-15'),
('Charlie', 'charlie@email.com', '2023-06-20');


-- insert orders data into books
INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(1, 2, 1, '2024-03-10'),
(2, 1, 1, '2024-02-20'),
(1, 3, 2, '2024-03-05');


--  find books that are out of stock
SELECT title FROM books WHERE stock = 0;



-- Retrieve the most expensive book in the store
SELECT * FROM books ORDER BY price DESC LIMIT 1;


-- total number of orders placed by each customer
SELECT c.name , COUNT(c.name) AS total_orders FROM customers AS c JOIN orders AS o ON c.id = o.customer_id GROUP BY c.name;


-- calculate the total revenue generated from book sales
SELECT SUM(b.price * o.quantity) AS total_revenue  FROM books AS b JOIN orders AS o ON o.book_id = b.id;


-- list all customers who placed more than one order
SELECT c.name, COUNT(c.name) AS orders_count FROM customers AS c JOIN orders AS o ON o.customer_id = c.id GROUP BY c.name HAVING COUNT(c.name) > 1;

-- find the average price of books in the store
SELECT AVG(price) AS avg_book_price FROM books;


-- increase the price of all books published before 2000 by 10%
UPDATE books SET price = price * 1.10 WHERE published_year < 2000;


-- delete customers who haven't placed any orders
DELETE FROM customers WHERE id NOT IN (
    SELECT DISTINCT customer_id FROM orders
);



