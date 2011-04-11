#f = IO.popen("ruby myputs.rb",File::RDWR) { |f| puts f.gets }
#f = IO.popen("sh myecho.sh",File::RDWR)
#while true
#  f.readline
#end


#f = IO.popen("sh myecho.sh") do |pipe|
#f = IO.popen("ruby myputs.rb") do |pipe|
f = IO.popen('TOpenQuery "" 3 7') do |pipe|
  pipe.sync = true
  while str = pipe.gets
    puts str
    p "aaaa"
  end
end
