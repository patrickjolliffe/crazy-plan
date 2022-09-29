drop table l purge;

create table l nologging 
as 
select rownum id1, 
       rownum id2
from dual 
connect by level <= 10;

alter table l add constraint l_id1 primary key(id1, id2);

exec dbms_stats.gather_table_stats(null, 'l');

drop table t1 purge;

create table t1 nologging
as
select  ROWNUM id,
        MOD(ROWNUM, 5) t1f1
from  dual connect by rownum <= 10;

create index t1_t1f_id1 ON t1 (t1f1, id);

exec dbms_stats.gather_table_stats(null, 't1');

drop table t2 purge;

create table t2 nologging 
as 
select ROWNUM  id, 
        MOD(ROWNUM, 8) t2f1,
        MOD(ROWNUM, 8) t2f2
from    dual
connect by level <= 10000;

alter table t2 add constraint t2_id primary key (id);

create index t2_t2f1_t2f2_id2 on t2(t2f1, t2f2, id);

exec dbms_stats.gather_table_stats(null, 't2')


explain plan for
select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null
  from t1 join l  on l.id1 = t1.id join t2 on t2.id = l.id2
  where  ( ( t1.t1f1 = 0 AND t2.t2f1 = 0)       OR 
           ( t1.t1f1 = 1 AND t2.t2f1 = 14 AND t2.t2f2 = 13  )   );

select * from dbms_xplan.display();
