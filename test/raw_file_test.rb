require "colin_helper"

filename = '/dev/raw/raw1'
#io = IO.new(IO.sysopen(filename),'r')
io = IO.new(IO.sysopen(filename),'r')
#io = IO.open(IO.sysopen(filename),"r+")
#io = File.new(filename,'r+b')
#io.sync = false
io.seek(8,IO::SEEK_CUR)
#io.flush
#puts io.path
#io.sysseek(8,IO::SEEK_SET)
#io.pos = 8
#i_arr = ["2300","4500","9600"]
#block = i_arr.pack("H2"*i_arr.size)
#puts ColinHelper.barr2str16(block)
#io.write(block)
#puts io.pos
puts io.tell
#block = io.readbytes(4)
block = io.read(4)
#block = io.read_nonblock(4)
#io.write
io.close
puts ColinHelper.barr2str16(block)
puts 'ok'