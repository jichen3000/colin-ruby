require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "100sadmin",
  :username => "strmadmin",
  :password => "strmadmin"
)

ActiveRecord::Base.pluralize_table_names = false
class JcTest < ActiveRecord::Base
  
end

j1 = JcTest.new
j1.name = "jc"
p j1
j1.save
p j1
p "ok"
