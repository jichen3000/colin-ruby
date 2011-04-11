#create table jc_test as select * from mc$dr_system
#CREATE SEQUENCE jc_test_seq
#user     system      total        real
#transaction  2.203000   0.188000   2.391000 ( 15.469000)
#insert  2.875000   0.250000   3.125000 ( 26.828000)
#connection  0.125000   0.000000   0.125000 (  7.312000)
#oci8  0.078000   0.031000   0.109000 (  6.088000)

# 10000
#connection  1.859000   0.203000   2.062000 ( 72.562000)
#oci8  1.329000   0.375000   1.704000 ( 68.016000)



require "activerecord"

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "drb",
  :username => "mcdbra",
  :password => "mcdbra",
  :host     => "drb"  
)
class JcTest < ActiveRecord::Base
  self.table_name='jc_test'
  set_primary_key :bs_id
end

require 'benchmark'
def gen_arr(size)
  arr = []
  size.times do |i|
    item = JcTest.new
    item.bs_name='jc'
    item.bs_desc='jc'
    item.bs_type=3
    item.bs_level=3
    item.status='T'
    arr << item
  end
  arr
end

sql = "insert into jc_test (bs_id,bs_name,bs_desc,bs_type,bs_level,status)"+
    " values(jc_test_seq.nextval,'jc','jc',3,3,'T')"
size = 1000
arr1 = gen_arr(size)
arr2 = gen_arr(size)
require 'oci8'
ors = "mcdbra/mcdbra@drb"
conn = OCI8.new(ors)
p conn.autocommit?
#conn.prefetch_rows=1000
def oci_exec(size,conn,sql)
  size.times {|item| conn.exec(sql) }
  conn.commit
end
Benchmark.bm do |x|
#  x.report("transaction") { JcTest.transaction { arr2.each {|item| item.save} } }
#  x.report("insert") { arr1.each {|item| item.save} }
  x.report("connection") { size.times {|item| JcTest.connection.execute(sql) } }
  x.report("oci8") { oci_exec(size,conn,sql) }
end
conn.logoff
JcTest.connection.execute('truncate table jc_test')

p "ok"