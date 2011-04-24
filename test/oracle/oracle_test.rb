#select file#,rfile#,name from v$datafile where (file#,rfile#) in ((3,17),(1,1)) order by file#,rfile#

require 'oci8'
ors = "mcdbra/mcdbra@drb"
#ors = "mc_backup/mc_dbra@mc32"
#ors = ""
ors = ARGV[0] if ARGV.size > 0
puts "ors : #{ors}"
conn = OCI8.new(ors)
##conn = OCI8.new("gar", "gar")
conn.exec('select * from tab') do |line|
#  puts line.class
  puts line.join("\t")
end
#cursor = conn.exec('select file#,rfile#,name from v$datafile order by file#,rfile#')
#while line = cursor.fetch() do
##  puts line.class
#  puts line.join("\t")
#end
#cursor.close
conn.logoff

#conn = OCI8.new('ccc/ccc@mcsvr')
#cursor = conn.exec("select status from v$log where status='ACTIVE'")
#cursor = conn.exec("select * from v$log ")
#line = cursor.fetch()
#if line and line.size > 0 
#	puts 'wait'
#end
#cursor.close
#conn.logoff
puts 'ok'
