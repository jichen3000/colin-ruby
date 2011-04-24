#require 'log4r'

class ColinHelper
	class << self
		# ���㵱ǰʱ������ļ��ʱ�䣨�룩
		# start_time ��ʼ��ʱ��
		# step_hour ����ʱ�䣨Сʱ��
		def count_seconds(start_time,step_hour)
			# ע�����ｫ��ֵתΪ����ǳ���Ҫ������ȡ���ʱ���ȡ��С��
			s = (Time.now - start_time).to_i
			step_sec = (step_hour*3600).to_i
			# ���ʼ��ʱ����ڵ�ǰ��ʱ�䣬ֱ�ӷ��ز�ֵ��
			if s <= 0 then
				return s.abs
			else
				step_sec - (s % step_sec)
			end
		end
		# ��ȡlog4r��log
		def get_log4r_log(filename,log_name,log_level=nil,is_stdout=false,is_trunc=false)
			log = Log4r::Logger.new(log_name)
			log.outputters = Log4r::Outputter.stdout if is_stdout
			
			log.add(Log4r::FileOutputter.new('file',
				{:filename => filename, :trunc => is_trunc}))
			log_level ||= Log4r::INFO
			log.level = log_level
			log
		end
	  #��ȡʱ����ַ���ʽ: 2007-05-23 14:32:33  333
	  def str_time(time)
	    time.strftime('%Y-%m-%d %H:%M:%S ')+' '+time.usec.to_s
	  end
	  #��10�������ֱ��16�����ַ��������λ��
	  def str16(i,just=2)
	    i.to_s(16).rjust(just,'0').upcase
	  end
	  #�ı��ļ���ĺ�׺
	  def log_name(file_name,suffix='log')
	    file_name.sub(Regexp.new('\\'+File.extname(file_name)+'$'),'.'+suffix)
	  end
	  def log_name_add_time(file_name,time=nil,suffix='log')
	  	time ||= Time.now
	  	file_name.sub(Regexp.new('\\'+File.extname(file_name)+'$'),time.strftime('_%Y%m%d_%H%M%S')+'.'+suffix)
	  end
		# ����ļ���
	  def gen_file_name(file_name,prefix,suffix,dir_name=nil)
	  	if dir_name == nil
		    File.join(File.dirname(file_name),
		    		prefix+File.basename(file_name.sub(Regexp.new('\\'+File.extname(file_name)+'$'),'.'+suffix)))
	  	else
	  		File.join(dir_name,
						prefix+File.basename(file_name.sub(Regexp.new('\\'+File.extname(file_name)+'$'),'.'+suffix)))
	  	end
	  end
	  def read_block(block,offset,size,is_reverse=true)
	    if is_reverse
	      block[offset..(offset+size-1)].reverse 
	    else
	      block[offset..(offset+size-1)] 
	    end
	  end
	  #��һ��������ֽ���ɵ��ַ�ת��������ֵ
	  def barr2int(b_arr)
	#    sum = 0
	#    b_arr=b_arr.reverse
	#    b_arr.size.times do |i|
	#      sum += b_arr[i]*(256**(i))
	#    end
	#    sum
	    b_arr.unpack('H'+(2*b_arr.length).to_s).join.hex
	  end
	  #��һ��������ֽ���ɵ��ַ�ת����16���Ƶ��ַ�
	  def barr2str16_o(b_arr)
	    sum = ''
	    b_arr.size.times do |i|
	      sum += b_arr[i].to_s(16).rjust(2,'0').upcase
	    end
	    sum
	  end
	  def barr2str16(b_arr,len = nil)
	  	len ||= 2*b_arr.length
	    b_arr.unpack('H'+(len).to_s).join.upcase
	  end
    # ��16���Ƶ��ַ�ת���ɶ������ֽ���
    def str2barr(str)
      arr = Array.new
      (str.size/2).times do |index|
        arr << str[2*index..(2*index+1)]
      end
      arr.pack("H2"*(arr.size))
    end
	  # ������ת��Ϊ���Ա�4���
	  # ��5 -> 8
	  def round4(int)
	    result = int
	    if (int % 4) != 0
	      result += 4 - (int % 4) 
	    end
	    result
	  end
		# 
		def get_filename_arr(dir, is_joindir=true, rxp = nil)
			r = Array.new
			rxp ||= /.*/
			Dir.open(dir).each do |item|
				if item =~ rxp and item!="." and item!=".." and File.file?(File.join(dir,item))
					if is_joindir
						r << File.join(dir,item)
					else
						r << item
					end
				end 
			end
			r
		end
		# �ϲ��ļ�
		def joinfiles2file(filename_arr,join_filename)
			r = File.new(join_filename,'w')
			filename_arr.each do |item|
				cur_file = File.open(item,'r')
				cur_file.each_line {|l| r << l}
				cur_file.close
			end
			r.close
			r.path
		end
		def joinfiles2file_filearr(file_arr,join_filename)
			r = File.new(join_filename,'w')
			file_arr.each do |item|
				cur_file = File.open(item.path,'r')
				cur_file.each_line {|l| r << l}
				cur_file.close
			end
			r.close
			r.path
		end
		def map_add_prefix(str,prefix,split_str=",")
			arr = str.split(split_str)
			arr.map! {|i| prefix+i}
			arr.join(split_str)
		end
		# type:
		def sql2string(value,type)
			if value == nil
				return DT_NULL
			end
		  r = nil
		  if type == DT_NUMBER
		  	r = value.to_s
		  elsif type == DT_VARCHAR2
		  	r = "'"+value+"'"
			elsif type == DT_DATE
				# 2008/03/25 10:20:30
				if value.to_s != ''
					r = "to_date('#{value}','YYYY/MM/DD HH24:MI:SS')"
				else
					r = 'null'
				end
			end
			r
		end
		
	end
	DT_NULL = 'NULL'
	DT_NUMBER = 'NUMBER'
	DT_VARCHAR2 = 'VARCHAR2'
	DT_DATE = 'DATE'
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
