#Create table jctest
#(
#  id          Number primary key,
#  cmd          varchar2(30),  
#  info        BLOB
#);
#create sequence jc_test_seq;

# activerecord 2.0.2 不支持blob类型
# 而且不报错，只是插入的时候没有值
gem 'activerecord', '=2.0.2'
require 'activerecord'
class Managerdb < ActiveRecord::Base
  self.establish_connection(
    :adapter  => "oracle",
    :encoding => "utf-16",
    :database => "drb",
    :username => "mcdbra",
    :password => "mcdbra",
    :host     => "drb"
  )
end

class JcTest < Managerdb
  self.table_name = :jctest
  self.sequence_name = :jc_test_seq
end
#jc = JcTest.new
#jc.cmd = "ls"
#jc.info = 'sldfjlkdsjflkdsjfdskfjldsjkflk'
#jc.save
jcarr = JcTest.find(:all)
p jcarr[0]
p jcarr[1]
p "ok"