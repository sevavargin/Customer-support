SELECT ticket_id, ticket_channel, first_response_time
FROM tickets
WHERE ticket_channel = "Email"
ORDER BY first_response_time;

SELECT
    ticket_priority, COUNT(*) as count_for_priority, AVG(customer_satisfaction_rating) as acg_rating
FROM tickets 
GROUP BY ticket_priority
HAVING COUNT(*) > 500