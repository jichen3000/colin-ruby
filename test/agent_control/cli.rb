require 'dprinter'
require 'optparse'
require 'drb'
#
# = cli.rb - CLI
#
# Author:: squall
# Copyright:: Copyright (c) 2008 MC soft
#
#
#
# The CLI class handles the command line,you can add other functions by add 'when'.
#
class CLI
	def run
		opts = OptionParser.new
		args = opts.parse(ARGV)
		case args[0]
		when 'start'
			puts "starting!"
			dprinter=Dprinter.new
			dprinter.start
			begin
                while dprinter.alive?
					sleep 3
                end
				puts "shut down!"
            rescue Interrupt
                dprinter.stop
            end
		when 'stop'
				dprinter=DRbObject.new(nil, 'druby://localhost:8899')
				#dprinter=Dprinter.new.get_service
				dprinter.stop
		end
	end
end

