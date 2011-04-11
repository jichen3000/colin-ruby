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

class DataFile < Managerdb
  self.table_name = 'mc$dr_datafile'
end

#sum = DataFile.sum(:bytes, :conditions=>'sub_id=7')/1048576
dfs = DataFile.find(:all, :conditions=>'sub_id=7')
p dfs.first.checkpoint_time
p dfs.last.checkpoint_time
p dfs.last.checkpoint_time - dfs.first.checkpoint_time
p "ok"