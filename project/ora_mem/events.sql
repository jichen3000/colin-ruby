-- events.sql 
set head off
set pagesize 9999
set feedback off
spool events.h 
select 'char event[][100]={' from dual; 
select '"'||name||'",' from v$event_name; 
select ' "" };' from dual; 

--
select '#define SGA_BASE 0x80000000' from dual; 

--Find the start ADDR of KSUSECST (V$SESSION_WAIT)  
select '#define KSUSECST_ADDR 0x'||addr from x$ksusecst where rownum < 2; 
 
-- Find the Number of Records in the structure
select '#define SESSIONS '||count(*) from x$ksusecst; 
 
-- create function to_dec 
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
end; 
/

-- Find size  in bytes of a row  in KSUSECST  
select '#define RECORD_SZ '||((to_dec(e.addr)-to_dec(s.addr)))
from   (select addr from x$ksusecst where rownum < 2) s, 
(select max(addr) addr from x$ksusecst where rownum < 3) e; 
 
--Get offset of all fields 
select '#define '||c.kqfconam field_name, c.kqfcooff offset  
from x$kqfco c,x$kqfta t 
where t.indx = c.kqfcotab and t.kqftanam='X$KSUSECST' 
--and c.kqfconam in ('KSUSSSEQ','KSUSSOPC','KSUSSP1R','KSUSSP2R','KSUSSP3R','KSUSSTIM')
order by offset; 

spool off 
exit;