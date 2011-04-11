i = 0
f = File.open(File.join(File.dirname(__FILE__),'dd.log'),'w')
loop do
  f.puts i
  f.flush
  i += 1
  sleep(2)
end
f.close
