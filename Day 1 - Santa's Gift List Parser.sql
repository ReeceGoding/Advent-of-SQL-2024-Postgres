SELECT
    children.name,
    wish_json.first_choice AS primary_wish,
    wish_json.second_choice AS backup_wish,
    wish_json.colors[1] AS favorite_color,
    cardinality(wish_json.colors) AS color_count,
    CASE toy_catalogue.difficulty_to_make
        WHEN 1 THEN 'Simple Gift'
        WHEN 2 THEN 'Moderate Gift'
        ELSE 'Complex Gift'
    END AS gift_complexity,
    CASE toy_catalogue.category
        WHEN 'outdoor' THEN 'Outside Workshop'
        WHEN 'educational' THEN 'Learning Workshop'
        ELSE 'General Workshop'
    END AS workshop_assignment 
FROM
    wish_lists
CROSS JOIN LATERAL
    json_to_record(wish_lists.wishes) AS wish_json(first_choice TEXT, second_choice TEXT, colors TEXT[])
INNER JOIN
    children
ON
    wish_lists.child_id = children.child_id
INNER JOIN
    toy_catalogue
ON
    wish_json.first_choice = toy_catalogue.toy_name
ORDER BY
    children.name
LIMIT 5;