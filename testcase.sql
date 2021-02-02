drop table l purge;

create table l nologging 
as 
select rownum id, 
       rownum id2
from dual 
connect by level <= 1000;

alter table l add constraint l_id primary key(id);

exec dbms_stats.gather_table_stats(null, 'l');

drop table t1 purge;

create table t1 nologging
as
select  ROWNUM id,
        MOD(ROWNUM, 400) m
from  dual connect by rownum <= 140000;
create index t1_m_id ON t1 (m, id);

exec dbms_stats.gather_table_stats(null, 't1');

drop table t2 purge;

create table t2 nologging 
as 
select ROWNUM  id, 
        MOD(ROWNUM, 10) c1,
        MOD(ROWNUM, 10) c2
from    dual
connect by level <= 10000;

alter table t2 add constraint t2_id primary key (id);

create index t2_c1_c2_id on t2(c1, c2, id);

exec dbms_stats.gather_table_stats(null, 't2')

var v1  NUMBER
var v2  NUMBER

exec :v1 := 999999;
exec :v2 := 999999;

explain plan for SELECT /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null FROM l, t1, t2 WHERE  
(  ( t1.m = :v1 AND t2.c1 BETWEEN 21 AND 22)       OR 
   ( t1.m = :v2 AND t2.c1 = 103 AND t2.c2 = 23  )   )  AND 
    ( l.id = t1.id AND l.id2 = t2.id );

select * from dbms_xplan.display();
