# gem install D:\library\ruby\oci\ruby-oci8-1.0.2-i386-mswin32.gem
# gem install activerecord -y
# gem install activerecord-oracle-adapter --source http://gems.rubyonrails.org

require 'activerecord'
#ActiveRecord::Base.configurations = {
#  'arunit' => {
#    :adapter  => 'mysql',
#    :username => 'rails',
#    :encoding => 'utf8',
#    :database => 'activerecord_unittest',
#  },
#  'arunit2' => {
#    :adapter  => 'mysql',
#    :username => 'rails',
#    :database => 'activerecord_unittest2'
#  }
#}
#ActiveRecord::Base.establish_connection 'arunit'
#Course.establish_connection 'arunit2'


class ColinDb < ActiveRecord::Base
  self.establish_connection(
  :adapter  => "oracle",
  :database => "mc100",
  :username => "colin",
  :password => "colin",
  :host     => "mc100"
  )
  class << self
    def dosql(sql)
      Backupdb.connection.execute(sql)
    end
  end
end
#ActiveRecord::Base.establish_connection(
#  :adapter  => "oracle",
#  :database => "mc32",
#  :username => "colin",
#  :password => "colin",
#  :host     => "mc32"
#)

#Drop Table job_infos;
#Create Table job_infos
#(
#  id       Number primary key,
#  Name          varchar2(512),
#  First_Time    date,
#  status        varchar2(30),
#  log_id        Number
#);
#create sequence job_infos_seq;
#class JobInfo < ActiveRecord::Base
class JobInfo < ColinDb
  self.table_name = "job_infos"
  def test_str
    "self.name : #{name}"
  end
end
#Drop Table log_infos;
#Create Table log_infos
#(
#  id       Number primary key,
#  Name          varchar2(512),
#  create_time    date,
#  status          varchar2(30),
#  applied        varchar2(1),
#  applied_time    date,
#  ana_secs       number
#);
#create sequence log_infos_seq;
#class LogInfo < ActiveRecord::Base
class LogInfo < ColinDb
  self.table_name = "log_infos"
  
end

#ji = JobInfo.new
#ji.name = "jc"
#ji.first_time = Time.now
#ji.status = "A"
#ji.save
#p "new : #{ji}"

#li = LogInfo.new
#li.name = "arc_1_10.dbf"
#li.create_time = Time.now
#li.status = "A"
#li.applied = false
#li.save
ji = JobInfo.find(:first)
p ji
p ji.test_str
p ji.id.to_i
p ji.object_id

ji_1 = JobInfo.find(21)
p ji_1

ji_2 = JobInfo.find_by_name("jc")
p ji_2

ji_3 = JobInfo.find(:all, :conditions => ["name = ?", "jc"])
p ji_3

# delete
#ji_3[0].destroy
#ji_3[0].save

p "ok"
