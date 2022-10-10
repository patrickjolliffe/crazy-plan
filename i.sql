SET SQLFORMAT ANSICONSOLE
SET PAGESIZE 0

alter system flush shared_pool;

drop table l purge;

create table l nologging 
as 
select rownum id 
from dual 
connect by level <= 8;

alter table l add constraint l_pk primary key(id);

exec dbms_stats.gather_table_stats(null, 'l');

drop table t1 purge;

create table t1 (id number, x number);

insert into t1 (id, x) 
select  ROWNUM,
        mod(ROWNUM, 2) 
from  dual connect by rownum <= 10;

create index x_id ON t1 (x, id);

exec dbms_stats.gather_table_stats(null, 't1');

drop table t2 purge;

create table t2 nologging 
as 
select ROWNUM  id, 
        MOD(ROWNUM, 8) y,
        0 z
from    dual
connect by level <= 10000;

alter table t2 add constraint t2_pk primary key (id);

create index y_z on t2(y, z, id);

exec dbms_stats.gather_table_stats(null, 't2');

exit;