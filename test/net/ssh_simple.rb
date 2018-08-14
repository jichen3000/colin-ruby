require 'net/ssh/simple'
require 'testhelper'

# Net::SSH.start('qa-host','root',:password=>'fortigate') do |ssh|
# end

Net::SSH::Simple.sync do
  r = ssh('qa-host', 'cd /home', {:user => 'root', :password=>'fortigate'})
  puts r.class
  puts r.stdout #=> "Hello World."
  r = ssh('qa-host', 'pwd', {:user => 'root', :password=>'fortigate'})
  puts r.stdout #=> "Hello World."
  # scp_put 'example2.com', '/tmp/local_foo', '/tmp/remote_bar'
  # scp_get 'example3.com', '/tmp/remote_foo', '/tmp/local_bar'
end