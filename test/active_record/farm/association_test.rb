require 'farm_base_conn'

cow = Cow.find(:first)
p cow.farmer.name

#farmer = Farmer.find_by_name("Farmer Fred")
farmer = Farmer.find(10000)

p farmer
#farmer.cows.each do |cow|
#  print cow.name + ", "
#end
#puts

farmer.resellers.each do |item|
  p item  
end
p "ok"