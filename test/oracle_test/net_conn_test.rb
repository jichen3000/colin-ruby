require 'oci8'

#conn = OCI8.new('colin','colin','//localhost:1521/colin')
conn = OCI8.new('mcdbra','mcdbra','//172.16.4.38:1555/drb')
conn.exec('select * from tab') do |line|
#  puts line.class
  puts line.join("\t")
end
