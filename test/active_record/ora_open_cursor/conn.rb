require "activerecord"
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "drb",
  :username => "mcdbra",
  :password => "mcdbra",
  :host     => "drb"  
)
class DrSystem < ActiveRecord::Base
  self.table_name='mc$dr_system'
  set_primary_key :bs_id
#  has_many :subs, :class_name => "DrSubSystem", :foreign_key => "sub_id"
end
#select t2.* from v$session t1,v$open_cursor t2
#where t1.sid=t2.sid
#and  t1.status='ACTIVE'
#and 
#(t2.USER_NAME='MCBACKUP' OR t2.USER_NAME='MCDBRA')
#order by t1.sid
class VSession < ActiveRecord::Base
  self.table_name = 'v$session'
end
class VOpenCursor < ActiveRecord::Base
  self.table_name = 'v$open_cursor'
end