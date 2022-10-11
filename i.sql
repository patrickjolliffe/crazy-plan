drop table a purge;

create table a (id number, m2 number);

insert into a (id, m2) 
select  ROWNUM,
        mod(ROWNUM, 2) + 1
from  dual connect by rownum <= 10;

create index x2_id ON a (m2, id);

exec dbms_stats.gather_table_stats(null, 'a');

drop table b purge;

create table b (id number not null);

insert into b (id) 
select rownum
from dual 
connect by level <= 8;

alter table b add constraint l_pk primary key(id);

exec dbms_stats.gather_table_stats(null, 'b');

drop table c purge;

create table c (id number, m10 number, m1 number);

insert into c (id, m10, m1) 
select ROWNUM,
       MOD(ROWNUM, 10)+1,
       1
from    dual
connect by level <= 10000;

alter table c add constraint t2_pk primary key (id);

create index y10_z1 on c(m10, m1, id);

exec dbms_stats.gather_table_stats(null, 'c');

exit;