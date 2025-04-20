
CREATE TABLE Students (
    id INT NOT NULL,
    name VARCHAR(50),
    age INT
);


CREATE TABLE Product (
    id INT,
    name VARCHAR(200),
    price DECIMAL(10, 2),
    CONSTRAINT unique_product_id UNIQUE (id)
);

ALTER TABLE Product
DROP CONSTRAINT unique_product_id;

ALTER TABLE Product
ADD CONSTRAINT unique_product_id UNIQUE (id);

ALTER TABLE Product
ADD CONSTRAINT unique_product_id_name UNIQUE (id, name);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    order_date DATE
);

CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255)
);

CREATE TABLE Item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(255),
    category_id INT,
    CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

ALTER TABLE Item 
DROP CONSTRAINT FK_item_category;

ALTER TABLE Item 
ADD CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES Category(category_id);


CREATE TABLE Account (
    account_id INT PRIMARY KEY,
    balance DECIMAL(10, 2),
    account_type VARCHAR(50),
    CONSTRAINT CHK_balance CHECK (balance >= 0),
    CONSTRAINT CHK_account_type CHECK (account_type IN ('Saving', 'Checking'))
);


CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    city VARCHAR(100) DEFAULT 'Unknown'
);


ALTER TABLE Customer
ADD CONSTRAINT DF_customer DEFAULT 'Unknown' FOR city;


CREATE TABLE Invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    amount DECIMAL(10, 2)
);

INSERT INTO Invoice (amount) VALUES (10.50);
INSERT INTO Invoice (amount) VALUES (20.75);
INSERT INTO Invoice (amount) VALUES (15.25);
INSERT INTO Invoice (amount) VALUES (30.40);
INSERT INTO Invoice (amount) VALUES (25.90);

SET IDENTITY_INSERT Invoice ON;
INSERT INTO Invoice (invoice_id, amount) VALUES (100, 50.00);
SET IDENTITY_INSERT Invoice OFF;


CREATE TABLE Books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL CHECK (LEN(title) > 0),
    price DECIMAL(10, 2) CHECK (price > 0),
    genre VARCHAR(100) CONSTRAINT DF_books_genre DEFAULT 'Unknown'
);

INSERT INTO Books (title, price, genre) VALUES ('Guliver', 10.99, 'Fiction');
INSERT INTO Books (title, price, genre) VALUES ('1984', 8.50, 'Dystopian');
INSERT INTO Books (title, price) VALUES ('Sherlock Holmes', 12.75);
INSERT INTO Books (title, price, genre) VALUES ('Harry Potter', 15.00, 'Adventure');
INSERT INTO Books (title, price) VALUES ('Kichkina shahzoda', 9.99);

SELECT * FROM Books;


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
