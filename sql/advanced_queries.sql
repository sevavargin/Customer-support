-- Запрос 11.
WITH type_ratings AS (
    SELECT 
        tt.ticket_type_name, 
        AVG(t.customer_satisfaction_rating) as avg_rating
    FROM tickets t
    JOIN ticket_types tt ON tt.ticket_type_id = t.ticket_type_id
    GROUP BY tt.ticket_type_name
)
SELECT *
FROM type_ratings
WHERE avg_rating < 3
ORDER BY avg_rating;


-- Запрос 12.
CREATE VIEW IF NOT EXISTS critical_tickets_view AS
SELECT 
    t.ticket_id,
    c.customer_name,
    p.product_name,
    t.ticket_channel,
    t.customer_satisfaction_rating
FROM tickets t
JOIN customers c ON c.customer_id = t.customer_id
JOIN products p ON p.product_id = t.product_id
WHERE t.ticket_priority = 'Critical';

-- Проверка
SELECT * FROM critical_tickets_view LIMIT 5;


-- Запрос 13.
SELECT
    t.ticket_id,
    t.product_id,
    t.purchase_date,
    ROW_NUMBER() OVER (
        PARTITION BY t.product_id
        ORDER BY t.purchase_date
    ) as purchase_order_num
FROM tickets t;


-- Запрос 14.
SELECT
    t.customer_id,
    t.ticket_id,
    t.purchase_date,
    t.customer_satisfaction_rating,
    LAG(t.customer_satisfaction_rating) OVER (
        PARTITION BY t.customer_id
        ORDER BY t.purchase_date
    ) as previous_rating
FROM tickets t;


-- Запрос 15.
SELECT 
    t.ticket_id,
    t.ticket_priority,
    t.customer_satisfaction_rating,
    AVG(t.customer_satisfaction_rating) OVER (
        PARTITION BY t.ticket_priority
    ) as avg_rating_for_priority
FROM tickets t;
