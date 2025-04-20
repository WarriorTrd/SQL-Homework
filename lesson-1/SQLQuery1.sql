CREATE TABLE Students(
	id INT,
	name VARCHAR(50),
	age INT
)
ALTER TABLE Students
ALTER COLUMN id INT NOT NULL;

CREATE TABLE Product(
	id INT UNIQUE,
	name VARCHAR(255),
	price DECIMAL(10, 2));

ALTER TABLE Product
DROP CONSTRAINT UQ__Product__3213E83EB9ADE882;

ALTER TABLE product 
ADD CONSTRAINT unique_product_id UNIQUE (id);

ALTER TABLE product 
ADD CONSTRAINT unique_product_id_name UNIQUE (id, name);

CREATE TABLE orders(
	order_id INT PRIMARY KEY,
	customer_name VARCHAR(255),
	order_date DATE
)
ALTER TABLE orders
DROP CONSTRAINT PK__orders__1
ALTER TABLE orders
ADD CONSTRAINT PK_orders PRIMARY KEY(order_id)

CREATE TABLE category (
    category_id INT PRIMARY KEY,  
    category_name VARCHAR(255)
);

CREATE TABLE item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(255),
    category_id INT,
    CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id) 
);
ALTER TABLE item 
DROP CONSTRAINT FK_item_category;

ALTER TABLE item 
ADD CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id);

CREATE TABLE Account(
	account_id INT PRIMARY KEY,
	balance DECIMAL(10,2) CHECK (balance>0),
	account_type VARCHAR(50) CHECK (account_type IN ('Saving', 'Checking'))
)

ALTER TABLE account 
DROP CONSTRAINT CK__Account__balance__3;

ALTER TABLE account 
DROP CONSTRAINT CK__Account__account__2;

ALTER TABLE account 
ADD CONSTRAINT CHK_balance CHECK (balance >= 0);

ALTER TABLE account 
ADD CONSTRAINT CHK_account_type CHECK (account_type IN ('Saving', 'Checking'));

CREATE TABLE customer (
    customer_id INT PRIMARY KEY, 
    name VARCHAR(255), 
    city VARCHAR(100) DEFAULT 'Unknown' 
);

ALTER TABLE customer
DROP CONSTRAINT DF__customer__city__7B

ALTER TABLE customer
ADD CONSTRAINT DF_customer DEFAULT 'Unknown' FOR city;

CREATE TABLE invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incrementing column starting from 1
    amount DECIMAL(10,2)  -- No constraint
);

INSERT INTO invoice (amount) VALUES (10.50);
INSERT INTO invoice (amount) VALUES (20.75);
INSERT INTO invoice (amount) VALUES (15.25);
INSERT INTO invoice (amount) VALUES (30.40);
INSERT INTO invoice (amount) VALUES (25.90);

SET IDENTITY_INSERT invoice ON;

INSERT INTO invoice (invoice_id, amount) VALUES (100, 50.00);

SET IDENTITY_INSERT invoice OFF;


CREATE TABLE books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL CHECK (LEN(title) > 0),
    price DECIMAL(10,2) CHECK (price > 0),
    genre VARCHAR(100) CONSTRAINT DF_books_genre DEFAULT 'Unknown'
);
INSERT INTO books (title, price, genre) VALUES ('Guliver', 10.99, 'Fiction');
INSERT INTO books (title, price, genre) VALUES ('1984', 8.50, 'Dystopian');
INSERT INTO books (title, price) VALUES ('Sherlock Holmes', 12.75);  
INSERT INTO books (title, price, genre) VALUES ('Harry Potter', 15.00, 'Adventure');
INSERT INTO books (title, price) VALUES ('Kichkina shahzoda', 9.99); 

SELECT * FROM books


CREATE TABLE Book (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    published_year INT CHECK (published_year > 0)
);

CREATE TABLE Member (
    member_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE Loan (
    loan_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE NOT NULL,
    return_date DATE NULL,
    CONSTRAINT FK_Loan_Book FOREIGN KEY (book_id) REFERENCES Book(book_id),
    CONSTRAINT FK_Loan_Member FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

INSERT INTO Book (title, author, published_year) VALUES
('Little price', 'Antuan', 1925),
('1984', 'George Orwell', 1940),
('Harry', 'Rowling', 1960);

INSERT INTO Member (name, email, phone_number) VALUES
('Alice', 'alice@example.com', '123-456-7890'),
('Bob', 'bob@example.com', '987-654-3210'),
('John', 'john@example.com', '555-666-7777');

INSERT INTO Loan (book_id, member_id, loan_date) VALUES (1, 1, '2024-02-01');

INSERT INTO Loan (book_id, member_id, loan_date) VALUES (2, 2, '2024-02-03');

INSERT INTO Loan (book_id, member_id, loan_date) VALUES (3, 3, '2024-02-05');

INSERT INTO Loan (book_id, member_id, loan_date) VALUES (2, 1, '2024-02-10');

SELECT * FROM Book;
SELECT * FROM Member;
SELECT * FROM Loan;
