# 这是oracle中dba的分解算法
# 主要是将dba分解为rfn和block_no
# 规则将16进制的dba转换为2进制，取后22位为block_no，其余的为rfn

require 'colin_helper'

def analyze_1(dba)
	bin_str = dba.hex.to_s(2).rjust(dba.size*4,'0')
	rfn = bin_str[0..9].bin
	block_no = bin_str[10..-1].bin
	bin_str = nil
	[rfn,block_no]
end
def analyze_2(dba)
	front = dba[0..2].hex
	rfn = front / 4
	block_no = (front%4)*1048576 + dba[3..-1].hex
	[rfn,block_no]
end
def analyze_3(dba)
	rfn,block_no = dba[0..2].hex.divmod(4)
	block_no =block_no*1048576 + dba[3..-1].hex
	[rfn,block_no]
end


dba = '0562A90B'
#dba = '13800a1c'
dba_i = dba.hex
start_time = Time.now
rfn = 0
block_no =0 
dba_i.upto(dba_i+100000) do |i|
#	puts i.to_s(16).rjust(8,'0')
	rfn,block_no = analyze_1(i.to_s(16).rjust(8,'0'))
end
end_time = Time.now
puts "rfn : #{rfn}"
puts "block_no : #{block_no}"
puts "	Through #{(end_time-start_time).to_f.to_s} seconds!"

puts "analyze_2"
start_time = Time.now
dba_i.upto(dba_i+100000) do |i|
#	puts i.to_s(16).rjust(8,'0')
	rfn,block_no = analyze_2(i.to_s(16).rjust(8,'0'))
end
end_time = Time.now
puts "rfn : #{rfn}"
puts "block_no : #{block_no}"
puts "	Through #{(end_time-start_time).to_f.to_s} seconds!"

puts "analyze_3"
start_time = Time.now
dba_i.upto(dba_i+100000) do |i|
#	puts i.to_s(16).rjust(8,'0')
	rfn,block_no = analyze_3(i.to_s(16).rjust(8,'0'))
end
end_time = Time.now
puts "rfn : #{rfn}"
puts "block_no : #{block_no}"
puts "	Through #{(end_time-start_time).to_f.to_s} seconds!"



puts "ok"