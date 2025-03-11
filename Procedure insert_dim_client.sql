-- PROCEDURE: dim_fact.INSERT_DIM_CLIENT()

-- DROP PROCEDURE IF EXISTS dim_fact."INSERT_DIM_CLIENT"();

CREATE OR REPLACE PROCEDURE dim_fact."INSERT_DIM_CLIENT"(
	)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    INSERT INTO dim_fact.dim_client(id, company, city_id)
    SELECT id, company, city_id
    FROM stage.client
	ON CONFLICT (id) DO NOTHING;
    COMMIT;
END;
$BODY$;
ALTER PROCEDURE dim_fact."INSERT_DIM_CLIENT"()
    OWNER TO postgres;