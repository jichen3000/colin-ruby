require 'oci8'

conn = OCI8.new('colin/colin@colin')
#conn.exec('select * from tab') do |line|
#  puts line.join("\t")
#end
begin
  conn.exec('select * from jc')
rescue OCIError => e  
  puts e.message
  if e.code == 941
    p e.code
  else
    raise e
  end
end
conn.logoff

