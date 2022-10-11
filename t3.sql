SET SQLFORMAT ANSICONSOLE
SET PAGESIZE 0

alter system flush shared_pool;

explain plan for
select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null
  from x join y  on y.id = x.id join z on z.id = y.id
  where  ( ( x.a = 0 AND z.b = 1               ) OR 
           ( x.a = 1 AND z.b = 0 AND z.c = 0  )   );

select * from dbms_xplan.display();

exit;