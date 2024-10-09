WITH stats AS (
    SELECT 
        AVG(sale_price) AS avg_sale_price,
        STDDEV(sale_price) AS stddev_sale_price
    FROM nyc_sales
),
neighborhood_stats AS (
    SELECT 
        neighborhood,
        building_class_at_present,
        AVG(sale_price) AS avg_sale_price_neighborhood,
        STDDEV(sale_price) AS stddev_sale_price_neighborhood
    FROM nyc_sales
    GROUP BY neighborhood, building_class_at_present
)
SELECT 
    s.*,
    CASE 
        WHEN st.stddev_sale_price > 0 THEN (s.sale_price - st.avg_sale_price) / st.stddev_sale_price 
        ELSE NULL 
    END AS sale_price_zscore,
    CASE 
        WHEN ns.stddev_sale_price_neighborhood > 0 THEN (s.sale_price - ns.avg_sale_price_neighborhood) / ns.stddev_sale_price_neighborhood 
        ELSE NULL 
    END AS sale_price_zscore_neighborhood,
    CASE 
        WHEN s.total_units > 0 THEN s.gross_square_feet / s.total_units 
        ELSE NULL 
    END AS square_ft_per_unit,
    CASE 
        WHEN s.total_units > 0 THEN s.sale_price / s.total_units 
        ELSE NULL 
    END AS price_per_unit
FROM 
    nyc_sales s
CROSS JOIN 
    stats st
JOIN 
    neighborhood_stats ns
ON 
    s.neighborhood = ns.neighborhood AND s.building_class_at_present = ns.building_class_at_present
WHERE 
    s.total_units IS NOT NULL AND s.total_units > 0;

