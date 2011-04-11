p "start"
require "activerecord"

ActiveRecord::Base.establish_connection(
#  :adapter  => "oracle",
#  :database => "mc32",
#  :username => "colin",
#  :password => "colin",
#  :host     => "mc32"  
  :adapter  => "oracle",
  :database => "colin",
  :username => "colin",
  :password => "colin",
  :host     => "colin-book"  
)


#Drop Table job_infos;
#Create Table job_infos
#(
#  id       Number primary key,
#  Name          varchar2(512),
#  First_Time    date,
#  status        varchar2(30)
#);
#create sequence job_infos_seq;
class JobInfo < ActiveRecord::Base
#  has_many :log_infos, :foreign_key => "job_id"
  has_many :log_infos
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
#  ana_secs       number,
#  job_info_id    number
#);
#create sequence log_infos_seq;
class LogInfo < ActiveRecord::Base
#  belongs_to :parent, :class_name => "JobInfo", :foreign_key => "job_id"
#  belongs_to :job_info, :foreign_key => "job_id"
  belongs_to :job_info
  def before_save
    p "before LogInfo save!!"
  end
  def after_save
    p "after LogInfo save!!!"
  end  
  before_destroy :pdes
  def pdes
    p "before LogInfo destroy!"
  end
end

class OraLogInfo < LogInfo
  self.table_name = 'log_infos'
  def before_save
#    super.before_save
    p "before OraLogInfo save!!!"
  end  
  def after_save
    p "after OraLogInfo save!!!"
#    super.after_save
  end  
  before_destroy :ora_pdes, :ora_pdes2
  def ora_pdes
    p "before OraLogInfo destroy!"
  end
  def ora_pdes2
    p "before OraLogInfo destroy22222!"
  end
  cattr_accessor :full_name, :create_time
  def after_find
    self.full_name = self.name+self.id.to_s
    p "OraLogInfo after_find!"
  end
  def after_initialize
    self.create_time = Time.now
    p "OraLogInfo after_initialize!"
  end
  def before_create
    p "OraLogInfo before_create!"
  end
  def after_create
    p "OraLogInfo after_create!"
  end
  def before_update
    p "OraLogInfo before_update!"
  end
  def after_update
    p "OraLogInfo after_update!"
  end
  def before_validation
    p "OraLogInfo before_validation!"
  end
  def after_validation
    p "OraLogInfo after_validation!"
  end
  def before_validation_on_create
    p "OraLogInfo before_validation_on_create!"
  end
  def after_validation_on_create
    p "OraLogInfo after_validation_on_create!"
  end
  def before_validation_on_update
    p "OraLogInfo before_validation_on_update!"
  end
  def after_validation_on_update
    p "OraLogInfo after_validation_on_update!"
  end
  
    
end

p "ok"