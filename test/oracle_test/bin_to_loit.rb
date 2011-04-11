require 'test/oracle_test/dba/dba_class'


def bin_to_loit(bin_filename,loit_filename,is_anadba=false)
  binfile = File.new(bin_filename,'rb')
  loitfile = File.new(loit_filename,'w')
  record = binfile.read(16)
  index = 0
  while record
#    if index > 10
#      break
#    end
    a = record.unpack("LLLL")
    block_number = a[1]
    if is_anadba
      rfn,block_number = Dba.ana4i(a[1])
    end
    loitfile << "1701 "+ 
      a[0].to_s(16).rjust(4,'0').upcase+ " "+ 
      block_number.to_s(16).rjust(8,'0').upcase + " " +
      "0000 " + "0000 " + "0000 " + "0000 " + 
      a[2].to_s(16).rjust(4,'0').upcase + "\n" 
#    p block_number.to_s(16).rjust(8,'0').upcase
#    p a[1].to_s(16).rjust(8,'0').upcase
    index += 1
    record = binfile.read(16)
  end
  binfile.close
  loitfile.close
end

bin_filename='d:/tmp/log/bin_1000w.loit'
loit_filename='d:/tmp/log/txt_1000w.txt'
#bin_filename='d:/tmp/log/bin.soit'
#loit_filename='d:/tmp/log/stxt_1000w.txt'

bin_to_loit(bin_filename,loit_filename,true)
p "ok"