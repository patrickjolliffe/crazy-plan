drop table x purge;

create table x (id number, a number, constraint x_id primary key(id));

insert into x (id, a) 
select  ROWNUM,
        mod(ROWNUM, 2) + 1
from  dual connect by rownum <= 10;

create index x_a_id ON x (a, id);

exec dbms_stats.gather_table_stats(null, 'x');

drop table y purge;

create table y (id number, constraint y_id primary key(id));

insert into y (id) 
select rownum
from dual 
connect by level <= 8;


exec dbms_stats.gather_table_stats(null, 'y');

drop table z purge;

create table z (id number, b number, c number, constraint z_id primary key(id));

insert into z (id, b, c) 
select ROWNUM,
       MOD(ROWNUM, 10)+1,
       1
from    dual
connect by level <= 10000;

create index z_b_c on z(b, c, id);

exec dbms_stats.gather_table_stats(null, 'z');

exit;