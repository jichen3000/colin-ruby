class ColinHelper
	# 计算当前时间所需的间隔时间（秒）
	# start_time 开始的时间
	# step_hour 间隔的时间（小时）
	def self.count_seconds(start_time,step_hour)
		# 注意这里将差值转为整数非常重要，否则取余的时候会取到小数
		s = (Time.now - start_time).to_i
		step_sec = (step_hour*3600).to_i
		# 如果开始的时间大于当前的时间，直接返回差值。
		if s <= 0 then
			return s.abs
		else
			step_sec - (s % step_sec)
		end
	end
	# 获取log4r的log
	def self.get_log4r_log(filename,log_name,log_level=nil,is_stdout=false,is_trunc=false)
		require 'log4r'		
		log = Log4r::Logger.new(log_name)
		log.outputters = Log4r::Outputter.stdout if is_stdout
		
		log.add(Log4r::FileOutputter.new('file',
			{:filename => filename, :trunc => is_trunc}))
		log_level ||= Log4r::INFO
		log.level = log_level
		log
	end
  #获取时间的字符串。格式: 2007-05-23 14:32:33  333
  def self.str_time(time)
    time.strftime('%Y-%m-%d %H:%M:%S ')+' '+((time.to_f * 1000)%1000).to_i.to_s
  end
  #将10进制数字变成16进制字符串，并且添加位数
  def self.str16(i,just=2)
    i.to_s(16).rjust(just,'0').upcase
  end
  #改变文件名的后缀
  def self.log_name(file_name,suffix='log')
    file_name.sub(Regexp.new('\\'+File.extname(file_name)+'$'),'.'+suffix)
  end
  def self.gen_file_name(file_name,prefix,suffix,dir_name=nil)
  	if dir_name == nil
	    File.join(File.dirname(file_name),
	    		prefix+File.basename(file_name.sub(Regexp.new('\\'+File.extname(file_name)+'$'),'.'+suffix)))
  	else
  		File.join(dir_name,
					prefix+File.basename(file_name.sub(Regexp.new('\\'+File.extname(file_name)+'$'),'.'+suffix)))
  	end
  end
  def self.read_block(block,offset,size,is_reverse=true)
    if is_reverse
      block[offset..(offset+size-1)].reverse 
    else
      block[offset..(offset+size-1)] 
    end
  end
  #将一组二进制字节组成的字符串转换成整数值
  def self.barr2int(b_arr)
#    sum = 0
#    b_arr=b_arr.reverse
#    b_arr.size.times do |i|
#      sum += b_arr[i]*(256**(i))
#    end
#    sum
    b_arr.unpack('H'+(2*b_arr.length).to_s).join.hex
  end
  #将一组二进制字节组成的字符串转换成16进制的字符串
  def self.barr2str16_o(b_arr)
    sum = ''
    b_arr.size.times do |i|
      sum += b_arr[i].to_s(16).rjust(2,'0').upcase
    end
    sum
  end
  def self.barr2str16(b_arr)
    b_arr.unpack('H'+(2*b_arr.length).to_s).join.upcase
  end
  # 将数字转换为可以被4整除
  # 例：5 -> 8
  def self.round4(int)
    result = int
    if (int % 4) != 0
      result += 4 - (int % 4) 
    end
    result
  end
end

class String

  def bin
    val = self.strip
    pattern = /^([+-]?)(0b)?([01]+)(.*)$/
    parts = pattern.match(val)
    return 0 if not parts
    sign = parts[1]
    num  = parts[3]
    eval(sign+"0b"+num)
  end

end

class Array
  def uniq_by_sort_and_eql?
    old_item = nil
    i = self.size
    while i >= 0
      cur_item = self[i]
      if old_item!=nil and cur_item.eql?(old_item)
        self.delete_at(i)
      end
      old_item = cur_item
      i -= 1
    end
    self
  end
end
