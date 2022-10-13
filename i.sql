drop table x purge;

create table x (id number, a2 number, constraint x_id primary key(id));

insert into x (id, a2) 
select  ROWNUM,
        mod(ROWNUM, 2)
from  dual connect by rownum <= 10;

create index x_a2_id ON x (a2, id);

exec dbms_stats.gather_table_stats(null, 'x');

drop table y purge;

create table y (id number, constraint y_id primary key(id));

insert into y (id) 
select rownum
from dual 
connect by level <= 8;


exec dbms_stats.gather_table_stats(null, 'y');

drop table z purge;

create table z (id number, b10 number, c1 number, constraint z_id primary key(id));

insert into z (id, b10, c1) 
select ROWNUM,
       MOD(ROWNUM, 10),
       0
from    dual
connect by level <= 10000;

create index z_b10_c1 on z(b10, c1, id);

exec dbms_stats.gather_table_stats(null, 'z');

exit;