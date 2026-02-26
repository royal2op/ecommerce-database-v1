# ecommerce-database-v1
Overview

This project simulates the backend data layer of a small e-commerce platform using SQLite. It is designed to demonstrate:

• Relational database design with multiple interconnected tables.
• Order lifecycle management (pending → reserved → paid / expired / canceled).
• Data integrity through foreign keys and constraints.
• Business logic enforcement via triggers (e.g., stock management, payment validation).
• Analytical queries for business intelligence.

The database includes seed data with realistic users, products, orders, carts, and payments to showcase practical use cases.

Features

• Relational Schema Design: Fully normalized tables for users, products, orders, cart, and payments.
• Order Lifecycle Management: Handles reserved stock, payments, cancellations, and expiration logic.
• Constraints:
  • Foreign keys to maintain relationships.
  • CHECK constraints for status and quantities.
  • Stock cannot go negative.
•Triggers: Automatic enforcement of business rules:
  • Prevent orders with insufficient stock (prevent_bad_order)
  • Reserve stock when order is reserved (reserve_stock)
  • Restore stock if order is canceled or expired (restore_stock)
  • Validate payment amounts against order totals (validate_payment_amount)
  • Reduce stock after successful payment (reduce_stock_after_payment)

•Seed Data: Realistic example data for users, products, orders, cart items, and payments.
•Analytical Queries: Example queries to track revenue, top-selling products, and customer activity.

Database Schema

Tables:

1. Users – Stores registered user information (username, email, country, creation date, active status).
2. Products – Stores product details (name, description, price, stock, category, creation and update timestamps).
3. Orders – Stores all orders including status, reserved times, payment status, and total amount.
4. Order_Items – Stores the products included in each order, quantity, and price at purchase.
5. Payments – Stores payment details and status for each order.
6. Cart – Temporary storage of user-selected items before checkout.
7. Cart_Items – Stores individual products and quantities in each cart.

Triggers:

• prevent_bad_order – Prevents ordering more stock than available.
• reserve_stock – Reduces stock when an order is reserved.
• restore_stock – Restores stock if order expires or is canceled.
• validate_payment_amount – Ensures payment matches order total.
• reduce_stock_after_payment – Reduces stock after successful payment.

How to Run

1.Clone the repository or download files.

2. Open SQLite CLI or SQLite Browser.

3. Create the database:

sqlite3 ecommerce.db

4. Load schema:

.read schema.sql

5. Load seed data:

.read seed.sql

6. Create indexes (optional but recommended for large datasets):

.read indexes.sql

7. Test queries:

.read queries.sql


Example Queries

• Total revenue from paid orders:

SELECT SUM(amount) AS total_revenue
FROM orders
WHERE status = 'paid';

• Top-selling products:

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

• Top customers by total spending:

SELECT u.username, SUM(o.amount) AS total_spent
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'paid'
GROUP BY u.username
ORDER BY total_spent DESC
LIMIT 5;


Project Status

• ✅ Schema design complete
• ✅ Seed data populated
• ✅ Triggers implemented for stock and payment logic
• ✅ Basic analytical queries included

Next steps (v2 planned):

• Refund and partial refund handling
• Advanced reporting and analytics
• Performance optimization and indexing
• Migration to other SQL databases (PostgreSQL, MySQL)
• Integration with a backend application (Node.js / Python)

Contributing

This project is designed as a learning portfolio. If you want to experiment:

• Make a copy of the database before making changes.
• Add new tables, triggers, or queries in separate .sql files.
• Keep seed data realistic for future testing.

License

This project is open-source for learning purposes. You may use, modify, and study the schema and queries.
