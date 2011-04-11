=begin
create table jc_bool(
  id number(9) primary key,
  name varchar2(30),
  is_one  number(1),
  is_two  varchar2(1)
);
=end

require "active_record"

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "xe",
  :username => "colin_test",
  :password => "colin_test",
  :host     => "xe"  
)

class JcBool < ActiveRecord::Base
    
end
ActiveRecord::Base.pluralize_table_names = false
#ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.emulate_booleans_from_strings = true
#ActiveRecord::Base.table_name_prefix = 'mc$ma_'


#j = JcBool.new
#j.id = 1
#j.name = 'j'
#j.is_one = true
#j.is_two = true
#j2 = JcBool.new
#j2.id = 2
#j2.name = '2'
#j2.is_one = false
#j2.is_two = false
#j.save!
#j2.save!
#j = JcBool.find(1)
#j2 = JcBool.find(2)
#p j
#p j2
#arr = JcBool.find(:all, :conditions=>['is_one = ?', true])
arr = JcBool.find(:all, :conditions=>['is_two = ?', true])
p arr
p "ok"
