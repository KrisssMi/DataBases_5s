show user;
---------------- НЕЯВНЫЕ КУРСОРЫ ---------------------
-- 1.
declare
  fac faculty%rowtype;
begin
  select * into fac from faculty where faculty='ФИТ';
  dbms_output.put_line(fac.faculty||' '|| fac.faculty_name);
end;

-- 2-4.
declare
  fac faculty%rowtype;
begin
  select * into fac from faculty where faculty='ХТиТ';
  dbms_output.put_line(fac.faculty||' '|| fac.faculty_name);
exception
  when no_data_found
    then dbms_output.put_line('Данные не найдены');
  when too_many_rows
    then dbms_output.put_line('В результате несколько строк');
  when others
    then dbms_output.put_line('Code: ' || sqlcode || ', Message: ' || sqlerrm);
end;

-- 5-10.
begin 
  --update auditorium set auditorium = '206-9' where auditorium = '206-1';
  --update auditorium set auditorium = '301-1' where auditorium = '206-1';
  
  --insert into auditorium values ('301-9', '301-9', 90, 'ЛК');
  --insert into auditorium values ('301-9', '301-9', 90, 'ЛК');
  
  --delete from auditorium where auditorium = '301-9';
  --delete from auditorium where auditorium = '301-9';
  
  --rollback;
  
  if sql%found then dbms_output.put('found| '); end if;
  if sql%isopen then dbms_output.put('opened| '); end if;
  if sql%notfound then dbms_output.put('not found| '); end if;
   dbms_output.put_line('Измененных столбцов = '|| sql%rowcount);
  exception
     when others then dbms_output.put_line('error = '||sqlerrm);
end;


---------------- ЯВНЫЕ КУРСОРЫ ---------------------
-- 11.
declare
  cursor curs is select teacher_name,pulpit from teacher;
   m_name      teacher.teacher_name%type;
   m_pulpit    teacher.pulpit%type;
begin
  open curs;
    dbms_output.put_line('rowcount = '||curs%rowcount);
    loop
      fetch curs into m_name,m_pulpit;
      exit when curs%notfound;
      dbms_output.put_line(curs%rowcount||'. '||m_name||'?'||m_pulpit);
    end loop;
    dbms_output.put_line('rowcount = '||curs%rowcount);
    close curs;
  exception
    when others then dbms_output.put_line(sqlerrm);
end;

-- 12.
declare
  cursor curs is select subject,subject_name, pulpit from SUBJECT;
  rec subject%rowtype;
begin
  open curs;
  dbms_output.put_line('rowcount = '|| curs%rowcount);
  fetch curs into rec;
  while curs%found
    loop
      dbms_output.put_line(curs%rowcount||'. '||rec.subject||'?'||rec.subject_name||'?'||rec.pulpit);
      fetch curs into rec;
    end loop;
    dbms_output.put_line('rowcount = ' || curs%rowcount);
  close curs;
end;

-- 13.
declare
  cursor curs is select pulpit.pulpit, teacher.teacher_name
  from pulpit inner join teacher on pulpit.pulpit=teacher.pulpit;
  rec curs%rowtype;
begin
  for rec in curs
    loop
      dbms_output.put_line(curs%rowcount||'. '||rec.teacher_name||'?'||rec.pulpit);
    end loop;
end;

-- 14.
declare 
  cursor curs(cap1 auditorium.auditorium%type,cap2 auditorium.auditorium%type)
    is select auditorium, auditorium_capacity from auditorium where 
    auditorium_capacity >= cap1 and auditorium_capacity <= cap2;
begin
    dbms_output.put_line('Вместимость <20: ');
    for aud in curs(0,20)
      loop dbms_output.put(aud.auditorium||',');end loop;
    dbms_output.put_line(chr(10)||'Вместимость 20-30: ');
    for aud in curs(21,30)
      loop dbms_output.put(aud.auditorium||' '); end loop;    
    dbms_output.put_line(chr(10)||'Вместимость 30-60: ');
    for aud in curs(31,60)
      loop dbms_output.put(aud.auditorium||' '); end loop;   
    dbms_output.put_line(chr(10)||'Вместимость 60-80: ');
    for aud in curs(61,80)
      loop dbms_output.put(aud.auditorium||' '); end loop;  
    dbms_output.put_line(chr(10)||'Вместимость выше 80: ');
    for aud in curs(81,1000)
      loop dbms_output.put(aud.auditorium||' '); end loop;  
end;

-- 15.
variable x refcursor;
declare 
    type teacher_name is ref cursor return teacher%rowtype;
    xcurs teacher_name;
begin
  open xcurs for select * from teacher;
  :x :=xcurs;
end;
--???
print x;

-- 16.
declare
  cursor curs_aud is select auditorium_type,
  cursor (select auditorium from auditorium aum
          where aut.auditorium_type = aum.auditorium_type)
          from auditorium_type aut;
  curs_aum sys_refcursor;
  aut auditorium_type.auditorium_type%type;
  aum auditorium.auditorium%type;
begin
  open curs_aud;
  fetch curs_aud into aut, curs_aum;
  while (curs_aud%found)
    loop
    dbms_output.put_line(''||curs_aud%rowcount||'. '||aut);
      loop
        fetch curs_aum into aum;
        exit when curs_aum%notfound;
        dbms_output.put_line('  '||curs_aum%rowcount||'. '||aum);
      end loop;
      dbms_output.new_line;
      fetch curs_aud into aut,curs_aum;     
    end loop;
  close curs_aud;
end;

-- 17.
declare 
  cursor cur(cap1 auditorium.auditorium%type, cap2 auditorium.auditorium%type)
         is select auditorium, auditorium_capacity from auditorium
         where auditorium_capacity between cap1 and cap2 for update;
  aum auditorium.auditorium%type;
  cap auditorium.auditorium_capacity%type;
begin
   open cur(40,80);
   fetch cur into aum, cap;
   while(cur%found)
    loop
      dbms_output.put(cur%rowcount||'. '||aum||' '||cap||'?');
      cap := cap * 0.9;
      update auditorium
      set auditorium_capacity = cap
      where current of cur;
      dbms_output.put_line(' '||aum||' '||cap);
      fetch cur into aum, cap;
    end loop;
  close cur; 
  rollback;
end;

-- 18.
declare 
  cursor cur(cap1 auditorium.auditorium%type,cap2 auditorium.auditorium%type)
    is select auditorium,auditorium_capacity from auditorium
    where auditorium_capacity between cap1 and cap2 for update;
  aum auditorium.auditorium%type;
  cap auditorium.auditorium_capacity%type;
begin

  dbms_output.put_line('До удаления: ');
  for pp in cur(0,120) 
    loop
      dbms_output.put_line(cur%rowcount|| '. ' || pp.auditorium||' '||pp.auditorium_capacity);
    end loop;
  open cur(0,20);
  fetch cur into aum,cap;
  
  while(cur%found)
    loop
      delete auditorium where current of cur;
      fetch cur into aum,cap;
    end loop;
  close cur;
  dbms_output.put_line('После удаления: ');
  
  for pp in cur(0,120) 
    loop
      dbms_output.put_line(cur%rowcount|| '. ' || pp.auditorium||' '||pp.auditorium_capacity);
    end loop;
    
  rollback;
end;

-- 19.
declare
  cursor cur(capacity auditorium.auditorium%type)
    is select auditorium, auditorium_capacity, rowid
    from auditorium where auditorium_capacity >=capacity for update;
  aum auditorium.auditorium%type;
  cap auditorium.auditorium_capacity%type;
begin
  for xxx in cur(80)
   loop
    if xxx.auditorium_capacity >=80 then 
      update auditorium
      set auditorium_capacity = auditorium_capacity+3 where rowid = xxx.rowid;
    end if;
   end loop;
  for yyy in cur(80)
   loop
    dbms_output.put_line(yyy.auditorium||' '||yyy.auditorium_capacity);
   end loop; 
   rollback;
end;
select * from auditorium;

-- 20.
declare
  cursor cur_teacher is select teacher,teacher_name,pulpit from teacher;
  m_teacher teacher.teacher%type;
  m_teacher_name teacher.teacher_name%type;
  m_pulpit teacher.pulpit%type;
  i integer:=1;
begin
  open cur_teacher;
  loop
    fetch cur_teacher into m_teacher,m_teacher_name,m_pulpit;
    exit when cur_teacher%notfound;
    dbms_output.put_line(cur_teacher%rowcount||'. ' ||m_teacher||'?'
                          ||m_teacher_name||'?'
                          ||m_pulpit);
    if(i mod 3 = 0) then 
      dbms_output.put_line('-------------------------------------------'); 
    end if;
    i:= i + 1;
  end loop;
  dbms_output.put_line('rowcount = ' || cur_teacher%rowcount);
  close cur_teacher;
  exception
    when others then dbms_output.put_line(sqlerrm);
end;


