require 'farm_base_conn'
mylog = Logger.new('mylog.txt')
ActiveRecord::Base.logger = mylog
class CreateFarmTable < ActiveRecord::Migration
  def self.up
#    create_table :cows, :force=>true do |t|
#      t.column :name, :string
#      t.column :farmer_id, :integer
#    end
#    create_table :farmers, :force=>true do |t|
#      t.column :name, :string
#      t.column :address, :string
#    end
#    create_table :resellers, :force=>true do |t|
#      t.column :name, :string
#      t.column :address, :string
#    end
#    create_table :farmers_resellers, :id=>false, :force=>true do |t|
#      t.column :reseller_id, :integer, :null=>false
#      t.column :farmer_id, :integer, :null=>false
#    end
#    create_table :distributors, :force=>true do |t|
#      t.column :reseller_id, :integer
#      t.column :farmer_id, :integer
#      t.column :milk_price, :float
#    end   
    create_table :addresses, :force=>true do |t|
      t.column :street, :string
      t.column :city, :string
      t.column :addressable_id, :integer
      t.column :addressable_type, :string
    end
    
    f1 = Farmer.find_or_create_by_name("Farmer Fred") 
    f1.address = "aaaa"
    f1.save
    
    c1 = Cow.find_or_create_by_name("Cow mm")
    c1.farmer = f1
    c1.save
    
    10.times do |i|
      c = Cow.find_or_create_by_name("Cow mm"+i.to_s)
      c.farmer = f1
      c.save
    end
#    ra = Array.new
#    5.times do |i|
#      r = Reseller.find_or_create_by_name("R "+i.to_s)
#      f1.resellers << r
#    end
    
#    d = Distributor.new
    f1 = Farmer.find_or_create_by_name("Farmer Fred") 
#    d.farmer = f1
    r2 = Reseller.find_or_create_by_name("R 2") 
#    d.reseller = r2
#    d.milk_price = 4.3
#    d.save
    
    a1 = Address.find_or_create_by_city("HangZhou")
    a1.street = 'weng'
    a2 = Address.find_or_create_by_city("ShangHai")
    a2.street = 'guang'
    
    f1.address_other = a1
    f1.save
    
    r2.address_other = a2
    r2.save
  end
  def self.down
  end
end

CreateFarmTable.up