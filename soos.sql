WITH stats AS (
    SELECT 
        AVG(SALE_PRICE) AS avg_sale_price,
        STDDEV(SALE_PRICE) AS stddev_sale_price
    FROM sales
),
neighborhood_stats AS (
    SELECT 
        NEIGHBORHOOD,
        BUILDING_CLASS,
        AVG(SALE_PRICE) AS avg_sale_price_neighborhood,
        STDDEV(SALE_PRICE) AS stddev_sale_price_neighborhood
    FROM sales
    GROUP BY NEIGHBORHOOD, BUILDING_CLASS
)
SELECT 
    s.*,
    (s.SALE_PRICE - st.avg_sale_price) / st.stddev_sale_price AS sale_price_zscore,
    (s.SALE_PRICE - ns.avg_sale_price_neighborhood) / ns.stddev_sale_price_neighborhood AS sale_price_zscore_neighborhood,
    s.SQUARE_FEET / s.UNITS AS square_ft_per_unit,
    s.SALE_PRICE / s.UNITS AS price_per_unit
FROM 
    sales s
CROSS JOIN 
    stats st
JOIN 
    neighborhood_stats ns
ON 
    s.NEIGHBORHOOD = ns.NEIGHBORHOOD AND s.BUILDING_CLASS = ns.BUILDING_CLASS;