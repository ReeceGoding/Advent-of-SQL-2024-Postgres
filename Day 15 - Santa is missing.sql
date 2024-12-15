/*
    As far as I can tell, the example is completely wrong.
    The example asks you to find a location at a particular time.
    Despite asking for one location, the example result gives three.
    The actual challenge then asks you to find the latest location.
*/
SELECT
    place_name
FROM
    areas
WHERE
    ST_Intersects(areas.polygon, (SELECT coordinate FROM sleigh_locations ORDER BY timestamp DESC LIMIT 1));