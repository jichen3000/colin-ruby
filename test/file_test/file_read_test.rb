require 'colin_helper'

#filename = '/oradata1/ora96/oradata/ora96/system01.dbf'
filename = 'D:\work\testdata\object.rpb'
file = File.new(filename,'rb')
file.seek(16,IO::SEEK_SET)
block = file.read(20)
puts 'first'
puts ColinHelper.barr2str16(block)
sleep(20)
puts 'second'
puts ColinHelper.barr2str16(block)