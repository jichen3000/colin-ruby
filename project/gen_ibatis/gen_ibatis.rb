# 生成ibatis3的mapper xml
# 规则：生成对应类的mapper xml文件，其中只有有限的常用的方法。
# 命名：java_class_name+MapperBase
# 包含的方法：
#   selectById, input: int id, output: one object
#   selectListIdDesc, input: null, output: object list oder by id desc
#   insert, input: object, output: saved object
#   update, input: object, output: saved object
#   delete, input: object, output: null
class GenIbatisMapper
  SUFFIX='MapperBase'
  TWO = '  '
  def self.perform(table_name,java_class_name)
    GeningTable.table_name = table_name
    GeningTable.columns.each do |column|
      str =  "#{column.name} type:#{column.sql_type}"
      str += " is primary key" if column.primary
      p str
      p column
    end
#    p GeningTable.columns
  end
  def gen_java(java_class_name,columns)
    package_names = java_class_name.split(".")
    class_name = packet_names.pop
    
  end
  private 
  def gen_java_package(package_names)
    "packeage "+package_names.join('.')+";"
  end
  def gen_java_class(class_name,columns,indent='')
    str_arr = []
    str_arr << indent+"public class "+class_name+" {"
    columns.each do |column|
      str_arr = str_arr | gen_java_property(column,indent+TWO)
    end  
    str_arr << indent+"}"
  end
  def gen_java_property(column,indent=TWO)
    str_arr = []
    str_arr << indent+'private '
  end
  def get_java_type(sql_type)
    case column.sql_type
    when 'DATE'
      ''
    end
  end
end

require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "109stream",
  :username => "strmadmin",
  :password => "strmadmin"
)

class GeningTable < ActiveRecord::Base
#  self.table_name = 'mc$dr_registerfile'
end

GenIbatisMapper.perform('mc$dr_registerfile','')
p "ok"