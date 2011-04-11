require 'rawio'
require 'colin_helper'

start_time = Time.now
f = RawIO::RawFile.new
#filename = "/dev/raw/raw15"
filename = '/dev/vgcss_app/rlvora_csspartidx07'
p "filename : #{filename}"
f.open(filename,'rb')
block_size = 1024
block = nil
block = f.read(block_size)
puts ColinHelper.barr2str16(block)
i = 8192-1024
f.seek(i,IO::SEEK_CUR)
f.read(8192)
f.close

#(130*1024).times do |i|
## printf "=" if (i % 1024) == 0
#  puts i
#  block = f.read(block_size)
#end
#puts
end_time = Time.now
puts "through seconds #{(end_time - start_time).to_f.to_s}"
puts "ok"
# 16300
