# 🛒 E-Commerce Database Architecture (SQLite) – v1

A robust, relational database system designed to simulate a production-grade e-commerce backend. This project focuses on **data integrity, transactional consistency, and enforcing business logic** directly at the database layer using constraints and triggers.

---

## 🧠 Why I Built This
I developed this project to deepen my understanding of:
* **ACID Properties:** Ensuring reliable transactions.
* **Order State Management:** Controlling the flow of data from `pending` to `paid/canceled`.
* **Database-Level Logic:** Enforcing business rules via triggers and constraints.
* **Data Integrity:** Protecting the system from invalid states (e.g., negative inventory) even if the application layer fails.

---

## 🗂 Database Schema (ERD)
<img width="614" height="354" alt="image" src="https://github.com/user-attachments/assets/a8db6227-3c02-4a59-8c05-5212effa3104" />

---

## 🚀 Key Features

### 🔁 Automated Order Lifecycle
Supports controlled state transitions:
* `pending` → `reserved` → `paid`
* `pending` → `expired`
* `pending` → `cancelled`

### 🛡 Defensive Database Design
* **CHECK Constraints:** Prevents invalid states (e.g., non-negative stock).
* **Foreign Keys:** Maintains referential integrity and prevents orphaned records.
* **Automated Logic:** Expired or cancelled orders automatically restore inventory.

### ⚙️ Business Logic at the Database Layer
Implemented using **SQLite Triggers** to ensure consistency across any system:
* `prevent_bad_order`
* `reserve_stock`
* `restore_stock`
* `validate_payment_amount`
* `reduce_stock_after_payment`

---

## 🧱 Tech Stack
* **Database:** SQLite
* **Design Principles:** Relational Normalization (3NF)
* **Core Concepts:** Constraints, Triggers, Index Optimization, `EXPLAIN QUERY PLAN`

---

## 📊 Example Queries

### Total Revenue
```sql
SELECT SUM(amount) AS total_revenue
FROM orders
WHERE status = 'paid';
Top Customers by Spending
SQL
SELECT u.username, SUM(o.amount) AS total_spent
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'paid'
GROUP BY u.username
ORDER BY total_spent DESC
LIMIT 5;
🛠 Getting Started
Bash
sqlite3 ecommerce.db
.read schema.sql
.read seed.sql
.read indexes.sql
📈 Roadmap
v2: Implement full/partial refund systems, advanced indexing, and performance benchmarking.

v3: Migrate schema to PostgreSQL and simulate concurrency-safe transactions.

v4: Develop a REST API wrapper (Node.js or Python).

🧠 Project Philosophy
This project is about thinking like a backend architect:

Design first: Planning schemas before implementation.

Defensive Programming: Enforcing invariants at the lowest possible level.

Iterative Growth: Treating the project as a living system that evolves through versions and migrations.


---
