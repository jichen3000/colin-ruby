require 'test/oracle_test/dba/dba_class'

start_time = Time.now
#file_name='d:/tmp/logtestloit_1000_bin.log'
file_name='d:/tmp/log/bin_1000w.loit'
afn_range = 128
#arr = Dba.gen_rand_afndba_arr(afn_range,10)
arr = Dba.gen_rand_afndba_arr(afn_range,1000_0000)
file = File.new(file_name,'wb')
arr.each do |item|
  count = rand(10)
  if count <= 8
    count = 1
  end
#  block = 
  file.write([item[0],item[1],count,0].pack('LLLL'))
#  file.write([item[0]].pack('l'))
#  file.write([item[1]].pack('l'))
#  p item
#  file.write([0].pack('l'))
end
file.close
p file.path
end_time = Time.now
p start_time
p end_time
p end_time - start_time
p "ok"