# Library Management System — SQL Project

## 1. Background and Overview

This project simulates a Library Management System using SQL to manage and analyze library operations. It focuses on data-driven decision-making by leveraging real-world database design, SQL querying, reporting, and automation techniques.

The goal is to replicate how modern libraries operate — tracking books, members, employees, branches, book issues/returns — and to surface insights that can improve operational efficiency, member engagement, and financial performance.

---

## 2. Data Structure and Overview

The system is built on **six core tables** with appropriate primary and foreign key relationships:

- **branch**: Stores branch details including manager and address  
- **employees**: Staff working at branches  
- **books**: All books in the catalog  
- **members**: Registered library members  
- **issued_status**: Tracks which books are issued to whom and when  
- **return_status**: Tracks when books are returned and their condition  

Additional derived tables like `book_issue_summary`, `branch_performance_report`, `active_members`, and `overdue_summary` are created using **CTAS (Create Table As Select)** queries to support reporting and business insights.

---

## 3. Executive Summary

This SQL-based library system answers key business questions such as:

- Which branches or employees are performing best?
- What’s the status of issued vs. returned books?
- Who are the most active or overdue members?
- What categories or books are generating the most rental revenue?
- Are any books being repeatedly returned in poor condition?

Using complex SQL features like **joins, CTEs, subqueries, stored procedures, and triggers**, this system automates routine tasks and enables in-depth analysis of the library's health.

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

