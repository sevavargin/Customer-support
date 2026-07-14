-- Запрос 1.
SELECT ticket_id, ticket_channel, first_response_time
FROM tickets
WHERE ticket_channel = 'Email'
ORDER BY first_response_time ASC;


-- Запрос 2.
SELECT 
    ticket_priority, 
    COUNT(*) as count_for_priority,
    AVG(customer_satisfaction_rating) as avg_rating
FROM tickets 
GROUP BY ticket_priority
HAVING COUNT(*) > 500;


-- Запрос 3.
SELECT
    ticket_id, 
    customer_satisfaction_rating,
    CASE
        WHEN customer_satisfaction_rating BETWEEN 4 AND 5 THEN 'High'
        WHEN customer_satisfaction_rating BETWEEN 2 AND 3 THEN 'Medium'
        WHEN customer_satisfaction_rating = 1 THEN 'Low'
        ELSE 'No rating'
    END as satisfaction_level
FROM tickets;


-- Запрос 4.
SELECT 
    t.ticket_id, 
    p.product_name, 
    tt.ticket_type_name
FROM tickets t
JOIN products p ON p.product_id = t.product_id
JOIN ticket_types tt ON tt.ticket_type_id = t.ticket_type_id
LIMIT 10;


-- Запрос 5.
SELECT 
    p.product_name, 
    COUNT(*) as product_count
FROM tickets t
JOIN products p ON p.product_id = t.product_id
GROUP BY p.product_name
ORDER BY COUNT(*) DESC
LIMIT 10;


-- Запрос 6.
SELECT 
    ticket_id, ticket_priority, ticket_channel
FROM tickets
WHERE ticket_priority = 'Critical' AND ticket_channel = 'Phone';


-- Запрос 7.
SELECT t.ticket_id, t.ticket_status
FROM tickets t
WHERE ticket_status IN ('Closed', 'Pending Customer Response');


-- Запрос 8.
SELECT
    CASE
        WHEN ticket_channel IN ('Email', 'Chat', 'Social media') THEN 'Онлайн'
        WHEN ticket_channel = 'Phone' THEN 'Оффлайн'
    END as channel_group,
    COUNT(*) as tickets_count
FROM tickets
GROUP BY channel_group;


-- Запрос 9.
SELECT
    MIN(c.customer_age) as min_age,
    MAX(c.customer_age) as max_age
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.ticket_priority = 'Critical';


-- Запрос 10
SELECT
    ticket_channel,
    COUNT(*) as tickets_count,
    AVG(customer_satisfaction_rating) as avg_rating
FROM tickets
GROUP BY ticket_channel
HAVING AVG(customer_satisfaction_rating) < 3;