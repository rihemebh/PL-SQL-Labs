--EX1
CREATE FUNCTION toMajus() RETURNS TRIGGER AS $$

BEGIN
NEW.ST :=UPPER(OLD.ST);
NEW.STATE_NAME := UPPER(OLD.STATE_NAME);
RETURN NEW;
END
$$ LANGUAGE plpgsql;
CREATE TRIGGER majus
BEFORE INSERT OR UPDATE
ON DEMO_STATES
FOR EACH ROW 
EXECUTE PROCEDURE toMajus();

--EX2 
CREATE OR REPLACE FUNCTION conjoint() RETURNS TRIGGER AS $$
DECLARE conj clibanque%ROWTYPE;
BEGIN
SELECT * into conj FROM clibanque where clibanque.idCli= NEW.idConjoint;

if (conj is not null) then

if (conj.idConjoint != NEW.idCli OR conj.idConjoint is null) then
raise exception 'conjoint invalid';
end if;

end if;

RETURN NEW;
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER conjoint
BEFORE INSERT OR UPDATE
ON clibanque
FOR EACH ROW 
EXECUTE PROCEDURE conjoint();

--EX3

CREATE OR REPLACE FUNCTION STAT_TRIGG() RETURNS TRIGGER AS $$
DECLARE query stats.typeMaj%TYPE;
BEGIN
query := TG_OP ;
UPDATE stats set nbMaj = nbMaj+1, timestampModif=NOW() where typeMaj= query;
RETURN NEW;
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER STAT_TRIGG
AFTER INSERT OR UPDATE OR DELETE
ON EMP
FOR EACH ROW 
EXECUTE PROCEDURE STAT_TRIGG();
