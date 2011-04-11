dfp=File.new('/Tbackup/hutest1.db','wb+')
pfp=open 'abc1', File::RDWR|File::NONBLOCK
while true
   dfp.write(pfp.read(1048576))
end
dfp.close
pfp.close
