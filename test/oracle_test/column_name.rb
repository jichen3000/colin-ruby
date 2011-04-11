require 'oci8'
ors = "mcdbra/mcdbra@drb"
conn = OCI8.new(ors)
p conn
conn.exec('select * from tab') do |line|
  puts line.join("\t")
end
conn.logoff
