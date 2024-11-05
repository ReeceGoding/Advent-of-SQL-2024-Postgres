WITH ranked_data AS (
    SELECT
        country,
        city,
        AVG(naughty_nice_score) AS avg_naughty_nice_score,
        /* So we can filter for the requirement to find the top cities in each country with the highest average naughty_nice_score. */
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY AVG(naughty_nice_score) DESC) AS rank_of_avg_naughty_nice_score_within_country
    FROM public.children
    /* Requirement: Only children with gifts. */
    WHERE child_id IN (SELECT lists.child_id FROM public.christmaslist AS lists)
    GROUP BY country, city
    /* Requirement: Only include cities with at least 5 children. */
    HAVING COUNT (child_id) >= 5
)
SELECT
    city
FROM
    ranked_data
WHERE
    /* Requirement: Max top 3 cities for each country. */
    rank_of_avg_naughty_nice_score_within_country <= 3;
