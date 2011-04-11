require 'activerecord'

class System < ActiveRecord::Base
  self.table_name="mc$dr_system"
end
def save_to_yaml(filename)
  ActiveRecord::Base.establish_connection(
    :adapter  => "oracle_enhanced",
    :encoding => "utf-16",
    :database => "28drb",
    :username => "mcdbra3",
    :password => "mcdbra3",
    :host     => "28drb"
  )
  a = System.find(:first)
  p a
  YAML.dump(a,File.open(filename,'w'))
end
def load_from_yaml(filename)
  YAML.load(File.open(filename))
end
filename = 'test/active_record/nodb/system.yaml'
a load_from_yaml(filename)
p a
#save_to_yaml(filename)
p "ok"


