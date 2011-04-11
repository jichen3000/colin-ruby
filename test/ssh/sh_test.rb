require 'helper/remote_helper'


host = "172.16.4.200"
user = "dbra3"
pwd = "mcdbra"
cmds = []
cmds << "env"
#cmds << "/dbra3/app/shells/a.sh"
RemoteHelper.ssh_do_cmds(host,user,pwd,cmds)

p "ok"