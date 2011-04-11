require "activerecord"

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "drb",
  :username => "mcdbra",
  :password => "mcdbra",
  :host     => "drb"  
)
#ActiveRecord::Base.pluralize_table_names = false

class Dyna_test
  def new_table(name,tablename)
    eval %{
      class #{name} < ActiveRecord::Base
       #{name}.table_name="#{tablename}"
      end
    }
  end
  
  def table_show(tablename)
      new_table("QueryTable",tablename)
#      qt = QueryTable.find(:first)
#      puts qt.class
#      p qt.instance_variables
#      p QueryTable.columns
#      p QueryTable.columns_hash
      #p QueryTable.column_names
     qt= QueryTable.find_by_sql("select max(sql_id) as a,owner from mc$sql_result group by owner")
     p qt[0].attributes
     p QueryTable.column_names
     qt.each do |q|
       #p q.columns
       puts q.class
       puts q["owner"]
       puts q["max(sql_id)"]
     end
  end
end

Dyna_test.new.table_show("mc$sql_result")