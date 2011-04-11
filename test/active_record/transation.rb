require "activerecord"
module DbComm
  def find_max(column_name,inter_condition)
    if not column_name
      raise("Column name must not nil!")
    end
    if not self.column_names.include?(column_name)
      raise("Table not include column (#{column_name})")
    end
    if inter_condition
      sub_sql = "select max(#{column_name}) from #{self.table_name} where "+inter_condition
    else
      sub_sql = "select max(#{column_name}) from #{self.table_name} "
    end
    first(:conditions => "#{column_name}=(#{sub_sql})")
  end
  def dosql(sql)
    self.connection.execute(sql)
  end
end
class Managerdb < ActiveRecord::Base
  self.establish_connection(
    :adapter  => "oracle",
    :encoding => "utf-16",
    :database => "drb",
    :username => "mcdbra",
    :password => "mcdbra",
    :host     => "drb"
  )
  class << self
    include DbComm
  end
end
class JcTest < Managerdb
  self.table_name='jc_test'
  set_primary_key :bs_id
  def before_save
    p "before"
  end
  def after_save
    p "after"
    if self.bs_name == 'jc4'
      raise "Not allow!"
    end
  end
end



#j1=JcTest.new
#j2=JcTest.new
j1 = JcTest.find(50241)
#p j1
j2 = JcTest.find(50242)
#p j2
j1.bs_name = "jc3"
j2.bs_name = "jc4"
#j2.bs_level = 3
#Managerdb.transaction do
  j1.save
  j2.save
#end
p "ok"