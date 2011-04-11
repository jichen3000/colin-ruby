require 'parseconfig'
config_filename = File.join(File.dirname(__FILE__),'simple.config')
c = ParseConfig.new(config_filename)
p c
p c.params['mm']
p "ok"