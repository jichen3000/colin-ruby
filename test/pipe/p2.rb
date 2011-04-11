dfp=File.new('/archlog/hutest.db','wb+')
pfp=open 'pipe200', File::RDWR
while true 
   dfp.write(pfp.read(1048576))
end
dfp.close
pfp.close
