file = File.open('D:\work\testdata\new\19.1.dbf','rb')
p 1024*1024
block = file.read(1048576)
p block.size
p file.eof?
p "ok"
