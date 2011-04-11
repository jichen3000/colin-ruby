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
