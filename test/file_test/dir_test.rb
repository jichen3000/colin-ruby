directory_name = 'D:\tools'
filename = 'D:\work\out_note.txt'

p File.directory?(directory_name)          # => true
p File.directory?(filename)       
p File.file?(filename)       
p File.file?(directory_name)  

dir = Dir.open(directory_name) { |d| d.grep /eclipse/ }
dir.each do |item|
  puts itemend  
puts "中文"
puts "中文"

puts Dir.getwd

p ENV
