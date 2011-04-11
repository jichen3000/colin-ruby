puts :a_symbol.to_s
puts :a_symbol.id2name

puts :a_symbol.object_id
symbol_name = "a_symbol"
puts symbol_name.intern
puts symbol_name.intern.object_id