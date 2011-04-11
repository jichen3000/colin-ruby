# mc$dr_system
# BS_ID NUMBER  Yes   8    
# BS_NAME VARCHAR2(30 BYTE) Yes   2 
# 
# mc$dr_subsystem
# SUB_ID  NUMBER  No    1 1 
# SUB_BS_NAME VARCHAR2(30 BYTE) Yes   2  
# BS_ID NUMBER  Yes   8    

require "activerecord"

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "drb",
  :username => "mcdbra",
  :password => "mcdbra",
  :host     => "drb"  
)
ActiveRecord::Base.pluralize_table_names = false
class DrSystem < ActiveRecord::Base
  self.table_name='mc$dr_system'
  set_primary_key :bs_id
  has_many :subs, :class_name => "DrSubSystem", :foreign_key => "sub_id"
end

class DrSubSystem < ActiveRecord::Base
  self.table_name='mc$dr_subsystem'
  set_primary_key :sub_id
  belongs_to :bs_system, :class_name => "DrSystem", :foreign_key => "bs_id"  
end

dr = DrSystem.find(1)
p dr
p dr.subs