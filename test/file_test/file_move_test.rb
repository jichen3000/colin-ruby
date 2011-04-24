require 'fileutils'

file_name ='D:/work/testdata/loi/mcb_1_37.loit'
to_dir_name = 'D:/work/testdata/loiback'
puts 
#FileUtils.move(file_name,to_dir_name)
File.delete(file_name)

puts 'ok'