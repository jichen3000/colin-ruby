dba = '0A016778'

front = dba[0..2].hex
block_no =(front%4)*1048576 + dba[3..-1].hex
puts "front : #{front}"
puts "dba : #{dba}"
puts "block_no : #{block_no}"
puts "dba[3..-1].hex : #{dba[3..-1].hex}"
puts "(front%4)*1048576 : #{(front%4)*1048576}"

