require 'yaml'

time = Time.now
YAML.dump(time,File.open(File.join(File.dirname(__FILE__),'time.yml'),'w'))
puts "ok"