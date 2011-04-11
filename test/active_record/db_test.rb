require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "drb1",
  :username => "mcdbra",
  :password => "mcdbra",
  :host     => "drb1"
)

class TTest < ActiveRecord::Base
  self.table_name = 'MC$DR_SYSTEM'
#  def self.set_table_name(t)
#    p "set_table_name"
#    self.table_name = t
#  end
end


a = TTest.find(:first)
p a

p "ok"
