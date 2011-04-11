require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter => "oracle_enhanced",
  :database => "109stream",
  :username => "strmadmin",
  :password => "strmadmin"
)

class GenTable < ActiveRecord::Base
  def self.gen_column(table_name)
    puts "table name: #{table_name}"
    self.table_name = table_name
    self.columns.each_with_index do |column,index|
      aname = column.name.split("_").each_with_index{|x,i| x.capitalize! if i>0}.join("")
      str = "#{column.name} as #{aname}"
      str+="," if index+1<self.columns.size
      puts str
    end
  end
end

GenTable.gen_column("mc$dr_registerfile")
puts "ok"

