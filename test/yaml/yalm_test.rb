require 'yaml'
require 'pp'

class ConfigTest
	attr_reader :v1, :v2, :v3
	def initialize(v1,v2,v3)
		@v1 = v1
		@v2 = v2
		@v3 = v3
	end
end
class Config2
	attr_reader :v4, :v5, :v6
	def initialize(v4,v5,v6)
		@v4 = v4
		@v5 = v5
		@v6 = v6
	end
end

def gen_yamlfile(filename)
	ct = ConfigTest.new('jc',true,3)
	c2 = Config2.new('jc01',nil,7)
	file = File.new(filename,'w')
	YAML.dump(ct,file)
	YAML.dump(c2,file)
	file.close
end
def gen_yamlfile2(filename)
	ct = 100
	YAML.dump(ct,File.open(filename,'w'))
end
def load_from_yamlfile(filename)
	r,r2 = YAML.load(File.open(filename))
	pp r
	pp r.v1,r.v2,r.v3
	pp r.v1.class,r.v2.class,r.v3.class
	pp r2
end
def load_from_yamlfile2(filename)
	r = YAML.load(File.open(filename))
	pp r
end

filename = 'config.yaml'
gen_yamlfile2(filename)
#load_from_yamlfile2(filename)

puts 'ok'