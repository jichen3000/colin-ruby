require 'rawio'
require 'colin_helper_mini'

start_time = Time.now
f = RawIO::RawFile.new
#filename = "/dev/raw/raw15"
filename = '/dev/rlvraw01'
f.open(filename,'r')
block_size = 16*1024
block = nil
(130*1024).times do |i|
#	printf "=" if (i % 1024) == 0
	puts i
	block = f.read(block_size)
end
puts
end_time = Time.now
puts "through seconds #{(end_time - start_time).to_f.to_s}"
puts "ok"
# 16300



