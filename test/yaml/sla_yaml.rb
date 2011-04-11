require 'yaml'


map = YAML.load(File.open('test/yalm/sla_config.yaml'))
p map

p "ok"