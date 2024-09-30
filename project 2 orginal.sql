-- Database Creation

CREATE DATABASE library;
USE library;

-- Table Creation

CREATE TABLE Branch (Branch_no INT PRIMARY KEY,Manager_Id INT,Branch_address VARCHAR(100),
    Contact_no VARCHAR(20));

CREATE TABLE Employee (Emp_Id INT PRIMARY KEY,Emp_name VARCHAR(50),Position VARCHAR(50),Salary DECIMAL(10, 2),Branch_no INT,
    FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no));

CREATE TABLE Books (ISBN VARCHAR(20) PRIMARY KEY,Book_title VARCHAR(100),Category VARCHAR(50),Rental_Price DECIMAL(10, 2),Status VARCHAR(5),Author VARCHAR(50),Publisher VARCHAR(50));

CREATE TABLE Customer (Customer_Id INT PRIMARY KEY,Customer_name VARCHAR(50),
    Customer_address VARCHAR(100),Reg_date DATE);

CREATE TABLE IssueStatus (Issue_Id INT PRIMARY KEY,Issued_cust INT,Issued_book_name VARCHAR(100),
    Issue_date DATE,Isbn_book VARCHAR(20),FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN));

CREATE TABLE ReturnStatus (Return_Id INT PRIMARY KEY,
    Return_cust INT,Return_book_name VARCHAR(100),Return_date DATE,Isbn_book2 VARCHAR(20),
    FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN));

-- inserting values
INSERT INTO Branch VALUES (1, 101, 'Main Street', '1234567890');
INSERT INTO Branch VALUES (2, 102, 'Main Street', '9876543210');
INSERT INTO Branch VALUES (3, 103, 'Oak Street', '5555555555');

INSERT INTO Employee VALUES (101, 'John Doe', 'Manager', 50000, 1);
INSERT INTO Employee VALUES (102, 'Alice Smith', 'Assistant Manager', 35000, 1);
INSERT INTO Employee VALUES (103, 'Bob Johnson', 'Librarian', 28000, 2);
INSERT INTO Employee VALUES (104, 'Charlie Brown', 'Librarian', 28000, 3);

INSERT INTO Books VALUES ('B001', 'The Lord of the Rings', 'Fantasy', 15.00, 'yes', 'J.R.R. Tolkien', 'HarperCollins');
INSERT INTO Books VALUES ('B002', 'Pride and Prejudice', 'Classic', 12.00, 'yes', 'Jane Austen', 'Penguin Classics');
INSERT INTO Books VALUES ('B003', 'To Kill a Mockingbird', 'Fiction', 18.00, 'no', 'Harper Lee', 'HarperCollins');
INSERT INTO Books VALUES ('B004', '1984', 'Sci-Fi', 20.00, 'yes', 'George Orwell', 'Penguin Classics');
INSERT INTO Books VALUES ('B005', 'Harry Potter and the Sorcerer','fantasy',15.00,'no','J.K. Rowling','Bloomsbury');

INSERT INTO Customer VALUES (1001, 'David Miller', '123 Main St', '2023-02-15');
INSERT INTO Customer VALUES (1002, 'Emily Davis', '456 Oak St', '2022-08-20');
INSERT INTO Customer VALUES (1003, 'Frank Thomas', '789 Elm St', '2021-11-05');

INSERT INTO IssueStatus VALUES (1001, 1001, 'The Lord of the Rings', '2023-06-10', 'B001');
INSERT INTO IssueStatus VALUES (1002, 1002, 'Pride and Prejudice', '2023-07-15', 'B002');
INSERT INTO IssueStatus VALUES (1003, 1003, 'To Kill a Mockingbird', '2023-08-25', 'B003');

INSERT INTO ReturnStatus VALUES (2001, 1001, 'The Lord of the Rings', '2023-07-05', 'B001');
INSERT INTO ReturnStatus VALUES (2002, 1002, 'Pride and Prejudice', '2023-08-10', 'B002');




-- 1. Retrieve the book title, category, and rental price of all available books.

SELECT Book_title, Category, Rental_Price FROM Books WHERE Status = 'yes';

-- 2 List the employee names and their respective salaries in descending order of salary.

SELECT Emp_name, Salary FROM Employee ORDER BY Salary DESC;


-- 3 Retrieve the book titles and the corresponding customers who have issued those books
SELECT Books.Book_title, Customer.Customer_name FROM IssueStatus INNER JOIN Books ON IssueStatus.Isbn_book = Books.ISBN
INNER JOIN Customer ON IssueStatus.Issued_cust = Customer.Customer_Id;


-- 4 Display the total count of books in each category.

SELECT Category, COUNT(*) AS Total_Books FROM Books GROUP BY Category;

-- 5 Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000.

SELECT Emp_name, Position FROM Employee WHERE Salary > 50000;

-- 6 List the customer names who registered before 2022-01-01 and have not issued any books yet.
SELECT Customer_name FROM Customer WHERE Reg_date < '2022-01-01' AND Customer_Id NOT IN (SELECT Issued_cust FROM IssueStatus);


-- 7 Display the branch numbers and the total count of employees in each branch.

SELECT Branch_no, COUNT(*) AS Total_Employees FROM Employee GROUP BY Branch_no;

-- 8 SELECT DISTINCT C.Customer_name 
SELECT Customer.Customer_name FROM IssueStatus INNER JOIN Customer ON IssueStatus.Issued_cust = Customer.Customer_Id WHERE MONTH(Issue_date) = 6 AND YEAR(Issue_date) = 2023;

-- 9 Retrieve book titles from the book table containing "history".
SELECT Book_title FROM Books WHERE Book_title LIKE 'history';

-- 10 Retrieve the branch numbers along with the count of employees for branches having more than 5 employees.
SELECT Branch.Branch_no, COUNT(Employee.Emp_Id) AS Employee_Count
FROM Branch LEFT JOIN Employee ON Branch.Branch_no = Employee.Branch_no GROUP BY Branch.Branch_no HAVING COUNT(Employee.Emp_Id) > 5;

-- 11 Retrieve the names of employees who manage branches and their respective branch addresses.
SELECT Employee.Emp_name, Branch.Branch_address FROM Employee INNER JOIN Branch ON Employee.Branch_no = Branch.Branch_no;

-- 12 Display the names of customers who have issued books with a rental price higher than Rs. 25
SELECT Customer.Customer_name FROM IssueStatus
INNER JOIN Books ON IssueStatus.Isbn_book = Books.ISBN INNER JOIN Customer ON IssueStatus.Issued_cust = Customer.Customer_Id WHERE Books.Rental_Price > 25;
 
