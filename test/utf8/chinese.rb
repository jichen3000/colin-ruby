c_str = "中文"
puts c_str
f = IO.popen("a") do |pipe|
  pipe.sync = true
  while str = pipe.gets
    puts str
  end
end

p "ok"