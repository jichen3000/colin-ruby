require 'checksum'
def barr2str16(b_arr,len = nil)
  len ||= 2*b_arr.length
  b_arr.unpack('H'+(len).to_s).join.upcase
end

def start(filename,block_size)
  fp=File.open(filename,'rb')
  while !fp.eof?
    barr=fp.read(block_size)
#    p barr2str16(barr,32)
    checksum_value=CheckSum::do_checksum(barr)
    p barr2str16(checksum_value)
    p barr2str16(checksum_value)
    puts "checksum10:#{checksum_value}"
    puts "checksum16:#{checksum_value.to_i.to_s(16).rjust(5,'0').upcase}"
  end
  fp.close
end
block_size = 512
filename = "big_bin_100.loit"
#filename = "/dbra3/app/ruby/cur_redolog"
#filename = "/Tbackup/dbtest/oradata/undotbs02.dbf"
puts "file size:#{File.size(filename)/1048576} M"

start(filename,block_size)
#require 'benchmark'
#Benchmark.bm do |i|
#  i.report {start(filename,block_size)}
#end
p "ok"