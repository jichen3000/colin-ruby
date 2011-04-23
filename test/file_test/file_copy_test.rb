#from_filename = "D:\1.txt"
#to_filename = "D:\work\testdata\1.txt"
#File::copy(from_filename,to_filename)
#dir_name = "D:/work/testdata/midfile"
dir_name = "/home/oracle/colin/test"
from_fns = [
	File.join(dir_name,"mcb_20080102_142803.loit"),
	File.join(dir_name,"mcb_20080104_112106.loit"),
	File.join(dir_name,"re_mcb_20080104_112106.loit")
           ]
to_filename = File.join(dir_name,"1.txt")
start_time = Time.now

to_file = File.new(to_filename,'w')
from_fns.each do |item|
	from_file = File.open(item,'r')
#	to_file.write(from_file.readlines)
	from_file.each_line do |line|
		to_file << line
	end
	from_file.close
end

to_file.close
end_time = Time.now
puts "Through time #{(end_time-start_time).to_f.to_s} seconds!!"


puts "ok"