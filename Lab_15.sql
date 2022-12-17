-- 1.	�������� �������, ������� ��������� ���������, ���� �� ������� ��������� ����.
create table MKVTable
(
    id number primary key,
    name varchar2(20)
);

-- 2.	��������� ������� �������� (10 ��.).
declare
    id number(10) := 1;
    name varchar(20);
begin
    while(id <= 10)
    loop
        name := concat('value_', to_char(id));
        insert into MKVTABLE(id, name) values (id, name);
        id := id + 1;
    end loop;
    commit;
end;

select * from MKVTABLE;

-- 3.	�������� BEFORE � ������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.
-- 4.	���� � ��� ����������� �������� ������ �������� ��������� �� ��������� �������
--(DMS_OUTPUT) �� ����� ����������� ������.
create or replace trigger trig1
    before insert on MKVTABLE
    begin
        DBMS_OUTPUT.PUT_LINE('Before insert trigger1...');
    end;

create or replace trigger trig2
    before update on MKVTABLE
    begin
        DBMS_OUTPUT.PUT_LINE('Before update trigger2...');
    end;

create or replace trigger trig3
    before delete on MKVTABLE
    begin
        DBMS_OUTPUT.PUT_LINE('Before delete trigger3...');
    end;

insert into MKVTABLE values (11, 'value_11');
update MKVTABLE set name='value_111' where id=11;
delete from MKVTABLE where id=11;
commit;

-- 5.	�������� BEFORE-������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
create or replace trigger trig4
    before insert or update or delete on MKVTABLE
    for each row
    begin
         DBMS_OUTPUT.PUT_LINE('Before triggers for each rows...');
    end;

insert into MKVTABLE values (11, 'value_11');
update MKVTABLE set name='New_value' where id<5;
delete from MKVTABLE where id>5;
rollback;

-- 6.	��������� ��������� INSERTING, UPDATING � DELETING.
create or replace trigger trig5
    before insert or update or delete on MKVTABLE
    begin
        if inserting then
        dbms_output.put_line('Before inserting');
        elsif updating then
        dbms_output.put_line('Before updating');
        elsif deleting then
        dbms_output.put_line('Before deleting');
        end if;
    end;

-- 7.	������������ AFTER-�������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.
create or replace trigger trig6
    after insert on MKVTABLE
    begin
        DBMS_OUTPUT.PUT_LINE('After insert trigger6...');
    end;

create or replace trigger trig7
    after update on MKVTABLE
    begin
        DBMS_OUTPUT.PUT_LINE('After update trigger7...');
    end;

create or replace trigger trig8
    after delete on MKVTABLE
    begin
        DBMS_OUTPUT.PUT_LINE('After delete trigger8...');
    end;

insert into MKVTABLE values (11, 'value_11');
update MKVTABLE set name='value_111' where id=11;
delete from MKVTABLE where id=11;
commit;

-- 8.	������������ AFTER-�������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
create or replace trigger trig9
after insert or update or delete on MKVTABLE
for each row
begin
    DBMS_OUTPUT.PUT_LINE('After triggers for each rows...');
end;

-- 9.	�������� ������� � ������ AUDIT. ������� ������ ��������� ����: OperationDate,
-- OperationType (�������� �������, ���������� � ��������),
-- TriggerName(��� ��������),
-- Data (������ � ���������� ����� �� � ����� ��������).
create table AUDIT1
(
    OperationDate date,
    OperationType varchar2(100),
    TriggerName varchar2(100),
    Data varchar2(100)
);
commit;

-- 10.	�������� �������� ����� �������, ����� ��� �������������� ��� �������� � �������� �������� � ������� AUDIT.
create or replace trigger trig10
before insert or update or delete on MKVTable
for each row
    begin
        if inserting then
            insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
            values (sysdate, 'Insert', 'before', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
        elsif updating then
            insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
            values (sysdate, 'Update', 'before', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
        elsif deleting then
            insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
            values (sysdate, 'Delete', 'before', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
        end if;
    end;

create or replace trigger trig11
after insert or update or delete on MKVTable
for each row
    begin
        if inserting then
            insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
            values (sysdate, 'Insert', 'after', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
        elsif updating then
            insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
            values (sysdate, 'Update', 'after', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
        elsif deleting then
            insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
            values (sysdate, 'Delete', 'after', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
        end if;
    end;

select * from Audit1;

-- 11.	��������� ��������, ���������� ����������� ������� �� ���������� �����. ��������, ��������������� �� ������� ��� �������. ��������� ���������.
insert into MKVTABLE values (1, 'value_01');
select * from AUDIT1;

-- 12.	������� (drop) �������� �������. ��������� ���������. �������� �������, ����������� �������� �������� �������.
drop table MKVTable;

create or replace trigger trig12
before drop on schema
begin
   RAISE_APPLICATION_ERROR (-20000, 'Do not drop table ' || ORA_DICT_OBJ_TYPE || ' ' || ORA_DICT_OBJ_NAME);
end;

--alter trigger trigger12 disable;

-- 13.	������� (drop) ������� AUDIT. ����������� ��������� ��������� � ������� SQL-DEVELOPER. ��������� ���������. �������� ��������.
drop table Audit1;
select * from user_triggers;

-- 14.	�������� ������������� ��� �������� ��������. ������������ INSTEADOF INSERT-�������.
--������� ������ ��������� ������ � �������.
create view v1 as select * from MKVTable;
select * from v1;

create or replace trigger trig13
instead of insert on v1
for each row
begin
    if inserting then
        dbms_output.put_line('--- INSTEAD OF TRIGGER ---' || concat('old:'||:old.id||:old.name, ' new:'||:new.id|| ' ' ||:new.name));
        insert into MKVTable values (:new.id, :new.name);
    end if;
end;
commit;

insert into v1(id, name) values (15, 'value_15');
select * from MKVTable;
select * from v1;
rollback;

drop view v1;

-- 15.	�����������������, � ����� ������� ����������� ��������.
select * from Audit1;
