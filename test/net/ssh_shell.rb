require 'net/ssh'
Net::SSH.start('qa-host','root',:password=>'fortigate') do |ssh|
    shell = ssh.shell.sync
    out = shell.pwd
    p out.stdout
    # ssh.shell do |sh|
    #     sh.execute "cd /home"
    #     # sh.execute "pwd"
    # end
end

puts "ok"