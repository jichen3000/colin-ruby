#system("ipconfig",'/all')
str = "catalog  datafilecopy '/Tbackup/oradata/orarpt/rwpgl_2G_003' level 0;"
filename = "/Tbackup/script/orarpt/test/l3"
#system("echo \"#{str}\" > #{filename}")
file = File.open(filename,"w")
file << str
file.close
#system("more #{filename}")
system("rman  target drb/drbmc@orarpt catalog mc_backup/mc_dbra@drb @#{filename}")
p "ok"