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

class DrSubSystem < ActiveRecord::Base
  self.table_name='mc$dr_subsystem'
  set_primary_key :sub_id
#  belongs_to :bs_system, :class_name => "DrSystem", :foreign_key => "bs_id"  
end

dr = DrSystem.find(2)
subs = DrSubSystem.find(:all, :conditions => "bs_id=#{dr.bs_id}")
#base_config = DrBaseConfig.find(:first, :conditions => "bs_id=#{bs_id} and sub_id=#{sub_id} and "+
# " subcompoent_id=#{subcompoent_id} and compoent_type='#{subsystem_compoent.subcompoent_type}'")

p dr
p subs
p subs.size
p "ok"
