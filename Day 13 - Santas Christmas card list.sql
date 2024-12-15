SELECT
    /*
        The example wants more than we give here,
        but we don't need that to satisfy the challenge.
    */
    SPLIT_PART(UNNEST(email_addresses), '@', 2) domain,
    COUNT(*) AS "Total Users"
FROM
    contact_list
GROUP BY
    SPLIT_PART(UNNEST(email_addresses), '@', 2)
ORDER BY
    "Total Users" DESC
LIMIT 1;