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
arr = DataFile.find(:all, :conditions=>'sub_id=7')
arr.each {|item| p item.blocks.to_i}
p "end"
mininum = DataFile.minimum('abs(blocks-3841)',:conditions=>'sub_id=7')
p mininum
min_one = DataFile.find(:first, :conditions=>"sub_id=7 and abs(blocks-3841) = #{mininum}")
p min_one
average = DataFile.average('(blocks)',:conditions=>'sub_id=7')
p "average:#{average}"
average = DataFile.average('checkpoint_time-creation_time',:conditions=>'sub_id=7').to_i
p "average:#{average}"
nil_average = DataFile.average('checkpoint_time-creation_time',:conditions=>'sub_id=12345').to_i
p "nil_average:#{nil_average}"
#sum = DataFile.sum(:bytes, :conditions=>'sub_id=7')/1048576
#sum = DataFile.sum('bytes / 1048576', :conditions=>'sub_id=7')
#count = DataFile.count(:conditions=>'sub_id=7')
#count_1 = DataFile.calculate(:count,'sub_id',:conditions=>'sub_id=7')
#p count
#p count_1
#p sum.to_i
p "ok"