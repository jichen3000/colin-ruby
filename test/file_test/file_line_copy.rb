s_filename = 'D:\work\eclipsews\mc_rbs\read_ora_log\doc\midfile\re_102_01.loit'
t_filename = 'D:\work\eclipsews\mc_rbs\read_ora_log\doc\midfile\re_102_02.loit'

line_count = 25000

s_file = File.open(s_filename,'r')
t_file = File.open(t_filename,'w')
line_count.times do |index|
	break if s_file.eof?
	t_file << s_file.readline
end

s_file.close
t_file.close

puts "ok"