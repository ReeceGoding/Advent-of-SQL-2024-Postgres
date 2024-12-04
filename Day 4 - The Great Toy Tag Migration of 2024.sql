WITH tags_unpacked AS
(
    SELECT
        toy_id,
        toy_name,
        0 is_new, 
        unnest(previous_tags) tag
    FROM
        toy_production c

    UNION ALL

    SELECT
        toy_id,
        toy_name,
        1 is_new, 
        unnest(new_tags) tag
    FROM
        toy_production
), added AS
(
    SELECT
        toy_id,
        array_agg(tag) added_tags
    FROM
        tags_unpacked new
    WHERE
        new.is_new = 1
    AND
        NOT EXISTS
    (
        SELECT
            1
        FROM
            tags_unpacked old
        WHERE
                old.is_new = 0
            AND
                old.toy_id = new.toy_id 
            AND
                old.tag = new.tag
    )
    GROUP BY
        new.toy_id
), unchanged AS
(
    SELECT
        toy_id,
        array_agg(tag) unchanged_tags
    FROM
        tags_unpacked old
    WHERE
        old.is_new = 0
    AND
        EXISTS
    (
        SELECT
            1
        FROM
            tags_unpacked new
        WHERE
                new.is_new = 1
            AND
                new.toy_id = old.toy_id 
            AND
                new.tag = old.tag
    )
    GROUP BY
        old.toy_id
), removed AS
(
    SELECT
        toy_id,
        array_agg(tag) removed_tags
    FROM
        tags_unpacked old
    WHERE
        old.is_new = 0
    AND
        NOT EXISTS
    (
        SELECT
            1
        FROM
            tags_unpacked new
        WHERE
                new.is_new = 1
            AND
                new.toy_id = old.toy_id 
            AND
                new.tag = old.tag
    )
    GROUP BY
        old.toy_id
)
SELECT
    original.toy_id,
    coalesce(cardinality(added_tags), 0) added_tags,
    coalesce(cardinality(unchanged_tags), 0) unchanged_tags,
    coalesce(cardinality(removed_tags), 0) removed_tags
FROM
    toy_production original
LEFT JOIN
    added
ON
    added.toy_id = original.toy_id
LEFT JOIN
    unchanged
ON
    unchanged.toy_id = original.toy_id
LEFT JOIN
    removed
ON
    removed.toy_id = original.toy_id
ORDER BY
    coalesce(cardinality(added_tags), 0) DESC
LIMIT 1;