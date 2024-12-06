WITH desired_table AS
(
    SELECT
        children.name child_name,
        gifts.name gift_name,
        gifts.price gift_price
    FROM
        children
    JOIN
        gifts
    USING
        (child_id)
    WHERE
        price > (SELECT AVG(price) FROM gifts)
)
SELECT
    child_name
FROM
    desired_table
ORDER BY
    gift_price
LIMIT 1;