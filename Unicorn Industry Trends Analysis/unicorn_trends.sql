-- unicorn_trends.sql
-- Project: Unicorn Industry Trends Analysis
-- Description: Identify top 3 industries by new unicorns (2019-2021) and analyze their trends

WITH top_industries AS (
    -- Step 1: Find top 3 industries by total unicorns 2019-2021
    SELECT 
        i.industry,
        COUNT(DISTINCT d.company_id) AS total_unicorns
    FROM 
        dates d
    JOIN 
        industries i ON d.company_id = i.company_id
    WHERE 
        EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
    GROUP BY 
        i.industry
    ORDER BY 
        total_unicorns DESC
    LIMIT 3
),
unicorn_details AS (
    -- Step 2: Get details for top 3 industries
    SELECT 
        i.industry,
        EXTRACT(YEAR FROM d.date_joined) AS year,
        COUNT(DISTINCT d.company_id) AS num_unicorns,
        ROUND(AVG(f.valuation) / 1000000000, 2) AS average_valuation_billions
    FROM 
        dates d
    JOIN 
        industries i ON d.company_id = i.company_id
    JOIN 
        funding f ON d.company_id = f.company_id
    WHERE 
        i.industry IN (SELECT industry FROM top_industries)
        AND EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
    GROUP BY 
        i.industry,
        EXTRACT(YEAR FROM d.date_joined)
)
-- Final output
SELECT 
    industry,
    year,
    num_unicorns,
    average_valuation_billions
FROM 
    unicorn_details
ORDER BY 
    year DESC,
    num_unicorns DESC;
