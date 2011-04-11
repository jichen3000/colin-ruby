# 测试
# 结果：使用file.write方法以后，指针会指到write的后面
require 'colin_helper'

def replace(s_filename,o_filename)
  s_file = File.new(s_filename,'rb')
  o_file = File.new(o_filename,'r+b')
  
  cur_block = s_file.read(8)
  o_file.write(cur_block)
  puts ColinHelper.barr2str16(cur_block) if cur_block
  next_block = o_file.read(8)
  puts ColinHelper.barr2str16(next_block) if next_block
  
  o_file.seek(-8,IO::SEEK_CUR)
  next_block = o_file.read(8)
  puts ColinHelper.barr2str16(next_block) if next_block
  
  o_file.seek(0,IO::SEEK_SET)
  next_block = o_file.read(4)
  puts ColinHelper.barr2str16(next_block) if next_block
  
  s_file.close
  o_file.close
end
def regen_file(s_filename,o_filename)
  s_file = File.new(s_filename,'rb')
  o_file = File.new(o_filename,'wb')
  s_file.read(2048)
  cur_block = s_file.read(512)
  o_file.write(cur_block)
  s_file.close
  o_file.close
end
gen_s_filename='D:\work\railsws\mc_rbs\read_ora_log\testdata\1_156.dbf'
s_filename='D:\work\railsws\mc_rbs\read_ora_log\testdata\source.rpb'
o_filename='D:\work\railsws\mc_rbs\read_ora_log\testdata\object.rpb'

regen_file(gen_s_filename,o_filename)
puts "regen_file ok"

replace(s_filename,o_filename)
puts "replace ok"



