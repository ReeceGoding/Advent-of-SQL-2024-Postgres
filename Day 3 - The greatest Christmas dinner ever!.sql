WITH counts AS
(
    SELECT
        xpath('//food_item_id/text()', menu_data) food_item_list,
        (CASE
            (xpath('//@version', menu_data))[1]::varchar::decimal
        WHEN
            3.0
        THEN
            xpath('//total_present/text()', menu_data) 
        WHEN
            2.0
        THEN
            xpath('//tables_count/text() * //seats_per_table/text()', menu_data)
        WHEN 
            1.0
        THEN
            xpath('//total_count/text()', menu_data)
        END)[1]::varchar::int guest_count
    FROM christmas_menus
)
SELECT
    unnest(food_item_list::varchar[]::integer[]) food_items
FROM
    counts
WHERE
    guest_count > 78
GROUP BY
    unnest(food_item_list::varchar[]::integer[])
ORDER BY
    count(*) DESC
LIMIT
    1;