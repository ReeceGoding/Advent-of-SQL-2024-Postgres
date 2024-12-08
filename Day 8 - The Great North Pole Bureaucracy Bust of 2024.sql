WITH RECURSIVE management_chain AS
(
    SELECT
        basis.staff_id,
        basis.staff_name,
        1 level,
        basis.manager_id,
        CAST(basis.staff_id AS TEXT) path
    FROM
        staff basis

    UNION ALL

    SELECT
        staff.staff_id,
        staff.staff_name,
        chain.level + 1 level,
        staff.manager_id,
        cast(chain.path AS TEXT ) || ',' || cast(staff.staff_id AS TEXT)
    FROM
        staff
    JOIN  
        management_chain chain
    ON
        chain.staff_id = staff.manager_id
), desired_table AS
(
    SELECT DISTINCT
        staff_id,
        staff_name,
        /* As always, it is easier to use FIRST_VALUE backwards than use LAST_VALUE properly. */
        FIRST_VALUE(level) OVER (PARTITION BY staff_id ORDER BY level DESC) level,
        FIRST_VALUE(path) OVER (PARTITION BY staff_id ORDER BY level DESC) path
    FROM
        management_chain
    ORDER BY
        level DESC
)
SELECT
    MAX(level)
FROM
    desired_table;