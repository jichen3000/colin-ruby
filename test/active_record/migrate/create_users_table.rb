require 'activerecord'
class CreateUsersTable < ActiveRecord::Migration
  def self.up
    create_table :cows do |t|
      t.column :name, :string
      t.column :breed, :string
      t.column :born_on, :datetime
      t.column :milkable, :boolean
    end    
  end
  def self.down
  end
end