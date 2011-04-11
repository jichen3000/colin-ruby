# 测试使用oracle的update for来进行并发控制

require 'activerecord'
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "28drb",
  :username => "mcdbra3",
  :password => "mcdbra3"
#  :host     => "mc32"  
)
$table_name = :test_updatefor
class TestTableService < ActiveRecord::Migration
  def self.up
    create_table $table_name do |t|
      t.column :name, :string, :limit => 30
      t.column :create_on, :datetime
      t.column :is_used, :boolean
      t.column :other, :clob
    end 
    10.times do |i|
       t = TestTable.new
       t.name = 'mm'+i.to_s
       t.create_on=Time.now
       t.is_used=false
       t.other = '11111111'
       t.save
    end   
  end
  def self.down
    drop_table $table_name
  end
end
class TestTable < ActiveRecord::Base
  self.table_name=$table_name
end

TestTableService.up
#TestTableService.down

def get_one
  
end
p "ok"