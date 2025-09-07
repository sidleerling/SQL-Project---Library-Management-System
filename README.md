# SQL Project - Library Management System

## 1. Background and Overview

This is an SQL based project designed to simulate the daily operations of a modern library using MySQL. It is designed to efficiently tracking books, members, branches, employees and transaction history (issues/returns) with the primary focus on the following:

1. Performing CRUD operations as and when there is a new book added to the library, book quality status, employee details
2. Identify the most frequently issued books
3. Find out the best performing employee in each branch based on the number of books issued and revenue generated for that branch.
4. Analyzing branch performance by tracking annual revenue generated per year and book issue counts
5. Identify the most active members
6. Create a procedure to track members with overdue books and fine them for the delay.

The goal is to build a robust system using SQL that not only manages library operations but also use the insights to give recommendations that can improve operational efficiency, increase book circulation and revenue, reward employee performance, and enhance member engagement—ultimately fostering a more effective and data-driven library system.

---

## 2. Data Structure and Overview

The system is built on **six core tables** with appropriate primary and foreign key relationships as represented in the ER diagram below:

- **branch**: Stores branch details including manager and address  
- **employees**: Staff working at branches  
- **books**: All books in the catalog  
- **members**: Registered library members  
- **issued_status**: Tracks which books are issued to whom and when  
- **return_status**: Tracks when books are returned and their condition

![ER Diagram](ER%20Diagram%20-%20Library%20Management%20System.png)

- Additional derived tables like `book_issue_summary`, `branch_performance_report`, `active_members`, and `overdue_summary` are created using **CTAS (Create Table As Select)** queries to support reporting and business insights.

---

## 3. Executive Summary and Key Insights

This SQL-based library system answers key business questions such as:

1. **Which book has been issued the most number of times?**
```sql
create table book_issue_summary
as select bk.isbn, bk.book_title, count(issued_id) as total_times_issued from books as bk
left join issued_status as i
on bk.isbn = i.issued_book_isbn
group by bk.isbn, bk.book_title,

select isbn, book_title, total_times_issued from book_issue_summary 
group by isbn having max(total_times_issued);
```
- The books 'Animal Farm', 'The Great Gatsby' and 'Harry Potter and the Sorcerers Stone' were issued 2 times which was the highest number of times issued.
- It shows that these books are in more demand than the other ones in the library. 

2. **Which book category has generated the highest revenue and whether they are currently available within the library?**
```sql
select bk.category, sum(bk.rental_price) as total_rental_income from books as bk
inner join issued_status as i
on bk.isbn = i.issued_book_isbn
where status = 'yes'
group by bk.category;
```
- Books belonging to the 'Classic' genre generated the highest revenue earning the library $59 in rental income. The second highest revenue being history with $36.5.
- Children's books have the lowest revenue generation with only $4
  
3. **Which branch has generated the highest revenue and the number of books that have been issued (Branch Performance Report)?**

```sql
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

select bpr.branch_id, bpr.total_revenue_generated, b.branch_address from branch_performance_report as bpr 
inner join branch as b
on bpr.branch_id = b.branch_id
order by bpr.total_revenue_generated desc 
limit 1;
```
- The library branch with the ID 'B001' generated the highest revenue over the period of 2 years amounting to $111.5. It is located in 123 Main St.

4. Who are the top 3 best performing employees?

```sql
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
```
- The best performing employees were 'Laura Martinez' and 'Michelle Ramirez' from branches 'B005' and 'B001' respectively. They issued 6 books each.
- Meanwhile, 'Emily Davis' from B001 issued 4 books which was the third highest amongst all the employees
- Two of the three employees that performed the best were from branch 'B001' and it explains why this branch was able to generate the highest total revenue amongst all the other branches. 

5. Which books have a price above $7.00? These books would be called 'Premium Books' as they are expensive.
```sql
create table premium_books as 
select isbn, book_title, category, rental_price
from books where rental_price > 7.5;
```
- None of the books within the branches had a price above $7.00
  
6. Who are the active members that have issued at least one book within the past 2 months?
```sql
create table active_members as
select m.member_id, m.member_name, m.reg_date from members as m 
inner join issued_status as i
on m.member_id = i.issued_member_id
where issued_date >= curdate() - interval 2 month
group by m.member_id, m.member_name, m.reg_date 
having count(i.issued_member_id) > 1;
```

7. Which books have been issued but not returned by the members (Book Tracking)?
```sql
select distinct i.issued_id, i.issued_book_name, i.issued_date from issued_status as i
left join return_status as r 
on i.issued_id = r.issued_id
where r.return_id is null;
```
- There were several books that were issued and not returned yet by the members
- These include books like: 'Fahrenheit 451', 'Dune', 'Where the Wild Things Are', 'The Kite Runner', 'Charlotte's Web' etc. These have not been returned for more than 30 days
  
8. Using the information above, who are the members with overdue books (books issued more than 30 days ago given that the library has a 1-month return period)?
```sql
select distinct m.member_id, m.member_name, i.issued_book_name as book_title, 
datediff(curdate(),i.issued_date) as no_of_days_overdue
from members as m
inner join issued_status as i
on m.member_id = i.issued_member_id
left join return_status as r
on i.issued_id = r.issued_id
where r.return_id is null and datediff(curdate(),i.issued_date) > 30;
```

9. With the information about members with overdue books, what are the fines each member has to pay for each day the book is overdue (creating an overdue summary report)?
```sql
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
```

10. How will the status of each book in the library be tracked and managed effectively (Book Status Management)?
```sql
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
```

11. Are any books being repeatedly returned in poor condition and who returned them?
```sql
select m.member_name, count(r.book_quality) as no_of_damaged_book_issuances from members as m
inner join issued_status as i
on m.member_id = i.issued_member_id
inner join return_status as r
on i.issued_id = r.issued_id
where r.book_quality = 'Damaged'
group by member_name
having count(r.book_quality) >=1;
```
- The members 'Ivy Martinez', 'Jack Wilson', 'Alice Johnson' returned 1 book each in poor condition.
  
---

## 6. Recommendations

Based on the insights gathered from the queries, the following recommendations have been made to improve the library's operational efficiency

- **Introducing automated overdue reminders** for members with pending returns will ensure that they are aware of the need to return the books and the impending fines associated with it for every day it is delayed. This will ensure that the members who have issued books are accountable for the delay.
  
- **Reward high-performing employees** will help boost morale and performance of the employees. These employees could receive a bonus or a commission at the end of each month if they continue to generate high revenue for the library. They could also be given special access to books and have discounts for their family and friends.
  
- **Tracking damaged books more closely** will ensure that those books that were returned in poor condition are accounted for and most importantly add another criteria that will categorize the extent of damage to the book such that the members are fined appropriately. The extent of damage may range from pencil/pen marks, annotations, tea/coffee spills to torn pages/book cover.
  
- **Highlighting popular or premium books** which are expensive and tracking their issuances will allow the library to offer discounts or incentives to people to issue those books more often thereby increasing the revenue generated.
   
- **Underperforming library branches** could have their inventories optimized by understanding which books have not been issued for a long period of time and replace them with books that are recent fan favorites and are trending recently. The books that are issued more often should have more duplicates in the inventory compared to the ones with lower demand to increase book issuances and thereby the total revenue generated. Besides inventory optimization, the member experiences within the branch could be studied to ensure that in the future they are provided the best services which would bring more potential members to the library.

---

## Technologies Used

- SQL (MySQL syntax)
- Stored Procedures
- Common Table Expressions (CTEs)
- CTAS (Create Table As Select)

---

## Folder Structure

All SQL code is contained in one structured `.sql` file. Future versions may include:

