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
  def find_max_group(column_name,group_name,inter_condition)
    if not column_name
      raise("Column name must not nil!")
    end
    if not self.column_names.include?(column_name)
      raise("Table not include column (#{column_name})")
    end
    if not group_name
      raise("Group Column name must not nil!")
    end
    if not self.column_names.include?(group_name)
      raise("Table not include group column (#{group_name})")
    end
    if inter_condition
      sub_sql = "select max(#{column_name}) from #{self.table_name} where "+
        "#{inter_condition} group by #{group_name}"
    else
      sub_sql = "select max(#{column_name}) from #{self.table_name} where "+
        "group by #{group_name}"
    end
    all(:conditions => "#{column_name} in (#{sub_sql})")
  end
  def dosql(sql)
    self.connection.execute(sql)
  end
end
class Managerdb < ActiveRecord::Base
  self.establish_connection(
    :adapter  => "oracle_enhanced",
    :encoding => "utf-16",
    :database => "28drb",
    :username => "mcdbra3",
    :password => "mcdbra3",
    :host     => "28drb"
  )
  class << self
    include DbComm
  end
end
class DrSystem < Managerdb
  self.table_name='mc$dr_system'
  set_primary_key :bs_id
#  has_many :subs, :class_name => "DrSubSystem", :foreign_key => "sub_id"
end

class DrSubSystem < Managerdb
  self.table_name='mc$dr_subsystem'
  set_primary_key :sub_id
#  belongs_to :bs_system, :class_name => "DrSystem", :foreign_key => "bs_id"  
end

class DrScnTime < Managerdb
  self.table_name='mc$dr_scn_time'
  #self.primary_key=''
end
#max_sub = DrSubSystem.find(:first, 
#  :conditions => "bs_id=(select max(bs_id) from #{DrSubSystem.table_name})")
#max_sub = DrSubSystem.find_max("sub_id", "stop_order=1")
#max_sub = DrSubSystem.find_max(nil)
#max_sub = DrSubSystem.find_max("lll")
#p max_sub
#p Managerdb.dosql("select * from tab")
arr = DrScnTime.find_max_group("sequence","sub_id","sub_id>1")
arr.each {|x| p x}
p "ok"