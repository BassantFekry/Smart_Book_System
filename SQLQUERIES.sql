CREATE DATABASE BookStore;
use BookStore;

CREATE TABLE Book (
  Book_id INT NOT NULL AUTO_INCREMENT,
  Title VARCHAR(255),
  Price char(20)  ,
  Isbn10 VARCHAR(50),
  Publish_Day varchar(8),
  Publish_Month varchar(8),
  Publish_Year varchar(10),
  PRIMARY KEY (Book_id)
);

CREATE TABLE Author (
  Author_id INT NOT NULL AUTO_INCREMENT,
  Author_name VARCHAR(255),
  PRIMARY KEY (Author_id)
);

CREATE TABLE Written_by (
  Book_id INT,
  Author_id INT,
  PRIMARY KEY (Book_id, Author_id),
  FOREIGN KEY (Book_id) REFERENCES Book(Book_id),
  FOREIGN KEY (Author_id) REFERENCES Author(Author_id)
);

CREATE TABLE Category (
  Category_id INT NOT NULL AUTO_INCREMENT,
  Category_name VARCHAR(255),
  PRIMARY KEY (Category_id)
);

CREATE TABLE Belongs_too (
  Book_id INT,
  Category_id INT,
  PRIMARY KEY ( Book_id, Category_id ),
  FOREIGN KEY (Book_id) REFERENCES Book(Book_id),
  FOREIGN KEY (Category_id) REFERENCES Category(Category_id)
);

CREATE TABLE Branch (
  Branch_id INT NOT NULL AUTO_INCREMENT,
  Branch_name VARCHAR(255),
  Address VARCHAR(255),
  Manager_id INT,
  PRIMARY KEY (Branch_id),
  FOREIGN KEY (Manager_id) REFERENCES Employee(Employee_id)
);

CREATE TABLE Employee (
  Employee_id INT NOT NULL AUTO_INCREMENT,
  Employee_name VARCHAR(255),
  Address VARCHAR(255),
  Branch_id INT,
  PRIMARY KEY (Employee_id)
);
ALTER TABLE Employee
DROP COLUMN Branch_id;

CREATE TABLE Customer (
  Customer_id INT NOT NULL AUTO_INCREMENT,
  Customer_name VARCHAR(255),
  Email VARCHAR(255),
  Phone VARCHAR(50),
  PRIMARY KEY (Customer_id)
);

CREATE TABLE Sale (
  Sale_id INT NOT NULL AUTO_INCREMENT,
  Type VARCHAR(50),
 Sale_date VARCHAR(20),
  Branch_id INT NOT NULL,
  Customer_id INT NOT NULL,
  Employee_id INT NOT NULL,
  PRIMARY KEY (Sale_id),
  FOREIGN KEY (Branch_id) REFERENCES Branch(Branch_id),
  FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id),
  FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id)
);

CREATE TABLE SaleLine (
  Saleline_id INT NOT NULL AUTO_INCREMENT,
  Unit_price DECIMAL(10,2),
  Book_id INT,
  Sale_id INT,
   Quantity VARCHAR(20),
  PRIMARY KEY (Saleline_id),
  FOREIGN KEY (Book_id) REFERENCES Book(Book_id),
  FOREIGN KEY (Sale_id) REFERENCES Sale(Sale_id)
);

CREATE TABLE Review (
  Review_id INT NOT NULL AUTO_INCREMENT,
  Rating VARCHAR(5),
  Customer_id INT,
  Book_id INT,
  PRIMARY KEY (Review_id),
  FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id),
  FOREIGN KEY (Book_id) REFERENCES Book(Book_id)
);

CREATE TABLE Inventory (
  Inventory_id INT NOT NULL AUTO_INCREMENT,
  Quantity INT,
  Branch_id INT,
  Book_id INT,
  PRIMARY KEY (Inventory_id),
  FOREIGN KEY (Branch_id) REFERENCES Branch(Branch_id),
  FOREIGN KEY (Book_id) REFERENCES Book(Book_id)
);

-- Show all 
select * from Category;
select * from Book;
select * from Belongs_too;

-- Show all books with price more than 10
SELECT Title, Price FROM Book
where Price > 10;

-- get all books and what is its category
select b.Title, c.Category_name
from Book b
join Belongs_Too bt ON b.Book_id = bt.Book_id
join Category c ON bt.Category_id = c.Category_id;

-- having
select Author_name, COUNT(*) AS BookCount
from Author
join written_by w ON Author.Author_id = w.Author_id
group by Author_name
having COUNT(*) > 30;


-- prices of all books that belongs to category fiction
select b.Title, b.Price , c.Category_name
from Book b
join Belongs_too bt ON b.Book_id = bt.Book_id
join Category c ON bt.Category_id = c.Category_id
where c.Category_name = 'Fiction';

-- avg price 
select avg(Price) AS AveragePrice from Book;

-- if book price less than avg
select Title, Price
from Book
where Price > (SELECT AVG(Price) FROM Book);


-- how many books are in each category
select c.Category_name, COUNT(*) AS BookCount FROM Book b
JOIN Belongs_Too bt ON b.Book_id = bt.Book_id
JOIN Category c ON bt.Category_id = c.Category_id
GROUP BY c.Category_name;

-- Show book title with author name
select b.Title, a.Author_name AS Author
from Book b
join written_by bt ON b.Book_id  = bt.Book_id 
join Author a ON bt.Author_id  = a.Author_id;

-- books that has a review
SELECT Title FROM Book b
where EXISTS (select 1 from Review r 
    where r.Book_id = b.Book_id
);

select title, price from book
where title LIKE '%n' AND price > 5;
    
-- name has anna-    
select employee_id,employee_name from employee
where employee_name like '%anna%';

-- books where prices between 5 l 7
select * from book where
    price between 5 and 7;

-- total sales fro book
select b.Title, SUM(sl.Quantity * sl.Unit_price) AS Total_Sales
from SaleLine sl
join Book b ON sl.Book_id = b.Book_id
group by b.Title
order by Total_Sales DESC;

-- get all customers and employees name that starts with n
select Customer_name AS Name, 'Customer' AS Role
from Customer
where Customer_name LIKE '%n'
union
select Employee_name, 'Employee'
from Employee
where Employee_name LIKE '%n';

-- case
select b.Title, SUM(s.Quantity * s.Unit_price) AS Total_Sales,
    case
        when SUM(s.Quantity * s.Unit_price) > 500 THEN 'Hit Book'
        when SUM(s.Quantity * s.Unit_price) BETWEEN 200 AND 500 THEN 'medium sold book'
        else 'bad sold book'
    END AS Sales_Category
FROM SaleLine s
JOIN Book b ON s.Book_id = b.Book_id
GROUP BY b.Title
ORDER BY Total_Sales DESC;

-- any
select b.* from book b where b.book_id = any (
select bt.book_id from belongs_too bt
join category c on bt.category_id= c.category_id 
 where c.Category_name in ('Fiction','Horror','Thriller'));
 -- all
select b.* from book b where b.book_id = all (
select bt.book_id from belongs_too bt
join category c on bt.category_id= c.category_id 
 where c.Category_name in ('Fiction','Horror','Thriller'));



