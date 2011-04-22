require 'thread'
require 'active_record'
require 'oci8'
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "megatrust",
  :username => "colin_dev",
  :password => "colin_dev"
)
class Indicator < ActiveRecord::Base
  self.table_name='mc$ma_indicator'
end


indicator = Indicator.new()
indicator.source_id = 11
indicator.source_type = 'mm'
indicator.save
p indicator
p "ok"  
