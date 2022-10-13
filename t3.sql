SET SQLFORMAT ANSICONSOLE
SET PAGESIZE 0

alter system flush shared_pool;

explain plan for
select /*+ OPT_PARAM('_optimizer_cbqt_or_expansion' 'off') */ null
  from x join y  on y.id = x.id join z on z.id = y.id
  where  ( ( x.a2 = -1 AND z.b10 = 0              ) OR 
           ( x.a2 = 0  AND z.b10 = -1 AND z.c1 = -1  )   );

select * from dbms_xplan.display();

exit;