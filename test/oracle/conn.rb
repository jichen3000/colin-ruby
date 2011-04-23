require 'oci8'
ors = "wzdbra/wzdbra@drb"
conn = OCI8.new(ors)
conn.logoff
p "ok"