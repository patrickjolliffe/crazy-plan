drop table l purge;

create table l nologging 
as 
select rownum lid, 
       rownum lc1
from dual 
connect by level <= 10;

alter table l add constraint l_lid primary key(lid);

exec dbms_stats.gather_table_stats(null, 'l');

drop table t1 purge;

create table t1 nologging
as
select  ROWNUM t1id,
        MOD(ROWNUM, 5) t1m
from  dual connect by rownum <= 10;
create index t1_t1m_t1id ON t1 (t1m, t1id);

exec dbms_stats.gather_table_stats(null, 't1');

drop table t2 purge;

create table t2 nologging 
as 
select ROWNUM  t2id, 
        MOD(ROWNUM, 8) t2c1,
        MOD(ROWNUM, 8) t2c2
from    dual
connect by level <= 10000;

alter table t2 add constraint t2_t2id primary key (t2id);

create index t2_t2c1_t2c2_t2id on t2(t2c1, t2c2, t2id);

exec dbms_stats.gather_table_stats(null, 't2')

explain plan for SELECT /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null FROM l, t1, t2 WHERE  
(  ( t1.t1m = 0 AND t2.t2c1 BETWEEN 9 AND 10)       OR 
   ( t1.t1m = 1 AND t2.t2c1 = 14 AND t2.t2c2 = 13  )   )  AND 
    ( l.lid = t1.t1id AND l.lc1 = t2.t2id );

select * from dbms_xplan.display();
