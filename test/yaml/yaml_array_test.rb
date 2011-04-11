require 'yaml'
require 'pp'


filename = File.join(File.dirname(__FILE__),'yaml_array_test.yaml')
puts 'dump'
a1 = 123
a2 = '45678'
#arr = [a1,a2]
file = File.new(filename,'w')
YAML.dump([a1,a2],file)
file.close

#puts "load"
#arr = YAML.load(File.open(filename,'r'))

pp [a1,a2]

puts 'ok'