filename = File.join(File.dirname(__FILE__),'test.txt')
file = File.open(filename)
line = file.readline
p line
p line.size
line.bytes{|byte| p byte}
file.seek(0-(line.size+1),IO::SEEK_CUR)
line = file.readline
p line
p "OK"
