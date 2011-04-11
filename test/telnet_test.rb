require 'net/telnet'
begin
	tn =  Net::Telnet::new('Host' => '130.36.21.87', "Waittime" => 0.1,
		"Timeout"=> 10,"Prompt"=> /[$>:#]/n,"Output_log"=>'telnet.log') { |str| print str }
#	tn =  Net::Telnet::new('Host' => '172.16.4.32', 
#		"Waittime" => 2,"Timeout"=> 40,"Prompt"     => /[$>:]/n) { |str| print str }
#	puts 'jjcjcjcjcjcjc'
#	tn.waitfor("Match"=>/login/){ |str| print "w 1";print str }
		tn.login("Name"=>"root","Password"=>"rootmc") { |str| print str }
#	tn.cmd("oracle"){ |str| print str }
#	tn.cmd("String"=>"oracle", "Waittime" => 2){ |str| print "in login";print str }
#	tn.cmd("String"=>"oracle", "Waittime" => 2)
#	tn.waitfor("Match"=>/^Password/){ |str| print "w login";print str }
#	tn.cmd("String"=>"oracle", "Timeout" => 40){ |str| print "in pass2";print str }
#	tn.cmd("oracle", "Timeout" => 40){ |str| print str }
#	tn.login('oracle','oracle') { |str| print str }
	tn.cmd("String" => "ls", "Timeout" => 5){|str| print "in ls";print str} 
	tn.cmd("date") { |str| print str }
	
#	puts 'jjcjcjcjcjcjc'
	
#	tn.cmd('root')  { |str| print str }
#		sleep(3)
#		puts 'jdksfk'
#	tn.cmd("String"=>'rootmc')  { |str| print str }
#	tn.waitfor
#	tn.cmd("date") { |str| print str }
#	tn.waitfor
#	tn.cmd('Username'=>'root')
#	tn.cmd('Password'=>'rootmc')
#	telnet.waitfor(/login\Z/)
	tn.cmd("uname") { |str| print str }
	rid = "wpgl"
	tn.cmd("rsh #{rid}") { |str| print str }
	tn.cmd("hostname") { |str| print str }
#	tn.cmd("rsh wpgl")  { |str| print str }
#	tn.waitfor
#	tn.close { |str| print str }
	tn.cmd("exit") { |str| print str }
#	tn.close { |str| print str }
ensure
#	tn.cmd("rsh wpgl")  { |str| print str }
	tn.cmd("date") { |str| print str }
	tn.close { |str| print str }
end
