require 'oci8'

conn = OCI8.new("mcdbra/mcdbra@drb")
#conn = OCI8.new("megatrust/megatrust@megatrust")
minscn = 
  conn.exec('select min(checkpoint_change#) from mc$dr_datafile').fetch[0]
count = conn.exec("update mc$dr_backuparchivelog set applyed='Y' "+
  "where applyed='N' and backuped='Y' and next_change<#{minscn}")
conn.logoff
p "had run!(minscn=#{minscn}, update count=#{count})"
