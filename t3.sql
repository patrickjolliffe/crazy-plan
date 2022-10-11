SET SQLFORMAT ANSICONSOLE
SET PAGESIZE 0

alter system flush shared_pool;

explain plan for
select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null
  from t1 join l  on t1.id = l.id join t2 on t2.id = l.id
  where  ( ( t1.x = 0 AND t2.y = 1               ) OR 
           ( t1.x = 1 AND t2.y = 0 AND t2.z = 0  )   );

select * from dbms_xplan.display();

exit;