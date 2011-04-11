# create sequence colin_three_seq; 
require 'active_record'
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "98stream",
  :username => "company",
  :password => "company",
  :host     => "98stream"
)
ActiveRecord::Base.pluralize_table_names = false
class ColinOne < ActiveRecord::Base
end
begin
#  ActiveRecord::Base.connection.execute("select colin_three_seq.currval  from dual")
#  ColinOne.find_by_sql("select colin_three_seq.currval  from dual")
#  ActiveRecord::Base.connection.execute("select colin_one_seq.nextval  from dual")
  seq = ActiveRecord::Base.connection.execute("select colin_one_seq.nextval  from dual").fetch[0].to_i
  p seq
rescue  OCIError => edddd
#  p 
#  if e.code == 8002
#    ActiveRecord::Base.connection.execute("select colin_three_seq.nextval  from dual")
#  else
#    raise e
#  end
end

