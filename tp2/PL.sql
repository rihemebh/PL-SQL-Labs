
  --EX1
  CREATE TYPE nuplet AS (
    s           varchar(50) ,
    nombre      Numeric(7,2)
);

CREATE OR REPLACE function listeProd() RETURNS setof nuplet language plpgsql as $$
DECLARE
liste CURSOR for SELECT PRODUCT_NAME,LIST_PRICE  FROM DEMO_PRODUCT_INFO;
pr RECORD;
produit nuplet;
BEGIN
for produit in liste 
loop
return NEXT produit ;
end loop;
END
$$;

select * from listeProd();


--EX2

CREATE OR REPLACE function top5() RETURNS setof nuplet language plpgsql as $$
DECLARE
liste CURSOR for SELECT PRODUCT_NAME,LIST_PRICE  FROM DEMO_PRODUCT_INFO ORDER BY LIST_PRICE  desc;

produit nuplet;
nb INTEGER := 1;
BEGIN
open liste;
fetch liste into produit;

while (FOUND and nb<=5) loop
nb := nb+1;
return NEXT produit ;
fetch liste into produit;
end loop;

close liste;
END
$$;

select * from top5() ;

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