class TransStrings
  def initialize(file_name,s_re)
    file = File.new(file_name,'r')
    @s_arr = []
    @r_arr = []
    @para = 'Para1'
    file.each_line do |line|
      
      line =~ s_re
      @s_arr << $1
    end
    file.close if file
  end
  def strarr2str(t_str,line_count=4)
    @s_arr.each do |line|
      @r_arr << t_str.gsub(@para,line) if line != nil      
    end
    rows = @r_arr.size / 4
    remain_rows = @r_arr.size % 4
    rows.times {|i| puts @r_arr[i*4..i*4+3].join(' ')}
    puts @r_arr[rows*4..rows*4+remain_rows-1].join(' ') if remain_rows > 0
  end
  def strarr2strarr(t_str)
    @s_arr.each do |line|
      puts t_str.gsub(@para,line) if line != nil      
    end
  end
end


file_name = File.dirname(__FILE__)+'\trans.txt'
s_re = Regexp.new('ol_change\.(\S+)\s')
t_str = ':Para1,'
ts = TransStrings.new(file_name,s_re)
ts.strarr2str(t_str)
t_str = '@Para1 = nil'
ts.strarr2strarr(t_str)