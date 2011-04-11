require 'my_stdio'
require 'colin_helper'
                                        
f = MyStdio::File.new
f.open('/dev/raw/raw1','r')
5.times do |i|
	pos = f.tell
	block = f.read(8)
	puts pos.to_s.ljust(2,' ')+" : "+ColinHelper.barr2str16(block)
end
puts "ok"
