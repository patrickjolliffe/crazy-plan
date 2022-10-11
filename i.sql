drop table l purge;


create table l (id number not null);

insert into l (id) 
select rownum
from dual 
connect by level <= 8;

alter table l add constraint l_pk primary key(id);

exec dbms_stats.gather_table_stats(null, 'l');

drop table t1 purge;

create table t1 (id number, x2 number);

insert into t1 (id, x2) 
select  ROWNUM,
        mod(ROWNUM, 2) + 1
from  dual connect by rownum <= 10;

create index x2_id ON t1 (x2, id);

exec dbms_stats.gather_table_stats(null, 't1');

drop table t2 purge;

create table t2 (id number, y10 number, z1 number);

insert into t2 (id, y10, z1) 
select ROWNUM,
       MOD(ROWNUM, 10)+1,
       1
from    dual
connect by level <= 10000;

alter table t2 add constraint t2_pk primary key (id);

create index y10_z1 on t2(y10, z1, id);

exec dbms_stats.gather_table_stats(null, 't2');

exit;