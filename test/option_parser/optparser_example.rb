require 'optparse'
require 'ostruct'

VERSION = "0.0.1"

def ayalysis_options_by_hash(args)
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options[:verbose] = v
      end
  end.parse!(args)
    return options
end

def analysis_options(args)
    options = OpenStruct.new
    options.library = []

    opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: ruby optparser_example.rb [options]"

        opts.separator ""
        opts.separator "Specific options:"

        # Mandatory argument.
        opts.on("-r", "--require LIBRARY",
                "Require the LIBRARY before executing your script") do |lib|
          options.library << lib
        end
        opts.on("--ip IP",
                "ip and ports, '1.1.1.1:23,2.2.2.2:24'") do |ip_str|
          options.ip_str = ip_str
        end
        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        # Another typical switch to print the version.
        opts.on_tail("-v", "--version", "Show version") do
          puts "current version is: #{VERSION}"
          exit
        end
    end
    opt_parser.parse!(args)
    return options
end

p ARGV
if ARGV.size == 1 and not ARGV.first.strip.start_with?("-")
    ARGV.unshift("--ip")
end
p ARGV
options = analysis_options(ARGV)
p options
p ARGV
