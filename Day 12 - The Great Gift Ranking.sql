WITH all_rankings AS
(
    SELECT
        gift_name,
        PERCENT_RANK() OVER (ORDER BY request_count) overall_rank
    FROM
        gifts
    JOIN
    (
        SELECT
            gift_id,
            COUNT(*) request_count
        FROM
            gift_requests
        GROUP BY
            gift_id
    )
    USING
        (gift_id)
), rank_of_rankings AS
(
    /* So we can get the second highest percentile */
    SELECT
        gift_name,
        overall_rank,
        DENSE_RANK() OVER (ORDER BY overall_rank DESC) rank_ranking
    FROM
        all_rankings
)
SELECT
    gift_name,
    ROUND(overall_rank::NUMERIC, 2)
FROM
    rank_of_rankings
WHERE
    rank_ranking = 2
ORDER BY
    gift_name
LIMIT 1;