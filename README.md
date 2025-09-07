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

The system is built on **six core tables** with appropriate primary and foreign key relationships:

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

1. Which book has been issued the most number of times?
```sql
create table book_issue_summary
as select bk.isbn, bk.book_title, count(issued_id) as total_times_issued from books as bk
left join issued_status as i
on bk.isbn = i.issued_book_isbn
group by bk.isbn, bk.book_title;

select * from book_issue_summary;
```

2. Which book categories have generated the highest rental revenue and whether they are currently available within the library?
```sql
select bk.category, sum(bk.rental_price) as total_rental_income from books as bk
inner join issued_status as i
on bk.isbn = i.issued_book_isbn
where status = 'yes'
group by bk.category;
```

4. Which branch has generated the highest revenue and the number of books that have been issued?

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

6. Who are the top 3 best performing employees?

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

8. Which books have a price above $7.00? These books would be called 'Premium Books' as they are expensive.
```sql
create table premium_books as 
select isbn, book_title, category, rental_price
from books where rental_price > 7.5;
```

11. Who are the active members that have issued at least one book within the past 2 months?
```sql
create table active_members as
select m.member_id, m.member_name, m.reg_date from members as m 
inner join issued_status as i
on m.member_id = i.issued_member_id
where issued_date >= curdate() - interval 2 month
group by m.member_id, m.member_name, m.reg_date 
having count(i.issued_member_id) > 1;
```

13. Which books have been issued but not returned by the members (Book Tracking)?
```sql
select distinct i.issued_id, i.issued_book_name, i.issued_date from issued_status as i
left join return_status as r 
on i.issued_id = r.issued_id
where r.return_id is null;
```

15. Using the information above, who are the members with overdue books (books issued more than 30 days ago given that the library has a 1-month return period)?
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

17. With the information about members with overdue books, what are the fines each member has to pay for each day the book is overdue (creating an overdue summary report)?
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

18. How will the status of each book in the library be tracked and managed effectively (Book Status Management)?
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

20. Are any books being repeatedly returned in poor condition?
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

---

## 4. Key Insights

- **Top Branch**: Branch B001 generated the highest total rental revenue.
- **Overdue Members**: Multiple members have books overdue by more than 30 days.
- **Damaged Returns**: Some members frequently return books in damaged condition.
- **Employee Productivity**: A few employees are responsible for most of the book issuances.
- **Premium Books**: Books with rental prices over $7.50 were filtered into a dedicated table.

---

## 5. Deep Dive

### Book Issuance and Returns
- Stored procedures automate the process of updating book status upon return.
- Issued books not returned are flagged using `LEFT JOIN` logic.
  
### Overdue and Fines
- A table (`overdue_summary`) tracks number of overdue books per member.
- Fines are calculated at `$0.50` per day past 30 days.
  
### Branch and Employee Performance
- A performance report aggregates issued/returned books and total revenue by branch.
- Employee performance is evaluated based on the number of book issues they processed.

### Inventory and Book Quality
- Return records log book quality.
- Members issuing damaged books multiple times are flagged.

---

## 6. Recommendations

Based on the insights and deep dive:

- **Introduce automated overdue reminders** for members with pending returns.
- **Reward high-performing branches and employees** to boost morale and performance.
- **Track damaged books more closely** and penalize repeat offenders.
- **Highlight popular or premium books** in marketing to increase rentals.
- **Optimize inventory** at underperforming branches using rental data.

---

## Technologies Used

- SQL (MySQL syntax)
- Stored Procedures
- Common Table Expressions (CTEs)
- CTAS (Create Table As Select)

---

## Folder Structure

All SQL code is contained in one structured `.sql` file. Future versions may include:

