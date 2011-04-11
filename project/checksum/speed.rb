require 'checksum'

def start(filename,block_size)
  fp=File.open(filename,'rb')
  while !fp.eof?
    barr=fp.read(block_size)
    checksum_value=CheckSum::do_checksum(barr)
  end
  fp.close
end
block_size = 512
#filename = "big_bin_100.loit"
#filename = "/dbra3/app/ruby/cur_redolog"
filename = "/Tbackup/dbtest/oradata/undotbs02.dbf"
puts "file size:#{File.size(filename)/1048576} M"

require 'benchmark'
Benchmark.bm do |i|
  i.report {start(filename,block_size)}
end
p "ok"