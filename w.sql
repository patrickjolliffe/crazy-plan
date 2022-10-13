
drop table t;
create table t (a number,  b number, c number, d number, padding varchar2(255));
create index i_ac on t(a,c);
create index i_ad on t(a,d);
create index i_bc on t(b,c);
create index i_bd on t(b,d);
insert into t (a, b, c, d, padding)  
select  0,
        0,
        ROWNUM,
        ROWNUM,
        RPAD('X', 255, 'X')
from  dual connect by rownum <= 80000;
commit;
exec dbms_stats.gather_table_stats(null, 't');
explain plan for select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ * from t where (a = 0 and b = 0) or (c=0 and d=0);
select * from table(dbms_xplan.display());

exec dbms_stats.gather_table_stats(null, 't');
explain plan for select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ * from t where (a = 0 and c=0 and d=0) or b = 0 and (c=0 and d=0);
select * from table(dbms_xplan.display());


(A and B) or (C and D)

(A or C) and (B or c) and (A or D) and (B or D)
