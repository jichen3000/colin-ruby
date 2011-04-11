p "start"
require "activerecord"

ActiveRecord::Base.establish_connection(
#  :adapter  => "oracle",
#  :database => "mc32",
#  :username => "colin",
#  :password => "colin",
#  :host     => "mc32"  
  :adapter  => "oracle_enhanced",
  :database => "mcdbra",
  :username => "mcdrb",
  :password => "mcdrb",
  :host     => "mcdbra"  
)


class DrSystemComponents < ActiveRecord::Base
  self.table_name="mc$dr_subsystem_components"
end
#DrSystemComponents.find(:all,:conditions=>"ip_address ='#{@local_ip}' and subcompoent_type='#{subcompoent_type}'")
p DrSystemComponents.find(:all)
