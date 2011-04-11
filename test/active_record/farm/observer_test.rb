require 'farm_base_conn'

class FarmerObserver < ActiveRecord::Observer
  observe Farmer, Cow
  def after_save(record)
    puts "before_save #{record.id}"
  end
  def before_save
    puts "before_save"
  end
end
#ActiveRecord::Base.observers = 'farmer_observer'
ActiveRecord::Base.observers = FarmerObserver
p ActiveRecord::Base.observers

f = Farmer.find_or_create_by_name("Farmer Fred")
#f.address = f.address + 1.to_s
#f = Farmer.new
p f
f.save

c1 = Cow.find_or_create_by_name("Cow mm")
c1.save

p "ok"
