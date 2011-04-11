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
class Snapshot < ActiveRecord::Base
  self.table_name='mc$dr_datafile_snapshot'
end


dr = Snapshot.find(20379)
p dr.id.to_s("F")
