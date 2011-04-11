require 'libc'
require "colin_helper"

f1name = '/dev/raw/raw1'
f2name = 'n_raw1'
f1 = Libc.fopen(f1name, 'r')
f2 = Libc.fopen(f2name, 'w+')

block_size = 16

buffer = Libc.malloc(block_size)
Libc.fseek(f1,8,IO::SEEK_CUR)
nread = Libc.fread(buffer, 1, block_size, f1)
Libc.fwrite(buffer, 1, nread, f2)
#puts buffer.class
#puts ColinHelper.barr2str16(buffer)

Libc.fclose(f1)
Libc.fclose(f2)

puts "ok"
#write(fileno(f), RSTRING(str)->ptr+offset, l);