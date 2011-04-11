/* the following hex conversion code is from Tom Kyte */
create or replace function to_base( p_dec in number, p_base in number ) 
return varchar2
is
	l_str	varchar2(255) default NULL;
	l_num	number	default p_dec;
	l_hex	varchar2(16) default '0123456789ABCDEF';
begin
	if ( trunc(p_dec) <> p_dec OR p_dec < 0 ) then
		raise PROGRAM_ERROR;
	end if;
	loop
		l_str := substr( l_hex, mod(l_num,p_base)+1, 1 ) || l_str;
		l_num := trunc( l_num/p_base );
		exit when ( l_num = 0 );
	end loop;
	return l_str;
end to_base;
/


create or replace function to_dec
( p_str in varchar2, 
  p_from_base in number default 16 ) return number
is
	l_num   number default 0;
	l_hex   varchar2(16) default '0123456789ABCDEF';
begin
	for i in 1 .. length(p_str) loop
		l_num := l_num * p_from_base + instr(l_hex,upper(substr(p_str,i,1)))-1;
	end loop;
	return l_num;
end to_dec;
/
show errors

create or replace function to_hex( p_dec in number ) return varchar2
is
begin
	return to_base( p_dec, 16 );
end to_hex;
/
create or replace function to_bin( p_dec in number ) return varchar2
is
begin
	return to_base( p_dec, 2 );
end to_bin;
/
create or replace function to_oct( p_dec in number ) return varchar2
is
begin
	return to_base( p_dec, 8 );
end to_oct;
/


/*

     Script:         xksuse.sql
     Author:         Kyle Hailey
     Dated:          June 2002
     Purpose:        create defines for xksuse.c
     copyright (c) 2002 Kyle Hailey
*/

set pagesize 0
set verify off
set feedback off

spool xksuse.h

select '#define SGA_BASE   0x'||addr from x$ksmmem where rownum < 2;
select '#define START  0x' || min(addr) from  x$ksusecst ;
select '#define PROCESSES   '||to_char(value - 1) from v$parameter where name='processes' ;
select '#define STATS   '||count(*)  from x$ksusd ;

select '#define NEXT  '|| 
       ((to_dec(e.addr)-to_dec(s.addr)))   
from (select addr from x$ksusecst where rownum < 2) s, 
     (select max(addr) addr from x$ksusecst where rownum < 3) e ;

select '#define '||
       replace(c.kqfconam,'#','_NUM') ||' '||
       to_char(c.kqfcooff  - mod(c.kqfcooff,2)) ||
        '     /* offset '||  c.kqfcooff || '  size ' || c.kqfcosiz || ' */ '
from
       x$kqfco c,
       x$kqfta t
where
       t.indx = c.kqfcotab
   and ( t.kqftanam='X$KSUSECST' or t.kqftanam='X$KSUSE' or  t.kqftanam='X$KSUSESTA')
   and kqfcooff > 0
order by
     c.kqfcooff
/

select '#define '||
       upper(translate(s.name,' :-()/*''','________'))||' '||
       to_char(c.kqfcooff  - mod(c.kqfcooff,2)+ STATISTIC# * 4 )
from
       x$kqfco c,
       x$kqfta t,
       v$statname s
where
       t.indx = c.kqfcotab
   and ( t.kqftanam='X$KSUSESTA' ) and c.kqfconam='KSUSESTV'
   and kqfcooff > 0
order by
     c.kqfcooff
/


select 'char latch[][100]={' from dual;
select '"'||name||'",' from v$latchname;
select ' "" };' from dual;

select 'char event[][100]={' from dual;
select '"'||name||'",' from v$event_name;
select ' "" };' from dual;

select 'int users[]={' from dual;
select '0x'||addr||',' from x$ksuse;
select  '0x0};' from dual;

spool off


exit
