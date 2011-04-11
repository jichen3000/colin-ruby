fp = open 'pipe28', File::RDWR
arcf=File.open("/Tbackup/drb/mctps01.dbf","rb")
while !arcf.eof?
  fp.syswrite(arcf.read(1048576))
end
fp.close
arcf.close
