hash = {:test=>true, :name=>"test"}
puts hash[:test]
hash[:name]||="jc"
p "hash[:name]:#{hash[:name]}"
hash[:name1]||="jc"
p "hash[:name1]:#{hash[:name1]}"
p "oo"

