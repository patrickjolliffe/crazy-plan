SET SQLFORMAT ANSICONSOLE
SET PAGESIZE 0

alter system flush shared_pool;

drop table l purge;

create table l nologging 
as 
select rownum id 
from dual 
connect by level <= 10;

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

create index y_z_id on t2(y, z, id);

exec dbms_stats.gather_table_stats(null, 't2');

explain plan for
select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null
  from t1 join l  on t1.id = l.id join t2 on t2.id = l.id
  where  ( ( t1.x = 999 AND t2.y = 2                    ) OR 
           ( t1.x =   1 AND t2.y = 999 AND t2.z = 3  )   );

select * from dbms_xplan.display();

exit;