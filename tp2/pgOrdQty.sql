CREATE TABLE ord (qty INTEGER);

INSERT INTO ord VALUES(5);
INSERT INTO ord VALUES(NULL);
INSERT INTO ord VALUES(10);
INSERT INTO ord VALUES(8);
INSERT INTO ord VALUES(9);
INSERT INTO ord VALUES(13);

COMMIT;

-- EX3

CREATE OR REPLACE function calcul() returns numeric language plpgsql as $$
DECLARE
liste CURSOR for SELECT qty FROM ORD WHERE qty is NOT NULL ;
x integer; x1 integer; s integer := 0; nb integer;
BEGIN
select count(*) into nb from ORD  WHERE qty is NOT NULL ; 
if nb<2 then 
raise exception 'exp';
end if;
nb:=0;
Open liste;
fetch liste into x;
fetch liste into x1;
while (FOUND) loop
s=s+ABS(x-x1);
x1=x; nb:=nb+1;
fetch liste into x;
end loop;
close liste;
return s/nb;
END $$;
select calcul();

