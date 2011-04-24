f = File.new("io","w")
f.write('wwwwwwwww')
f.flush
f.close
p f.path
p "op"