require 'base_conn'
class CreateUsersTable < ActiveRecord::Migration
  def self.up
#    create_table :job_infos, :force =>false do |t|
#      t.column :name, :string, :limit=>512
#      t.column :first_time, :datetime
#      t.column :status, :string, :limit=>60
#      t.column :applied, :boolean, :default=>0
#    end
#    # 会自动的增加一个id字段，同时也会自动生成seq。
#    create_table :log_infos, :force =>false do |t|
#      t.column :name, :string, :limit=>512
#      t.column :create_time, :datetime
#      t.column :status, :string, :limit=>60
#      t.column :applied, :boolean, :default=>0
#      t.column :applied_time, :datetime
#      t.column :ana_secs, :number
#      t.column :job_info_id, :integer
#    end
    create_table :table_test1, :force=>true, :primary_key=>"test_id" do |t|
      t.column :name, :string, :limit=>512
    end
    # 通过下面的方式，可以修改id字段的类型。
    # 现在还没有找出如何生成seqence的办法。
#    create_table :table_test2, :force=>true, :id=>false do |t|
    create_table :table_test2, :force=>true do |t|
#      t.column :test_id, :primary_key
      t.column :name, :string, :limit=>512
    end
    change_column :table_test2, :id, :number
    rename_column :table_test2, :id, :test2_id 
#    reset_sequence!(:table_test2, :test_id, :table_test2_sequence)
    p pk_and_sequence_for(:table_test2)
    
    add_column :table_test2, :farm_id, :number, :default=>0
    rename_column :table_test2, :farm_id, :farmer_id 
    add_index :table_test2, :farmer_id, :name => "index_on_cows_for_farmers"
#add_index :ownerships, [:farmer_id, :tractor_id], :unique => true
#remove_index :ownerships, :column => [:farmer_id, :tractor_id]    
    
    create_table 'mc$test', :force=>true do |t|
      t.column :name, :string, :limit=>512      
      t.column 'thread#', :integer      
    end
  end
  def self.down
#    drop_table :job_infos
#    drop_table :log_infos
    remove_column :table_test2, :farm_id
  end
end

CreateUsersTable.up