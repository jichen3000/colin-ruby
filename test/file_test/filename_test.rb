file_name = 'D:\work\railsws\mc_rbs\read_ora_log\1_158.dbf' 
file_name1 = 'D:\work\railsws\mc_rbs\read_ora_log\1_159.dbf' 
file_name2 = '1_160.dbf'

puts File.basename(file_name)
puts File.dirname(file_name)
time = Time.now
puts File.join(File.dirname(file_name),time.strftime('%Y-%m-%d-%H-%M-%S')+
		File.extname(file_name))
		
		require 'pp'
arr = [file_name,file_name1,file_name2]
pp arr
arr.map!{|i| File.basename(i)}
pp arr