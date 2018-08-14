require 'net/ssh/session'

# Initialize a new connection
# session = Net::SSH::Session.new("qa-host", "root", "fortinet")
# session.open
# result =  session.run("pwd")
# puts result.output
# session.run("cd /home")
# result =  session.run("pwd")
# puts result.output


# session = Net::SSH::Session.new("10.160.13.29", "admin")
# session.open()
# result =  session.run("config vdom")
# puts result.output
# result =  session.run("edit root")
# puts result.output

session = Net::SSH::Session.new("qa-host", "root", :password=>'fortigate')
session.open()
result =  session.run("cd /home")
puts result.output
result =  session.run("pwd")
puts result.output

# Net::SSH::start("qa-host", "root", :password=>'fortigate') do |ssh|
#     ssh.shell do |bash|
#         process = bash.execute! 'cd /home'
#         puts "some"
#         puts process
#         output = ""
#         process.on_output do |a, b|
#           output += b
#           puts output
#         end
#         process = bash.execute! 'pwd'
#         puts "some"
#         puts process
#         process.on_output do |a, b|
#           output += b
#         end
#         bash.wait!
#         bash.execute! 'exit'
#     end
# end


# require 'net/ssh'
# require 'net/ssh/shell'
# Net::SSH::start("qa-host", "root", :password=>'fortigate') do |ssh|
#   ssh.shell do |sh|
#     p = sh.execute "cd /usr/local"
#     # puts p.output
#     p = sh.execute "pwd"
#     puts p.output
#     # sh.execute "export FOO=bar"
#     # sh.execute "echo $FOO"
#     # p=sh.execute "grep dont /tmp/notexist"
#     # puts "Exit Status:#{p.exit_status}"
#     # puts "Command Executed:#{p.command}"
#   end
# end