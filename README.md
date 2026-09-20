# music_store_analysis
Advanced SQL analysis of a music store database using PostgreSQL and pgAdmin 4. Solves 11 business questions on customers, revenue, artists, and genres using joins, subqueries, CTEs, and window functions.


# Music Store Database Analysis (SQL)

A SQL analytics project that answers **11 business questions** on a music store database using **PostgreSQL** and **pgAdmin 4**. The questions progress from easy to advanced and cover customers, revenue, artists, genres, and country-level performance.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Objectives](#objectives)
- [Tools & Technologies](#tools--technologies)
- [Database Schema](#database-schema)
- [Questions Solved](#questions-solved)
- [SQL Concepts Used](#sql-concepts-used)
- [Business Value](#business-value)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Future Improvements](#future-improvements)

---

## Project Overview

A music store wants to understand its customers, sales, and catalog better. This project uses SQL to turn raw transactional data into answers that a business can act on, such as:

- Which city should host a promotional music festival?
- Who are the best customers?
- Which artists and genres perform best?
- What is the most popular genre and top customer in each country?

All queries were written and tested in **PostgreSQL** using **pgAdmin 4**.

---

## Objectives

- Practice writing SQL from basic to advanced level on a realistic multi-table database
- Combine data across many tables using joins
- Use subqueries, CTEs, and window functions to solve multi-step problems
- Convert business questions into clear, correct SQL queries

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Relational database used to store and query the data |
| **pgAdmin 4** | Interface used to write, run, and test the queries |
| **SQL** | Data querying, aggregation, and analysis |

---

## Database Schema

The database follows a music store structure with the following tables:

| Area | Tables |
|------|--------|
| **Music catalog** | `artist`, `album`, `track`, `genre`, `media_type` |
| **Sales** | `invoice`, `invoice_line` |
| **People** | `customer`, `employee` |
| **Playlists** | `playlist`, `playlist_track` |

**How the tables connect:** `artist → album → track → invoice_line → invoice → customer`. The `track` table also links to `genre` and `media_type`, and `customer` is linked to `employee` through a support representative.

> 📸 Add the schema diagram here: `![Database Schema](images/MusicDatabaseSchema.png)`

---

## Questions Solved

### Question Set 1: Easy

| # | Business Question | Key Concepts |
|---|-------------------|--------------|
| 1 | Who is the most senior employee based on job level? | `ORDER BY`, `LIMIT` |
| 2 | Which countries have the most invoices? | `COUNT`, `GROUP BY` |
| 3 | What are the top 3 invoice totals? | `ORDER BY`, `LIMIT` |
| 4 | Which city has the best customers (highest sum of invoice totals) for a promotional music festival? | `SUM`, `GROUP BY` |
| 5 | Who is the best customer (highest total spend)? | `JOIN`, `SUM`, `GROUP BY` |

### Question Set 2: Moderate

| # | Business Question | Key Concepts |
|---|-------------------|--------------|
| 1 | Return the email, first name, and last name of all Rock music listeners, sorted alphabetically by email | Multi-table `JOIN`, subquery, `DISTINCT`, `LIKE` (solved with two methods) |
| 2 | Which 10 artists have written the most Rock music (by track count)? | Multi-table `JOIN`, `COUNT`, `GROUP BY` |
| 3 | Which tracks are longer than the average song length? | Subquery with `AVG` |

### Question Set 3: Advanced

| # | Business Question | Key Concepts |
|---|-------------------|--------------|
| 1 | How much has each customer spent on the best-selling artist? | CTE, 6-table `JOIN`, `SUM(unit_price * quantity)` |
| 2 | What is the most popular music genre in each country? | CTE, window function `ROW_NUMBER() OVER (PARTITION BY ...)` |
| 3 | Which customer has spent the most on music in each country? | CTE, window function `ROW_NUMBER() OVER (PARTITION BY ...)` |

**Approach notes:**
- For artist revenue, the `invoice_line` table is used instead of `invoice.total`, because an invoice total can include many different products. Revenue is calculated as `unit_price * quantity`.
- For country-level "top" results, a CTE ranks records within each country using a window function, and then only the top-ranked row is kept.

---

## SQL Concepts Used

- `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `DISTINCT`, `LIKE`
- Aggregate functions: `COUNT`, `SUM`, `AVG`
- `GROUP BY`
- `INNER JOIN` across up to six tables
- Subqueries (in `WHERE` conditions)
- Common Table Expressions (CTEs) using `WITH`
- Window functions: `ROW_NUMBER()` with `PARTITION BY`
- Comparing multiple solution methods for the same problem

---

## Business Value

The queries in this project help a music store to:

- **Plan marketing:** find the best-performing city for events and promotions
- **Reward loyal customers:** identify top spenders overall and by country
- **Understand the catalog:** see which artists and genres bring in the most sales
- **Localize offers:** learn which genre is most popular in each country
- **Target customers:** build email lists of listeners for a specific genre, such as Rock

---

## Project Structure

> Update this to match your repository.

```
music-store-sql-analysis/
│
├── music_data_analytics.sql      # All 11 SQL queries (Easy, Moderate, Advanced)
├── images/
│   └── MusicDatabaseSchema.png   # Database schema diagram
├── README.md
└── LICENSE
```

---

## How to Run

1. **Install** [PostgreSQL](https://www.postgresql.org/download/) and **pgAdmin 4**.
2. **Create a new database** in pgAdmin 4 (right-click Databases, then Create, then Database).
3. **Create the tables and import the data** into the database (right-click a table, then Import/Export Data, for CSV files).
4. Open the **Query Tool** (right-click the database, then Query Tool).
5. Open `music_data_analytics.sql` and run the queries **one at a time** by selecting a query and pressing `F5`.

---

## Future Improvements

- Add screenshots of query outputs for each question
- Add more questions on playlists, media types, and employee sales performance
- Add time-based analysis, such as monthly and yearly revenue trends
- Connect the results to Power BI or Python for visualization

---

## Author

**Mohit**


---

⭐ If you found this project useful, consider giving it a star!
