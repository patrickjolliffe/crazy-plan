SET SQLFORMAT ANSICONSOLE
SET PAGESIZE 0

alter system flush shared_pool;

explain plan for
select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null
  from a join b  on a.id = b.id join c on c.id = b.id
  where  ( ( a.m2 = 0 AND c.m10 = 1               ) OR 
           ( a.m2 = 1 AND c.m10 = 0 AND c.m1 = 0  )   );

select * from dbms_xplan.display();

exit;