require 'my_stdio'
require 'colin_helper'
                                        
def file_write(file)
	i_arr = ["2300","4500","9600"]
	block = i_arr.pack("H2"*i_arr.size)
#	puts ColinHelper.barr2str16(block)
	
	file.write(block)
end
f = MyStdio::File.new
f.open('/dev/raw/raw1','w')
##f.open('foo.txt')
##puts f.readbyte
#block = f.read(8)
#puts ColinHelper.barr2str16(block)
#puts f.seek(8,IO::SEEK_CUR)
##puts f.seek(8,1)
#puts f.tell
#block = f.read(8)
#puts ColinHelper.barr2str16(block)

puts "pre write pos: "+f.tell.to_s
puts file_write(f)
#puts ColinHelper.barr2str16(f.read(8))
puts "after write pos: "+f.tell.to_s

f.close
puts "ok"
