-- revenue_by_product_line.sql
-- Project: Analyzing Motorcycle Part Sales
-- Description: Calculate wholesale net revenue per product line, month, and warehouse

SELECT 
    product_line,
    CASE 
        WHEN EXTRACT(MONTH FROM date) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM date) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM date) = 8 THEN 'August'
    END AS month,
    warehouse,
    SUM(total - payment_fee) AS net_revenue
FROM 
    sales
WHERE 
    client_type = 'Wholesale'  -- Filter for Wholesale orders only
    AND EXTRACT(MONTH FROM date) IN (6, 7, 8)  -- June, July, August
    AND EXTRACT(YEAR FROM date) = 2021  -- Match 2021 as specified
GROUP BY 
    product_line,
    EXTRACT(MONTH FROM date),  -- Group by numeric month for sorting
    warehouse
ORDER BY 
    product_line,
    EXTRACT(MONTH FROM date),  -- Ensures June, July, August order
    net_revenue DESC;
