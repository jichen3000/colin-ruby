require 'helper/remote_helper'


host = "172.16.4.28"
user = "dbra3"
pwd = "mcdbra"
source_dir = "test/file_test/file_lock"
target_dir = "/dbra3/app/ruby/test"
files = []
files << ['file_lock.rb',source_dir,target_dir]
#files << ['t.txt','D:/tmp',target_dir]
cmds = []
cmds << "cd $RUBY_HOME;ruby test/file_lock.rb"
is_remove_files = true
RemoteHelper.ssh_files_and_cmds(host,user,pwd,files,cmds,is_remove_files)
  
p "test ok"

