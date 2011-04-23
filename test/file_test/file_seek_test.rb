require '../colin_helper'

#file_name = 'D:\work\railsws\mc_rbs\test\1_158.dbf'
#file = File.new(file_name,'rb')
#file.seek(20,IO::SEEK_CUR)
#block = file.read(2)
#puts ColinHelper.barr2str16(block)
#file.seek(-8,IO::SEEK_CUR)
#block = file.read(2)
#puts ColinHelper.barr2str16(block)

file_name = 'D:\data\test\test01.dbf'
file = File.new(file_name,'rb')
file.seek(-20,IO::SEEK_END)
block = file.read(20)
puts ColinHelper.barr2str16(block)
p "ok"
