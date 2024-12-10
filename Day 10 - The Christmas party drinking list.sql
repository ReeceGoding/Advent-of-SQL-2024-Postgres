SELECT
    date
FROM
    Drinks
GROUP BY
    Date
HAVING
        SUM(CASE WHEN drink_name = 'Eggnog' THEN quantity END) = 198
    AND
        SUM(CASE WHEN drink_name = 'Hot Cocoa' THEN quantity END) = 38
    AND
        SUM(CASE WHEN drink_name = 'Peppermint Schnapps' THEN quantity END) = 298;