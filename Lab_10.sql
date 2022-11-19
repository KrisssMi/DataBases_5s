show user;

-- 1.
begin
null;
end;

-- 2.
begin
dbms_output.put_line('Hello World!');
end;

-- 3.
declare 
  x number(3):=3;
  y number(3):=0;
  z number(10,2);
begin
dbms_output.put_line('x= ' || x || ', y= ' || y);
z:=x/y;
dbms_output.put_line('z= '|| z);
exception 
  when others
  then dbms_output.put_line('error = '|| sqlerrm || ', error sqlcode = ' || sqlcode);
end;

-- 4.
declare
    z number(10,2) := 3;
begin
    begin
        z := 5/0;
    exception
        when OTHERS
        then dbms_output.put_line('ERROR SQLCODE = ' || sqlcode || chr(10) || 'ERROR MESSAGE = ' || sqlerrm);
    end;
    dbms_output.put_line('z = '||z);
end;

-- 5.
show parameter plsql_warnings;
select name, value from v$parameter where name = 'plsql_warnings';

-- 6.
select keyword from v$reserved_words where length=1 and keyword !='A';

-- 7.
select keyword from v$reserved_words where length>1 and keyword !='A' order by keyword;

-- 8.
select name,value from v$parameter where name like 'plsql%';
show parameter plsql;

-- 9-10.
declare 
  n1 number(3):=10;
  n2 number(10):=123;
  n3 number(10):=10000;
begin
  dbms_output.put_line('n1 = '|| n1);
  dbms_output.put_line('n2 = '|| n2);
  dbms_output.put_line('n3 = '|| n3);
end;

-- 11.
declare 
  x number(5):=500;
  y number(5):=100;
  
  s number(3);
  r number(3);
  d number(3);
  dw number(3);
  u number (6);
begin
  s:=x+y;
  r:=x-y;
  u:=x*y;
  d:=x/y;
  dw:=mod(x,y);
  dbms_output.put_line('Сумма = '|| s);
  dbms_output.put_line('Разность = '|| r);
  dbms_output.put_line('Деление = '|| d);
  dbms_output.put_line('Умножение = '|| u);
  dbms_output.put_line('Деление с остатком = '|| dw);
end;

-- 12.
declare
  d number (5, 2);
  d1 number (3,2) := 2.33;
  d2 number(5,4):=5.6732;
begin
  d:=567.66;
  dbms_output.put_line('d = '|| d);
  dbms_output.put_line('d1 = '|| d1);
  dbms_output.put_line('d2 = '|| d2);
end;

-- 13.
declare
  d number (5, -2);
  d1 number (3,-2) := 250;
  d2 number(4,-3):=5556;
begin
  d:=567;
  dbms_output.put_line('d = '|| d);
  dbms_output.put_line('d1 = '|| d1);
  dbms_output.put_line('d2 = '|| d2);
end;

-- 14-15.
declare 
  n1 binary_float:=12345.6789;
  n2 binary_double:=123456.789;
begin
  dbms_output.put_line('n1 = ' || n1);
  dbms_output.put_line('n2 = ' || n2);
end;

-- 16.
declare 
  n1 number:=123E-2;
  n2 number:=123E+5;
begin
  dbms_output.put_line('n1 = ' || n1);
  dbms_output.put_line('n2 = ' || n2);
end;
  
-- 17.
declare 
  boot boolean:= true;
  boof boolean:= false;
  boo boolean;
begin
  if boot then dbms_output.put_line('boot = '|| 'true'); end if;
  if not boof then dbms_output.put_line('boof = '|| 'false'); end if;
  if boo is null then dbms_output.put_line('boo = '|| 'null'); end if;
end;

-- 18.
declare
    n constant number(5) := 9;
    v constant varchar2(8) := '2 hello';
    c constant char(6) := 'c bye';
begin
    dbms_output.put_line('const n = '|| n);
    dbms_output.put_line('const n + n = '||(n+n)); 
    dbms_output.put_line('const n - 5 = '||(n-5)); 
    dbms_output.put_line('const n * 5 = '||(n*5)); 
    dbms_output.put_line('const n / 3 = '||(n/3)); 
    dbms_output.put_line('const v = '|| v);
    dbms_output.put_line('const c = '|| c);
    --n := 10;
    exception 
        when others
        then dbms_output.put_line('error = '|| sqlerrm);
end;

-- 19.
declare
  pulp pulpit.pulpit%TYPE;
begin 
  pulp := 'ПОИТ';
  dbms_output.put_line(pulp);
end;

-- 20.
declare
  faculty_res faculty%ROWTYPE;
begin 
  faculty_res.faculty := 'ФИТ';
  faculty_res.faculty_name := 'Факультет информационных технологий';
  dbms_output.put_line(faculty_res.faculty);
end;

-- 21.
declare 
  x PLS_INTEGER := 16;
begin
  if 5 > x then
    dbms_output.put_line('5 > '|| x);
  elsif 5 < x then
    dbms_output.put_line('5 < '|| x);
  else
    dbms_output.put_line('5 = '|| x);
  end if;
end;

-- 23.
declare 
  x pls_integer:=20;
begin
case
  when 10>x then dbms_output.put_line('10> '|| x);
  when 10=x then dbms_output.put_line('10= ' || x);
  when 15=x then dbms_output.put_line('15= ' || x);
  when x between 16 and 25 then dbms_output.put_line('16<=' || x || '<=25');
  else dbms_output.put_line('else');
  end case;
end;

-- 24.
declare
    x pls_integer :=0;
begin
  dbms_output.put_line('------- 24 -------');
    loop x:=x+1;
        dbms_output.put_line(x);
        exit when x>5;
    end loop;
    
-- 25.
  dbms_output.put_line('------- 25 -------');
    for k in 1..5
        loop dbms_output.put_line(k); 
    end loop;
    
-- 26.
  dbms_output.put_line('------- 26 -------');
    while (x>0) 
        loop x:=x-1;
      dbms_output.put_line(x);
    end loop;
end;
