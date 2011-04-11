require "activerecord"

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "colin",
  :username => "colin",
  :password => "colin",
  :host     => "colin-book"  
)

ActiveRecord::Base.logger = Logger.new('mylog.txt')
ActiveRecord::Base.primary_key_prefix_type = :table_name_with_underscore
ActiveRecord::Base.table_name_prefix = 'mc$dr_'
ActiveRecord::Base.pluralize_table_names = false


class SubSystem < ActiveRecord::Base
end
class ServiceInfo < ActiveRecord::Base
end

class CreateTable < ActiveRecord::Migration
  def self.up
    # 生成的表名为mc$dr_sub_system
    # 自动生成的id（在情况:table_name_with_underscore）为mc$dr_sub_system_id
    create_table :sub_system, :primary_key=>'sub_id', :force=>true do |t|
      t.column :name, :string, :limit => 30
      t.column :status, :string, :limit => 2
    end
  create_table :service_info, :primary_key=>'service_id', :force=>true do |t|
    t.column :name, :string, :limit => 30
    t.column :status, :string, :limit => 2
    t.column :sub_id, :integer
  end
  end
end
#CreateTable.up

require 'active_record/fixtures'
Fixtures.create_fixtures('./',:sub_system)
Fixtures.create_fixtures('./',:service_info)

#p "ok"



    
