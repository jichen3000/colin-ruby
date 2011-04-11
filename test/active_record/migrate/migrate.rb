require 'rubygems'
require_gem 'activerecord'

if ARGV[0] =~ /VERSION=\d+/
version = ARGV[0].split('=')[1].to_i
else
version = nil
end
@logger = Logger.new $stderr
ActiveRecord::Base.logger = @logger
ActiveRecord::Base.colorize_logging = false
@config = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
ActiveRecord::Base.establish_connection(@config["development"])
ActiveRecord::Migrator.migrate("", version)