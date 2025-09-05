-- SQL Project 2 - Library Management System

-- Creating the database 

create database library_db;
use library_db;

-- Creating the schema for the 6 tables, adding the foreign keys to form relationships between the tables

create table branch (
branch_id varchar (10) primary key,
manager_id varchar (10), 
branch_address varchar (55),
contact_no varchar (20)
);

create table employees (
emp_id varchar (4) primary key,
emp_name varchar (25),
position varchar (25),
salary int,
branch_id varchar (25), -- FK
foreign key (branch_id) references branch(branch_id)
);

create table books (
isbn varchar (17) primary key,
book_title varchar (100),
category varchar (20),
rental_price float,
status varchar (15),
author varchar (35),
publisher varchar (75)
);

create table members (
member_id varchar (4) primary key,
member_name varchar (25),
member_address varchar (100),
reg_date date 
);

create table issued_status (
issued_id varchar (5) primary key,
issued_member_id varchar (4), -- FK
issued_book_name varchar (100),
issued_date date,
issued_book_isbn varchar (17), -- FK
issued_emp_id varchar (4), -- FK
foreign key (issued_member_id) references members(member_id),
foreign key (issued_book_isbn) references books(isbn),
foreign key (issued_emp_id) references employees(emp_id)
);

create table return_status (
return_id varchar (5),
issued_id varchar (5), -- FK
return_book_name varchar (100),
return_date date,
return_book_isbn varchar (17),
foreign key (issued_id) references issued_status(issued_id)
);

-- Inserting the values into the 6 tables
-- Members table  

insert into members(member_id, member_name, member_address, reg_date) 
values
('C101', 'Alice Johnson', '123 Main St', '2021-05-15'),
('C102', 'Bob Smith', '456 Elm St', '2021-06-20'),
('C103', 'Carol Davis', '789 Oak St', '2021-07-10'),
('C104', 'Dave Wilson', '567 Pine St', '2021-08-05'),
('C105', 'Eve Brown', '890 Maple St', '2021-09-25'),
('C106', 'Frank Thomas', '234 Cedar St', '2021-10-15'),
('C107', 'Grace Taylor', '345 Walnut St', '2021-11-20'),
('C108', 'Henry Anderson', '456 Birch St', '2021-12-10'),
('C109', 'Ivy Martinez', '567 Oak St', '2022-01-05'),
('C110', 'Jack Wilson', '678 Pine St', '2022-02-25'),
('C118', 'Sam', '133 Pine St', '2024-06-01'),    
('C119', 'John', '143 Main St', '2024-05-01');

-- Branch table 

insert into branch(branch_id, manager_id, branch_address, contact_no) 
values
('B001', 'E109', '123 Main St', '+919099988676'),
('B002', 'E109', '456 Elm St', '+919099988677'),
('B003', 'E109', '789 Oak St', '+919099988678'),
('B004', 'E110', '567 Pine St', '+919099988679'),
('B005', 'E110', '890 Maple St', '+919099988680');

-- Employees table 
insert into employees(emp_id, emp_name, position, salary, branch_id) 
values
('E101', 'John Doe', 'Clerk', 60000.00, 'B001'),
('E102', 'Jane Smith', 'Clerk', 45000.00, 'B002'),
('E103', 'Mike Johnson', 'Librarian', 55000.00, 'B001'),
('E104', 'Emily Davis', 'Assistant', 40000.00, 'B001'),
('E105', 'Sarah Brown', 'Assistant', 42000.00, 'B001'),
('E106', 'Michelle Ramirez', 'Assistant', 43000.00, 'B001'),
('E107', 'Michael Thompson', 'Clerk', 62000.00, 'B005'),
('E108', 'Jessica Taylor', 'Clerk', 46000.00, 'B004'),
('E109', 'Daniel Anderson', 'Manager', 57000.00, 'B003'),
('E110', 'Laura Martinez', 'Manager', 41000.00, 'B005'),
('E111', 'Christopher Lee', 'Assistant', 65000.00, 'B005');

-- Books table 
insert into books(isbn, book_title, category, rental_price, status, author, publisher) 
values
('978-0-553-29698-2', 'The Catcher in the Rye', 'Classic', 7.00, 'yes', 'J.D. Salinger', 'Little, Brown and Company'),
('978-0-330-25864-8', 'Animal Farm', 'Classic', 5.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-14-118776-1', 'One Hundred Years of Solitude', 'Literary Fiction', 6.50, 'yes', 'Gabriel Garcia Marquez', 'Penguin Books'),
('978-0-525-47535-5', 'The Great Gatsby', 'Classic', 8.00, 'yes', 'F. Scott Fitzgerald', 'Scribner'),
('978-0-141-44171-6', 'Jane Eyre', 'Classic', 4.00, 'yes', 'Charlotte Bronte', 'Penguin Classics'),
('978-0-307-37840-1', 'The Alchemist', 'Fiction', 2.50, 'yes', 'Paulo Coelho', 'HarperOne'),
('978-0-679-76489-8', 'Harry Potter and the Sorcerers Stone', 'Fantasy', 7.00, 'yes', 'J.K. Rowling', 'Scholastic'),
('978-0-7432-4722-4', 'The Da Vinci Code', 'Mystery', 8.00, 'yes', 'Dan Brown', 'Doubleday'),
('978-0-09-957807-9', 'A Game of Thrones', 'Fantasy', 7.50, 'yes', 'George R.R. Martin', 'Bantam'),
('978-0-393-05081-8', 'A Peoples History of the United States', 'History', 9.00, 'yes', 'Howard Zinn', 'Harper Perennial'),
('978-0-19-280551-1', 'The Guns of August', 'History', 7.00, 'yes', 'Barbara W. Tuchman', 'Oxford University Press'),
('978-0-307-58837-1', 'Sapiens: A Brief History of Humankind', 'History', 8.00, 'no', 'Yuval Noah Harari', 'Harper Perennial'),
('978-0-375-41398-8', 'The Diary of a Young Girl', 'History', 6.50, 'no', 'Anne Frank', 'Bantam'),
('978-0-14-044930-3', 'The Histories', 'History', 5.50, 'yes', 'Herodotus', 'Penguin Classics'),
('978-0-393-91257-8', 'Guns, Germs, and Steel: The Fates of Human Societies', 'History', 7.00, 'yes', 'Jared Diamond', 'W. W. Norton & Company'),
('978-0-7432-7357-1', '1491: New Revelations of the Americas Before Columbus', 'History', 6.50, 'no', 'Charles C. Mann', 'Vintage Books'),
('978-0-679-64115-3', '1984', 'Dystopian', 6.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-14-143951-8', 'Pride and Prejudice', 'Classic', 5.00, 'yes', 'Jane Austen', 'Penguin Classics'),
('978-0-452-28240-7', 'Brave New World', 'Dystopian', 6.50, 'yes', 'Aldous Huxley', 'Harper Perennial'),
('978-0-670-81302-4', 'The Road', 'Dystopian', 7.00, 'yes', 'Cormac McCarthy', 'Knopf'),
('978-0-385-33312-0', 'The Shining', 'Horror', 6.00, 'yes', 'Stephen King', 'Doubleday'),
('978-0-451-52993-5', 'Fahrenheit 451', 'Dystopian', 5.50, 'yes', 'Ray Bradbury', 'Ballantine Books'),
('978-0-345-39180-3', 'Dune', 'Science Fiction', 8.50, 'yes', 'Frank Herbert', 'Ace'),
('978-0-375-50167-0', 'The Road', 'Dystopian', 7.00, 'yes', 'Cormac McCarthy', 'Vintage'),
('978-0-06-025492-6', 'Where the Wild Things Are', 'Children', 3.50, 'yes', 'Maurice Sendak', 'HarperCollins'),
('978-0-06-112241-5', 'The Kite Runner', 'Fiction', 5.50, 'yes', 'Khaled Hosseini', 'Riverhead Books'),
('978-0-06-440055-8', 'Charlotte''s Web', 'Children', 4.00, 'yes', 'E.B. White', 'Harper & Row'),
('978-0-679-77644-3', 'Beloved', 'Fiction', 6.50, 'yes', 'Toni Morrison', 'Knopf'),
('978-0-14-027526-3', 'A Tale of Two Cities', 'Classic', 4.50, 'yes', 'Charles Dickens', 'Penguin Books'),
('978-0-7434-7679-3', 'The Stand', 'Horror', 7.00, 'yes', 'Stephen King', 'Doubleday'),
('978-0-451-52994-2', 'Moby Dick', 'Classic', 6.50, 'yes', 'Herman Melville', 'Penguin Books'),
('978-0-06-112008-4', 'To Kill a Mockingbird', 'Classic', 5.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'),
('978-0-553-57340-1', '1984', 'Dystopian', 6.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-7432-4722-5', 'Angels & Demons', 'Mystery', 7.50, 'yes', 'Dan Brown', 'Doubleday'),
('978-0-7432-7356-4', 'The Hobbit', 'Fantasy', 7.00, 'yes', 'J.R.R. Tolkien', 'Houghton Mifflin Harcourt');

-- Issued_status table 
insert into issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id) 
values
('IS106', 'C106', 'Animal Farm', '2024-03-10', '978-0-330-25864-8', 'E104'),
('IS107', 'C107', 'One Hundred Years of Solitude', '2024-03-11', '978-0-14-118776-1', 'E104'),
('IS108', 'C108', 'The Great Gatsby', '2024-03-12', '978-0-525-47535-5', 'E104'),
('IS109', 'C109', 'Jane Eyre', '2024-03-13', '978-0-141-44171-6', 'E105'),
('IS110', 'C110', 'The Alchemist', '2024-03-14', '978-0-307-37840-1', 'E105'),
('IS111', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-03-15', '978-0-679-76489-8', 'E105'),
('IS112', 'C109', 'A Game of Thrones', '2024-03-16', '978-0-09-957807-9', 'E106'),
('IS113', 'C109', 'A Peoples History of the United States', '2024-03-17', '978-0-393-05081-8', 'E106'),
('IS114', 'C109', 'The Guns of August', '2024-03-18', '978-0-19-280551-1', 'E106'),
('IS115', 'C109', 'The Histories', '2024-03-19', '978-0-14-044930-3', 'E107'),
('IS116', 'C110', 'Guns, Germs, and Steel: The Fates of Human Societies', '2024-03-20', '978-0-393-91257-8', 'E107'),
('IS117', 'C110', '1984', '2024-03-21', '978-0-679-64115-3', 'E107'),
('IS118', 'C101', 'Pride and Prejudice', '2024-03-22', '978-0-14-143951-8', 'E108'),
('IS119', 'C110', 'Brave New World', '2024-03-23', '978-0-452-28240-7', 'E108'),
('IS120', 'C110', 'The Road', '2024-03-24', '978-0-670-81302-4', 'E108'),
('IS121', 'C102', 'The Shining', '2024-03-25', '978-0-385-33312-0', 'E109'),
('IS122', 'C102', 'Fahrenheit 451', '2024-03-26', '978-0-451-52993-5', 'E109'),
('IS123', 'C103', 'Dune', '2024-03-27', '978-0-345-39180-3', 'E109'),
('IS124', 'C104', 'Where the Wild Things Are', '2024-03-28', '978-0-06-025492-6', 'E110'),
('IS125', 'C105', 'The Kite Runner', '2024-03-29', '978-0-06-112241-5', 'E110'),
('IS126', 'C105', 'Charlotte''s Web', '2024-03-30', '978-0-06-440055-8', 'E110'),
('IS127', 'C105', 'Beloved', '2024-03-31', '978-0-679-77644-3', 'E110'),
('IS128', 'C105', 'A Tale of Two Cities', '2024-04-01', '978-0-14-027526-3', 'E110'),
('IS129', 'C105', 'The Stand', '2024-04-02', '978-0-7434-7679-3', 'E110'),
('IS130', 'C106', 'Moby Dick', '2024-04-03', '978-0-451-52994-2', 'E101'),
('IS131', 'C106', 'To Kill a Mockingbird', '2024-04-04', '978-0-06-112008-4', 'E101'),
('IS132', 'C106', 'The Hobbit', '2024-04-05', '978-0-7432-7356-4', 'E106'),
('IS133', 'C107', 'Angels & Demons', '2024-04-06', '978-0-7432-4722-5', 'E106'),
('IS134', 'C107', 'The Diary of a Young Girl', '2024-04-07', '978-0-375-41398-8', 'E106'),
('IS135', 'C107', 'Sapiens: A Brief History of Humankind', '2024-04-08', '978-0-307-58837-1', 'E108'),
('IS136', 'C107', '1491: New Revelations of the Americas Before Columbus', '2024-04-09', '978-0-7432-7357-1', 'E102'),
('IS137', 'C107', 'The Catcher in the Rye', '2024-04-10', '978-0-553-29698-2', 'E103'),
('IS138', 'C108', 'The Great Gatsby', '2024-04-11', '978-0-525-47535-5', 'E104'),
('IS139', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-04-12', '978-0-679-76489-8', 'E105'),
('IS140', 'C110', 'Animal Farm', '2024-04-13', '978-0-330-25864-8', 'E102');

-- return_status table
insert into return_status(return_id, issued_id, return_date) 
values
('RS104', 'IS106', '2024-05-01'),
('RS105', 'IS107', '2024-05-03'),
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');

/* Q1. Insert a new book record with ISBN '978-0-7432-7358-8', 
title 'The Midnight Library', category 'Fiction', rental price $6.50, 
status 'yes', author 'Matt Haig', and publisher 'Canongate Books' */

insert into books 
values ('978-0-7432-7358-8','The Midnight Library','Fiction', 6.5, 'yes', 'Matt Haig','Canongate Books');

select * from books;

-- Q2. Update the address of member 'C102' (Bob Smith) in the `members` table to '789 Cherry Street'.

update members
set member_address = '789 Cherry St'
where member_id = 'C102';

-- Q3. Add a new column 'Book Quality' in the return_status table and set the default quality to be 'Good'

alter table return_status 
add column book_quality varchar (15) default 'Good';

-- Q4. Update the value in the 'Book Quality' column to 'Damaged' with issued_ids IS112, IS117, IS118

update return_status
set book_quality = 'Damaged'
where issued_id in ('IS112', 'IS117', 'IS118');

-- Q5. Delete the book issuance record from `issued_status` where issued_id = 'IS121'.

delete from issued_status where issued_id = 'IS121';
select * from issued_status;

-- Q5. Retrieve all books issued by employee 'E101' (John Doe), including issued_id, issued_member_id, book title, and issue date.

select i.issued_id, i.issued_member_id, b.book_title, i.issued_date from issued_status as i
inner join books as b
on i.issued_book_isbn = b.isbn
where i.issued_emp_id = 'E101';

-- Q6. List all members who have issued more than one book. Include member_id, member_name, and the total count of books issued.

select m.member_id, m.member_name, count(i.issued_member_id) as total_count_of_issued_books from members as m
inner join issued_status as i
on m.member_id = i.issued_member_id
group by member_id
having count(i.issued_member_id) > 1;

-- Q7. Create a new table `book_issue_summary` using CTAS that includes each book's ISBN, title, and total times it has been issued.

create table book_issue_summary
as select bk.isbn, bk.book_title, count(issued_id) as total_times_issued from books as bk
left join issued_status as i
on bk.isbn = i.issued_book_isbn
group by bk.isbn, bk.book_title;

/* Q8. Select all books from the `books` table where the category is 'Dystopian'. 
Include columns: isbn, book_title, author, and rental_price. */

select isbn, book_title, author, rental_price from books where category = 'Dystopian';

/* Q9. Calculate the total rental income grouped by book category from books that have been issued and are currently available 
(`status = 'yes'`) */

select bk.category, sum(bk.rental_price) as total_rental_income from books as bk
inner join issued_status as i
on bk.isbn = i.issued_book_isbn
where status = 'yes'
group by bk.category;

/* Q10. Retrieve all members who registered within the last 180 days.
Include member_id, member_name, and reg_date. */

select * from members where reg_date >= curdate() - interval 180 day;

/* Q11. Display each employee's ID, name, branch ID, branch address, manager_name
Use a self-join between `employees` and `branch` to match employees with their managers. */

select e.emp_id, e.emp_name, b.branch_id, b.branch_address, m.emp_name as manager_name from employees as e
inner join branch as b
on e.branch_id = b.branch_id
left join employees as m
on b.manager_id = m.emp_id;

/* Q12. Create a new table `premium_books` using CTAS that includes books with rental_price greater than $7.00. 
Include columns: isbn, book_title, category, and rental_price. */

create table premium_books as 
select isbn, book_title, category, rental_price
from books where rental_price > 7.5; 

select * from premium_books;

/* Q13. Create a table `active_members` using CTAS, including only members who have issued at least one book 
in the past 2 months. Include member_id, member_name, and reg_date. */

create table active_members as
select m.member_id, m.member_name, m.reg_date from members as m 
inner join issued_status as i
on m.member_id = i.issued_member_id
where issued_date >= curdate() - interval 2 month
group by m.member_id, m.member_name, m.reg_date 
having count(i.issued_member_id) > 1;

-- Q14. Retrieve a list of all books that are currently issued and have not yet been returned.

/* The issued books have their issued_id in the issued_status table but if they are not returned, their issued_id would not be present 
in the return_status table so return_id would be 'NULL' */

select distinct i.issued_id, i.issued_book_name, i.issued_date from issued_status as i
left join return_status as r 
on i.issued_id = r.issued_id
where r.return_id is null;

/* Q15. Identify members who have overdue books (i.e., books issued more than 30 days ago and not returned).
Display: member_id, member_name, book_title, issued_date, and number of days overdue.
Use current_date as reference. */ 

select distinct m.member_id, m.member_name, i.issued_book_name as book_title, 
datediff(curdate(),i.issued_date) as no_of_days_overdue
from members as m
inner join issued_status as i
on m.member_id = i.issued_member_id
left join return_status as r
on i.issued_id = r.issued_id
where r.return_id is null and datediff(curdate(),i.issued_date) > 30;

/* Q16. Update the `books` table to set status = 'yes' when a book is returned (based on entries in the return status table) */

delimiter $$
create procedure update_book_status (in p_return_id varchar(5), in p_issued_id varchar(5), in p_book_quality varchar(15)
)
begin
declare v_isbn varchar(17);
declare v_book_name varchar(100);

insert into return_status (return_id, issued_id, return_date, book_quality)
values (p_return_id, p_issued_id, current_date(), p_book_quality);

select issued_book_isbn, issued_book_name 
into v_isbn, v_book_name
from issued_status 
where issued_id = p_issued_id;

update books 
set status = 'yes' 
where isbn = v_isbn;

select concat('Thank you for returning ', v_book_name) as message;
end $$
delimiter ;

call update_book_status ('RS119','IS135','Good');

select * from books where isbn = '978-0-307-58837-1';
select * from return_status;

/* Q17. Generate a performance report for each library branch.
For each branch, include:
1. Number of books issued
2. Number of books returned
3. Total revenue generated from book rentals
Use data from `branch`, `employees`, `issued_status`, `return_status`, and `books`. */

create table branch_performance_report as
select br.branch_id, br.manager_id, count(i.issued_id) as no_of_books_issued, count(r.return_id) as no_of_books_returned,
sum(bo.rental_price) as total_revenue_generated from issued_status as i
inner join employees as e 
on i.issued_emp_id = e.emp_id 
inner join branch as br
on e.branch_id = br.branch_id
left join return_status as r
on i.issued_id = r.issued_id
inner join books as bo
on i.issued_book_isbn = bo.isbn
group by br.branch_id, br.manager_id;

-- Q18. Find out which branch had the highest total revenue generated and where is the branch located

select bpr.branch_id, bpr.total_revenue_generated, b.branch_address from branch_performance_report as bpr 
inner join branch as b
on bpr.branch_id = b.branch_id
order by bpr.total_revenue_generated desc 
limit 1;

-- We can see that branch B001 generated the highest revenue of 111.5 and it is located in 123 Main St

/* Q18. Retrieve the top 3 employees who have processed the highest number of book issues.
Display emp_id, emp_name, number of books processed, and their branch details. */

select e.emp_name, br.*, count(issued_book_isbn) as no_of_books_issued from employees as e
inner join issued_status as i
on e.emp_id = i.issued_emp_id
inner join books as b
on i.issued_book_isbn = b.isbn
inner join branch as br
on e.branch_id = br.branch_id
group by e.emp_name, br.branch_id
order by count(issued_book_isbn) desc 
limit 3;

/* Q19. Identify members who have issued books marked with `status = 'damaged'` at least once.
Display member_name, total count of damaged book issuances. */

select m.member_name, count(r.book_quality) as no_of_damaged_book_issuances from members as m
inner join issued_status as i
on m.member_id = i.issued_member_id
inner join return_status as r
on i.issued_id = r.issued_id
where r.book_quality = 'Damaged'
group by member_name
having count(r.book_quality) >=1;

/* Q20. Create a stored procedure to manage the status of books in the library system. 
THe stored procedure should update the status of the book in the library based on its issuance. 
It should take the book_id or ISBN as the input parameter then perform the following actions:
1. Check if the book is available (status = 'yes'). If available, it should be issued and the status of the book should be updated to 'no'
2. If the book is not available, status = 'no', the procedure should return an error message indicating that the book is not available */

delimiter $$
create procedure book_status_management (in v_isbn varchar (17))
begin
declare book_status varchar (10);

select status into book_status from books where isbn = v_isbn;

if book_status = 'no' then
signal sqlstate '45000'
set message_text = 'Book is not available';

else 
update books set status = 'no' where isbn = v_isbn and status = 'yes';
end if ;

end $$ 
delimiter ;

call book_status_management ('978-0-06-025492-6');
call book_status_management ('978-0-375-41398-8');

/* Q21. Create a table `overdue_summary` using CTAS to track overdue books and associated fines.
Include:
- Member ID
- Number of overdue books (not returned within 30 days)
- Total fines (calculated at $0.50 per day)
- Total books issued by the member */

create table overdue_summary as 
with overdue_books as 
(select m.member_id, count(i.issued_id) as no_of_overdue_books, 
sum(0.5*datediff(current_date(), i.issued_date)) as total_fine from members as m
inner join issued_status as i
on m.member_id = i.issued_member_id
where datediff(current_date(), i.issued_date) > 30
group by m.member_id),
total_issued as 
(select m.member_id, count(issued_id) as total_books_issued from members as m
inner join issued_status as i
on m.member_id = i.issued_member_id
group by m.member_id)
select ob.member_id, ob.no_of_overdue_books, ob.total_fine, ti.total_books_issued from overdue_books as ob
left join total_issued as ti
on ob.member_id = ti.member_id
order by ob.member_id;




