CREATE TABLE IF NOT EXISTS "Orders" (
	"id"	INTEGER,
	"user_id"	INTEGER NOT NULL,
	"amount"	REAL NOT NULL CHECK("amount" >= 0),
	"status"	TEXT NOT NULL DEFAULT 'pending' CHECK("status" IN ('pending', 'reserved', 'paid', 'cancelled', 'expired')),
	"currency"	TEXT DEFAULT 'USD',
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	DATETIME,
	"reserved_at"	DATETIME,
	"expires_at"	DATETIME,
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "Users"("id")
);
CREATE TABLE IF NOT EXISTS "Products" (
	"id"	INTEGER,
	"product_name"	TEXT NOT NULL,
	"description"	TEXT,
	"price"	REAL NOT NULL,
	"stock"	INTEGER NOT NULL CHECK("stock" >= 0),
	"category"	TEXT,
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	DATETIME,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "Users" (
	"id"	INTEGER,
	"username"	TEXT NOT NULL UNIQUE,
	"email"	TEXT NOT NULL UNIQUE,
	"country"	TEXT NOT NULL,
	"created_at"	DATETIME,
	"is_active"	BOOLEAN DEFAULT TRUE,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "cart" (
	"id"	INTEGER,
	"user_id"	INTEGER,
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "Users"("id")
);
CREATE TABLE IF NOT EXISTS "cart_items" (
	"id"	INTEGER,
	"cart_id"	INTEGER NOT NULL,
	"product_id"	INTEGER NOT NULL,
	"quantity"	INTEGER NOT NULL CHECK("quantity" > 0),
	PRIMARY KEY("id"),
	FOREIGN KEY("cart_id") REFERENCES "cart"("id"),
	FOREIGN KEY("product_id") REFERENCES "products"("id")
);
CREATE TABLE IF NOT EXISTS "order_items" (
	"id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"product_id"	INTEGER NOT NULL,
	"quantity"	INTEGER NOT NULL,
	"price_at_purchase"	REAL NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("order_id") REFERENCES "Orders"("id") ON DELETE CASCADE,
	FOREIGN KEY("product_id") REFERENCES "products"("id")
);
CREATE TABLE IF NOT EXISTS "payments" (
	"id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"amount"	REAL NOT NULL,
	"payment_method"	TEXT NOT NULL,
	"payment_status"	TEXT NOT NULL CHECK("payment_status" IN ('pending', 'completed', 'failed', 'refunded')),
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id"),
	FOREIGN KEY("order_id") REFERENCES "Orders"("id") ON DELETE CASCADE
);