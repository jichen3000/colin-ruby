require 'erb'
t = ERB.new("Chunky <%= food %>!")
t = ERB.new %{Chunky <%= food %>!}
food = "bacon"
puts t.result
puts "ok"
puts "中文"