SELECT
    properties.city,
    properties.month,
    AVG(properties.monthly_rent) AS avg_monthly_rent,
    AVG(SUM(properties.monthly_rent) OVER (PARTITION BY properties.city ORDER BY properties.month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) AS avg_cumulative_rent
FROM
    properties
INNER JOIN universities ON properties.city = universities.city
WHERE
    properties.year = 2020
GROUP BY
    properties.city,
    properties.month
ORDER BY
    properties.city,
    properties.month;


    SELECT 
    conditions.city, 
    conditions.week, 
    COUNT(CASE WHEN conditions.status = 'free' THEN 1 ELSE NULL END) AS free_conditions_count,
    COUNT(*) OVER (PARTITION BY conditions.city, conditions.week) AS total_conditions_count,
    COUNT(CASE WHEN conditions.status = 'free' THEN 1 ELSE NULL END) / COUNT(*) OVER (PARTITION BY conditions.city, conditions.week) AS ratio,
    RANK() OVER (ORDER BY COUNT(CASE WHEN conditions.status = 'free' THEN 1 ELSE NULL END) DESC) AS rank
FROM 
    conditions
JOIN
    locations ON conditions.address = locations.address
WHERE 
    conditions.status = 'free' AND 
    locations.region = 'Kyiv Oblast' AND 
    conditions.week = 9 AND
    conditions.city IS NOT NULL
GROUP BY 
    conditions.city, 
    conditions.week
ORDER BY 
    rank ASC;


    SELECT 
    CASE 
        WHEN property.city IS NOT NULL THEN property.city 
        ELSE property.district 
    END AS location,
    AVG(property.rent_price) AS avg_monthly_rent_city,
    AVG(district_property.rent_price) AS avg_monthly_rent_district
FROM 
    property 
    LEFT JOIN property AS district_property 
        ON property.district = district_property.district 
        AND district_property.city IS NULL
WHERE 
    property.region = 'Закарпаття'
    AND property.available_from >= '2020-09-01'
    AND property.available_from < '2020-12-01'
GROUP BY 
    location


    SELECT 
    property.city,
    YEAR(property.available_from) AS year,
    MONTH(property.available_from) AS month,
    AVG(property.rent_price) AS avg_monthly_rent,
    AVG(property.rent_price / property.area) AS avg_rent_per_sqm
FROM 
    property 
WHERE 
    property.has_bed = 1 
    AND property.has_desk = 1 
    AND property.city IN (
        SELECT DISTINCT city FROM university
    )
    AND YEAR(property.available_from) = 2020
GROUP BY 
    property.city,
    YEAR(property.available_from),
    MONTH(property.available_from)