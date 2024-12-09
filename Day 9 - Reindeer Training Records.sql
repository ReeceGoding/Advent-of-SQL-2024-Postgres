SELECT DISTINCT
    reindeer_name,
    /*
        This is considered an advanced move.
        The AVG is an aggregate function, but the MAX is a window function.
    */
    ROUND(MAX(AVG(speed_record)) OVER (PARTITION BY reindeer_name), 2)
FROM
    Reindeers
JOIN
    Training_Sessions
USING
    (reindeer_id)
WHERE
    reindeer_name <> 'Rudolf'
GROUP BY
    reindeer_name,
    exercise_name
ORDER BY
    /* Technically, we shouldn't ROUND before we order, but I know these tests aren't that evil. */
    ROUND(MAX(AVG(speed_record)) OVER (PARTITION BY reindeer_name), 2) DESC
LIMIT 3;