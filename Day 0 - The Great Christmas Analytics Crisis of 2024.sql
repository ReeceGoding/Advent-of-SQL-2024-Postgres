WITH cities_with_at_least_5_children AS (
    SELECT
        country,
        city
    FROM public.children
    GROUP BY country, city
    /*
        Requirement: Only include cities with at least 5 children.
        We must do this filtering here, or else we would only be grabbing the cities with at least 5 children with gifts.
    */
    HAVING COUNT (child_id) >= 5
), ranked_data AS (
    SELECT
        country,
        city,
        AVG(naughty_nice_score) AS avg_naughty_nice_score,
        /* So we can filter for the requirement to find the top cities in each country with the highest average naughty_nice_score. */
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY AVG(naughty_nice_score) DESC) AS rank_of_avg_naughty_nice_score_within_country
    FROM public.children
    WHERE
            /* Requirement: Only children with gifts. */
            child_id IN (SELECT lists.child_id FROM public.christmaslist AS lists WHERE lists.was_delivered IS TRUE)
        AND
            EXISTS (SELECT 1 FROM cities_with_at_least_5_children AS cities WHERE cities.country = children.country AND cities.city = children.city)
    GROUP BY country, city
)
SELECT
    city
FROM
    ranked_data
WHERE
    /* Requirement: Max top 3 cities for each country. */
    rank_of_avg_naughty_nice_score_within_country <= 3;
