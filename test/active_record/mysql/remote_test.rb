require 'helper/remote_helper'

host = "svn.mchz.com.cn"
#host = "60.12.111.112"
user = "dbra"
pwd = "mcdbra"
#user = "root"
#pwd = "mchz!QAZ"

source_dir = "test/active_record/mysql"
target_dir = "/home/dbra/test"
upload_files = []
upload_files << ['mysql.rb',source_dir,target_dir]

cmds = []
#cmds << "env"
cmds << "pwd"
cmds << "ruby test/mysql.rb"
download_files = []
download_files << ['oracle_issues.txt',target_dir,source_dir]
#RemoteHelper.ssh_do_cmds(host,user,pwd,cmds,:ssh_port=>2222)
RemoteHelper.ssh_files_and_cmds(host,user,pwd,upload_files,cmds,download_files,:ssh_port=>2222)

puts "ok"
