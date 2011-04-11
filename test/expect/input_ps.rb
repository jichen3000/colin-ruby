#
# sample program of expect.rb
#
#  by A. Ito
#
#  This program reports the latest version of ruby interpreter
#  by connecting to ftp server at ruby-lang.org.
#
require 'pty'
require 'expect'

  p "1"
PTY.spawn("sqlplus") do |r_f,w_f,pid|
  p "2"
  w_f.sync = true
  
  $expect_verbose = false
  r_f.expect(/user-name: /) do |output|
    p "3"
    puts output[0]
    w_f.print "drb/drbmc@dbtest\n"
    puts output[0]
    p "4"
  end
  
  3.times do |index|
    r_f.expect("SQL>  ") do |output|
      p "5"
      puts output[0]
      p "6"
      w_f.print "select * from tab;\n"
    end
    
    r_f.expect(/>/) do |output|
      p "7"
      puts output[0]
      p "8"
    end
  end
  
  begin
    w_f.print "quit\n"
  rescue
  end
end

p "ok"
