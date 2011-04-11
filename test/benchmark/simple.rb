require 'benchmark'
arr = []
#Benchmark.bm do |i|
#i.report("1") {arr << 1}
#i.report("2") {arr << 2}
#end
#p arr
p Time.now
    value = ('10111000'+'00000000'+
             '11111111'+'11111111'+
             '00000000'+'00000000'+
             '10101010'+'01010101').to_i(2)
    value128 = ('10111000'+'00000000'+
             '11111111'+'11111111'+
             '00000000'+'00000000'+
            '11111111'+'11111111'+
            '00000000'+'00000000'+
            '11111111'+'11111111'+
            '00000000'+'00000000'+
             '10101010'+'01010101').to_i(2)
    value1 = ('00000000'+'00000000'+
              '10101010'+'01010101').to_i(2)
    value0 = ('01010101').to_i(2)
p Time.now
    other = '00010000'.to_i(2)
    other1 = '11111111'.to_i(2)
    p "value:#{value}"
    p "value1:#{value1}"
    p "value0:#{value0}"
    p "other:#{other}"
    p "other1:#{other1}"

class Colin
  def self.mc()
      
  end
end
Benchmark.bm do |i|
#  i.report("value") {128.times {65536.times {(value&other)}}}
#  i.report("value1") {128.times {65536.times {(value1&other)}}}
#  i.report("value1") {1000_0000.times {(value & other)}}
#  i.report("value1") {1000_0000.times {(value128 & other)}}
#  i.report("value1 + ") {1000_0000.times {(value1 + other)}}
#  i.report("value1 - ") {1000_0000.times {(value1 - other)}}
#  i.report("value1 * ") {1000_0000.times {(value1 * other)}}
#  i.report("value1 / ") {1000_0000.times {(value1 / other)}}
#  i.report("value1 % ") {1000_0000.times {(value1 % other)}}
#  i.report("value1 /%") {1000_0000.times {(value1.divmod(other))}}
#  i.report("value1 & ") {1000_0000.times {(value1 & other)}}
#  i.report("value1 | ") {1000_0000.times {(value1 | other)}}
#  i.report("value1 <<") {1000_0000.times {(value1 << 5)}}
#  i.report("value1 >>") {1000_0000.times {(value1 >> 5)}}
#  i.report("value1") {1000_0000.times {((value1 & other) == other)}}
  i.report("value1") {1000_0000.times {(value1 & other1)}}
  i.report("value0") {1000_0000.times {(value0 & other)}}
end
