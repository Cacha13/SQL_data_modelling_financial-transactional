-- FUNCTION: dim_fact.insert_dim_client()

-- DROP FUNCTION IF EXISTS dim_fact.insert_dim_client();

CREATE OR REPLACE FUNCTION dim_fact.insert_dim_client()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    CALL dim_fact.insert_dim_client(NEW.id, NEW.company, NEW.city_id);
    RETURN NEW;
COMMIT;
END;
$BODY$;

ALTER FUNCTION dim_fact.insert_dim_client()
    OWNER TO postgres;


CREATE TRIGGER trg_insert_client
AFTER INSERT ON stage.client
FOR EACH ROW
EXECUTE FUNCTION dim_fact.insert_dim_client();
