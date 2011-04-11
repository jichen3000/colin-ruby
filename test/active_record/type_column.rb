#当表格中有字段名字为“type”时，可以通过下面的方法来解决。

require "activerecord"
@@config = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
class ProductDB < ActiveRecord::Base
  p @@config['database3']
  establish_connection @@config['database3']
end

class ArchiveDest < ProductDB
  set_inheritance_column(:jc)
#  set_inheritance_column(:something_else)
  self.table_name='v$archive_dest'
  def type=(ntmp)
    write_attribute("type",ntmp)
  end
  def type
    return read_attribute("type")
  end
#  self.table_name='v$database'
end

#p ArchiveDest.find_by_sql("select * from v$archive_dest")
ar = ArchiveDest.find_by_dest_id(1)
p ar
p ar.type
p "ok"


