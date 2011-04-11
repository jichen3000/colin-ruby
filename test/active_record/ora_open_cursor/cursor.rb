require 'conn'
sql = <<END_SQL
select t2.* from v$session t1,v$open_cursor t2
where t1.sid=t2.sid and  t1.status='ACTIVE'
and (t2.USER_NAME='MCBACKUP' OR t2.USER_NAME='MCDBRA')
order by t1.sid
END_SQL

ocs = VOpenCursor.find_by_sql(sql)
ocs.each {|oc| p oc}
p "ok"