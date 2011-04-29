# 调用张超的存储过程

require 'oci8'
# 28
conn = OCI8.new('mcdbra/mcdbra@drb')
# The file must in the same machine
file_path = '/oracle'
filename_str = 'txt_1000w.txt'
loit_table = 'loit1000w'
sql="create table #{loit_table}("+
"id number,opcode varchar2(8),afn varchar2(8),dba varchar2(8),block_count varchar2(8)"+
" )"
conn.exec(sql)
sql = "begin loit_table(2,'#{file_path}','#{filename_str}','#{loit_table}'); end;"
conn.exec(sql)
conn.logoff

p "ok"
# 9289813