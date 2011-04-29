def read_file(file_name) 
  file = File.new(file_name,'r')
  max= 10
  i = 0
  while !file.eof
    max.times do |l_i|
      line = file.readline if !file.eof
      puts "line_no : #{l_i+i*max}, #{line}" if !file.eof
    end
    puts 
    i += 1
  end
end

file_name = 'D:\work\railsws\mc_rbs\read_ora_log\test_w_1_158.test'
read_file(file_name)