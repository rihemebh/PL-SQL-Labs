--EX1--
CREATE OR REPLACE function nbParts() RETURNS INTEGER language plpgsql as $$
DECLARE
n INTEGER;
BEGIN 
Select count(*) INTO n from parts;

if(n>6) then
	raise exception 'Exception : % > 6',n;
end if;
return n;
END
$$;

select nbParts();
--EX2--
CREATE OR REPLACE function propMgr() RETURNS DECIMAL language plpgsql as $$
DECLARE
n INTEGER;
b INTEGER;
p decimal;
BEGIN 
select COUNT(*) into n from emp;
select COUNT(*) into b from emp where job = 'MANAGER';
p = b*100/n;

return p;
exception when division_by_zero then return 0.0;
END
$$;
 
select propMgr();

--EX3--
CREATE OR REPLACE function cat() RETURNS setof varchar language plpgsql as $$
DECLARE 
liste CURSOR for SELECT tablename FROM pg_tables where tableowner='root';
tablename RECORD ;
BEGIN

for tablename in liste 
loop 
return NEXT tablename.tablename ;
end loop;

END 
$$;

select * from cat();

--EX4 

CREATE OR REPLACE procedure aug1000(num INT) language plpgsql  AS $$
DECLARE 
employee cursor for select * from emp where deptno= num AND sal >= 1500 ;
empl emp%rowtype;
salaire emp.sal%type;
BEGIN 

select Max(sal) into salaire from emp;

for empl in employee 
loop
if (empl.sal+1000 > salaire ) then 
raise exception 'salaire superieur a %', salaire;
end if;
update emp
set sal = sal + 1000
where emp.empno=empl.empno;
end loop;

END 
$$;

caLL aug1000(20);
select * from emp where deptno =20;