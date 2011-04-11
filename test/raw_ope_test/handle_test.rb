require 'rawio'
require 'colin_helper'
start_time = Time.now
f = RawIO::RawFile.new
#filename = "/dev/raw/raw15"
filename = '/dev/vgcss_app/rlvora_csspartidx07'
p "filename : #{filename}"
block_size = 1024

70.times do |i|
  puts "i:#{i}"
  f.open(filename,'rb')
  f.read(block_size)
  f.close
end 
  
  
end_time = Time.now
puts "through seconds #{(end_time - start_time).to_f.to_s}"
puts "ok"
