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

create table t1 (id number, t1f1 number);

insert into t1 (id, t1f1) 
select  ROWNUM id,
        mod(ROWNUM, 2) t1f1
from  dual connect by rownum <= 10;

create index t1f1_id ON t1 (t1f1, id);

exec dbms_stats.gather_table_stats(null, 't1');

drop table t2 purge;

create table t2 nologging 
as 
select ROWNUM  id, 
        MOD(ROWNUM, 8) t2f1,
        0 t2f2
from    dual
connect by level <= 10000;

alter table t2 add constraint t2_pk primary key (id);

create index t2f1_t2f2_id2 on t2(t2f1, t2f2, id);

exec dbms_stats.gather_table_stats(null, 't2');

explain plan for
select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null
  from t1 join l  on t1.id = l.id join t2 on t2.id = l.id
  where  ( ( t1.t1f1 = 99 AND t2.t2f1 = 0                    ) OR 
           ( t1.t1f1 =  0 AND t2.t2f1 = 99 AND t2.t2f2 = 99  )   );

select * from dbms_xplan.display();

exit;