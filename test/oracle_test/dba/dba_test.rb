dba = '0A116778'
dba = '0A016778'

front = dba[0..2].hex
block_no =(front%4)*1048576 + dba[3..-1].hex
puts "front : #{front}"
puts "dba : #{dba}"
puts "block_no : #{block_no}"
puts "dba[3..-1].hex : #{dba[3..-1].hex}"
puts "(front%4)*1048576 : #{(front%4)*1048576}"

p (dba.hex >> 22)
a = ('0000000000'+'1111111111'+'1111111111'+'11').to_i(2)
a = 4194303
p a
p (dba.hex & a)

def test_dba
  10.times do |i|
    p rand('ffffffff'.hex)
  end
end
