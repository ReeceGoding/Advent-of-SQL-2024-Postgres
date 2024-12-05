WITH Lagged AS
(
    SELECT
        production_date,
        toys_produced,
        LAG(toys_produced) OVER (ORDER BY production_date) previous_day_production
    FROM toy_production
), TableReqeusted AS
(
    SELECT
        production_date,
        toys_produced,
        previous_day_production,
        toys_produced - previous_day_production production_change,
        ROUND(100.0 - (100.0 * previous_day_production / toys_produced), 2) production_change_percentage
    FROM
        Lagged
)
SELECT
    production_date
FROM
    TableReqeusted
ORDER BY
    production_change_percentage DESC NULLS LAST
LIMIT 1;
