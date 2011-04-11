require 'rawio'
require 'colin_helper'
                                        
f = RawIO::RawFile.new
f.open('/dev/raw/raw1','rw')

5.times do |i|
	block = f.read(512)
	puts i.to_s.ljust(2,' ')+":"
	puts ColinHelper.barr2str16(block)
end
