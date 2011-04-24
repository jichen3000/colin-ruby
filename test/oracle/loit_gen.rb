require 'dba/dba_class'

file_name='testloit_1000w_lb.log'
afn_range = 128
#arr = Dba.gen_rand_afndba_arr(afn_range,10)
arr = Dba.gen_rand_afndba_arr(afn_range,1000_0000)
file = File.open(file_name,'w')
arr.each do |item|
  file << Dba.afn_itos4(item[0])+' '+Dba.dba_itos8(item[1])+"\n"
end
file.close
p "ok"