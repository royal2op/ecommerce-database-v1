CREATE TRIGGER prevent_bad_order
BEFORE INSERT ON order_items
FOR EACH ROW
WHEN NEW.quantity > (
    SELECT stock
    FROM products
    WHERE id = NEW.product_id
)
BEGIN
    SELECT RAISE(ABORT, 'Requested quantity exceeds available stock');
END;
CREATE TRIGGER reserve_stock
AFTER UPDATE ON Orders
FOR EACH ROW
WHEN NEW.status = 'reserved'
     AND OLD.status != 'reserved'
BEGIN
    UPDATE Products
    SET stock = stock - (
        SELECT SUM(quantity)
        FROM order_items
        WHERE order_items.product_id = Products.id
          AND order_items.order_id = NEW.id
    )
    WHERE id IN (
        SELECT product_id
        FROM order_items
        WHERE order_id = NEW.id
    );

    UPDATE Orders
    SET reserved_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.id;
END;
CREATE TRIGGER restore_stock
AFTER UPDATE ON Orders
FOR EACH ROW
WHEN NEW.status IN ('expired','cancelled')
     AND OLD.status = 'reserved'
BEGIN
    UPDATE Products
    SET stock = stock + (
        SELECT SUM(quantity)
        FROM order_items
        WHERE order_items.product_id = Products.id
          AND order_items.order_id = NEW.id
    )
    WHERE id IN (
        SELECT product_id
        FROM order_items
        WHERE order_id = NEW.id
    );

    UPDATE Orders
    SET 
        expired_at = CASE 
            WHEN NEW.status = 'expired' THEN CURRENT_TIMESTAMP
            ELSE expired_at
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.id;
END;
CREATE TRIGGER update_order_timestamp
AFTER UPDATE ON Orders
FOR EACH ROW
WHEN NEW.status != OLD.status
BEGIN
    UPDATE Orders
    SET updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.id;
END;
CREATE TRIGGER validate_payment_amount
BEFORE UPDATE ON payments
FOR EACH ROW
WHEN NEW.payment_status = 'completed'
BEGIN
    SELECT CASE
        WHEN NEW.amount != (
            SELECT amount
            FROM Orders
            WHERE id = NEW.order_id
        )
        THEN RAISE(ABORT, 'Payment amount must match order total')
    END;
END;