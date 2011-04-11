require 'oci8'
ors = "strmadmin/strmadmin@100sadmin"
conn = OCI8.new(ors)
conn.logoff
p "ok"