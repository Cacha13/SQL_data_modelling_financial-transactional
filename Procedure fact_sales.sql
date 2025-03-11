-- PROCEDURE: dim_fact.proce_fact_sales(text, text)

-- DROP PROCEDURE IF EXISTS dim_fact.proce_fact_sales(text, text);

CREATE OR REPLACE PROCEDURE dim_fact.proce_fact_sales(
	IN P_YEAR text,
	IN P_MONTH text DEFAULT NULL::text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    IF P_MONTH IS NULL THEN
        INSERT INTO dim_fact.fact_sales
        SELECT
            product_id,
            client_id,
			seller_id,
            CAST(EXTRACT(YEAR FROM sale_date) AS INTEGER) * 100 + CAST(EXTRACT(MONTH FROM sale_date) AS INTEGER),
            SUM(price),
            SUM(quantity)
        FROM stage.sales_orders
        WHERE EXTRACT(YEAR FROM salee_date) = P_YEAR::INTEGER
        GROUP BY sale_date, product_id, client_id, seller_id;
    ELSE 
        INSERT INTO dim_fact.fact_sales
        SELECT
            product_id,
            client_id,
			seller_id,
            CAST(EXTRACT(YEAR FROM sale_date) AS INTEGER) * 100 + CAST(EXTRACT(MONTH FROM sale_date) AS INTEGER),
            SUM(price),
            SUM(quantity)
        FROM stage.sales_orders
        WHERE EXTRACT(YEAR FROM sale_date) = P_YEAR::INTEGER
          AND EXTRACT(MONTH FROM sale_date) = P_MONTH::INTEGER
        GROUP BY sale_date, product_id, client_id, seller_id;
    END IF;
    COMMIT;
END;
$BODY$;
ALTER PROCEDURE dim_fact.proce_fact_sales(text, text)
    OWNER TO postgres;