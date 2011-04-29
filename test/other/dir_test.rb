#

def get_filename_arr(dirname)
	r = Array.new
	Dir.open(dirname).each do |item|
		r << item if item!="." and item!=".."  and File.file?(File.join(dirname,item))
	end
	r
end

dirname = 'D:\work\testdata'
require 'pp'
pp get_filename_arr(dirname)

system('')
