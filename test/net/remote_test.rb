require 'helper/remote_helper'


host = "172.16.4.200"
#user = "dbra3"
#pwd = "mcdbra"
user = "root"
pwd = "root"
source_dir = "test/net"   
target_dir = "/dbra3/app/ruby/test"
files = []
files << ['get_packet.rb',source_dir,target_dir]
#files << ['t.txt','D:/tmp',target_dir]
cmds = []
cmds << "cd $RUBY_HOME;ruby test/get_packet.rb"
is_remove_files = false
RemoteHelper.ssh_files_and_cmds(host,user,pwd,files,cmds,is_remove_files)
  
p "test ok"
