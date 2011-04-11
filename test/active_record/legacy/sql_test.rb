require 'legacy_base_conn'

ins = ActiveRecord::Base.connection.insert("insert into mc$dr_sub_system"+
  " (sub_id,name,status) values (11,'s11','C') ")
puts "ins : #{ins.to_s}"

upd = ActiveRecord::Base.connection.update("update mc$dr_sub_system"+
" set status='U' where sub_id=11 ")
puts "upd : #{upd.to_s}"

sel = ActiveRecord::Base.connection.select_all("select * from mc$dr_sub_system"+
  " where sub_id>8 ")
sel.each do |item|
  p item
  p item['name']
end

del = ActiveRecord::Base.connection.delete("delete mc$dr_sub_system"+
  " where sub_id>9 ")
puts "del : #{del.to_s}"
