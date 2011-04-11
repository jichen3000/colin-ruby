require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :encoding => "utf-16",
  :database => "megatrust",
  :username => "colin_dev",
  :password => "colin_dev"
)
#ActiveRecord::Base.table_name_prefix = "mc$ma_"
# 表名关掉复数默认形式
ActiveRecord::Base.pluralize_table_names = false
class ColinTable < ActiveRecord::Migration
  def self.up
    create_table :colin, :force=>true do |t|
      t.string :info, :limit=>400
      t.datetime :born_on
      t.integer :price, :limit=>9
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column(:colin, :id, :integer, :limit => 9)
#    begin
#      create_table :colin do |t|
#        t.column :info, :string, :limit=>400
#        t.column :born_on, :datetime
#        t.column :price, :integer, :limit=>9
#      end
#    rescue ActiveRecord::StatementInvalid =>e
#      if e.message.include?("ORA-00955") 
#        down
#        retry
#      end
#    end  
  end
  def self.down
    drop_table :colin
  end
end
class Colin < ActiveRecord::Base
  INFO_ARR=["colin","What is time?","I like it.",
    "Analyzing documents without indexing",
    "Covers how to index MS Word, PDF, etc.",
    "Control the logic used to process requests.",
    "Search Components provide core functionality to a Request Handler.",
    "Read data residing in relational databases",
    "Make it possible to plugin any kind of datasource (ftp,scp etc) and any other format of user choice (JSON,csv etc)",
    "The Handler has to be registered in the solrconfig.xml as follows."]
  def self.insert_10
    10.times do |index|
      Colin.create(:info=>INFO_ARR[index],:born_on=>Time.now,:price=>index+100)
    end
  end
end
#ColinTable.up
Colin.destroy_all
Colin.insert_10
p "ok"