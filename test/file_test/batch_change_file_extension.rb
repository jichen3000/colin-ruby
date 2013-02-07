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


#f1 = "arc_1_10368.dbf"
#f2 = "arc_1_10366.dbf"
#f3 = "arc_1_10367.dbf"
#arr = []
#arr << f1
#arr << f2
#arr << f3
#rxp = /arc_\d+_\d.*\..+/
#arr.each do |item|
#	if item =~ rxp
#		puts item
#	end
#end
dir = "/Volumes/NO NAME/data"
from_extension = '.rmvb'
to_extension = '.data'
mcb = "w"
#arr = get_filename_arr(dir,false,/.*_#{mcb}_\d+_\d.+\.test/)
arr = get_filename_arr(dir,false)
arr.each do |filename|
  from_file_path = File.join(dir,filename)
  require 'fileutils'
  to_file_path = from_file_path.sub(from_extension, to_extension)
  p to_file_path
  FileUtils.move(from_file_path, to_file_path)
end
p arr
