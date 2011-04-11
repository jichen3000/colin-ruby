#require 'socket'
block_size = 512
filename = "D:/tmp/arc_1_15445.dbf"
w_filename = filename+'.bak'
fi = File.open(filename,'rb')
fw = File.open(w_filename,'wb')
count = File.size(filename)/block_size
count.times do |index|
  fw.write(fi.read(block_size))
end

fi.close
fw.close
p "ok"
