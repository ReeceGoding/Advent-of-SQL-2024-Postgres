SELECT
    STRING_AGG(ANSI_Value, '') OVER (ORDER BY table_index, id) decoded_message
FROM
(
    SELECT
        1 table_index
        ,id
        ,CHR(value) ANSI_Value
    FROM
        public.letters_a

    UNION ALL

    SELECT
        2 table_index
        ,id
        ,CHR(value) ANSI_Value
    FROM
        public.letters_b
) RawLetter
WHERE
    ANSI_Value ~ '[a-zA-Z !"''(),.:;?-]'
ORDER BY
    LENGTH(STRING_AGG(ANSI_Value, '') OVER (ORDER BY table_index, id)) DESC
LIMIT 1;