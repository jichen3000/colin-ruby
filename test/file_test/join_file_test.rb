  def joinfiles(file_names)
    file_arr = file_names.split(',')
    r = file_arr.delete_at(0)
    if file_arr.size > 0
      puts 'join'
      file = File.new(r,'a')
      file_arr.each do |item|
        cur_file = File.new(item,'r')
        cur_file.each_line do |line|
          file << line
        end
        
        cur_file.close
      end
      file.close
    end
    r
  end

#file_names = 'D:\work\railsws\mc_rbs\read_ora_log\test.txt' 
file_names = 'D:\work\railsws\mc_rbs\read_ora_log\test.txt' +
    ',D:\work\railsws\mc_rbs\read_ora_log\w_1_157.rld' + 
    ',D:\work\railsws\mc_rbs\read_ora_log\w_1_158.rld'
    
puts joinfiles(file_names) 