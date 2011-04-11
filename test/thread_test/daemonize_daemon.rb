require 'tempfile'
require 'daemonize'
include Daemonize            # Import Daemonize::daemonize into this namespace

puts 'About to daemonize.'
daemonize                    # Now you're a daemon process!
log = Tempfile.new('daemon.log')
loop do
  log.puts "I'm a daemon, doin' daemon things."
  log.flush
  sleep 5
end
