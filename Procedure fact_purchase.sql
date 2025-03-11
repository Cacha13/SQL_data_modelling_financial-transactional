-- PROCEDURE: dim_fact.proce_fact_purchase(text, text)

-- DROP PROCEDURE IF EXISTS dim_fact.proce_fact_purchase(text, text);

CREATE OR REPLACE PROCEDURE dim_fact.proce_fact_purchase(
	IN P_YEAR TEXT,
	IN P_MONTH TEXT DEFAULT NULL::text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    IF P_MONTH IS NULL THEN
        INSERT INTO dim_fact.fact_purchase
        SELECT
            product_id,
            supplier_id,
            CAST(EXTRACT(YEAR FROM purchase_date) AS INTEGER) * 100 + CAST(EXTRACT(MONTH FROM purchase_date) AS INTEGER),
            SUM(price),
            SUM(quantity)
        FROM stage.purchase_orders
        WHERE EXTRACT(YEAR FROM purchase_date) = P_YEAR::INTEGER
        GROUP BY purchase_date, product_id, supplier_id;
    ELSE 
        INSERT INTO dim_fact.fact_purchase
        SELECT
            product_id,
            supplier_id,
            CAST(EXTRACT(YEAR FROM purchase_date) AS INTEGER) * 100 + CAST(EXTRACT(MONTH FROM purchase_date) AS INTEGER),
            SUM(price),
            SUM(quantity)
        FROM stage.purchase_orders
        WHERE EXTRACT(YEAR FROM purchase_date) = P_YEAR::INTEGER
          AND EXTRACT(MONTH FROM purchase_date) = P_MONTH::INTEGER
        GROUP BY purchase_date, product_id, supplier_id;
    END IF;
    COMMIT;
END;
$BODY$;
ALTER PROCEDURE dim_fact.proce_fact_purchase(text, text)
    OWNER TO postgres;
