def map_add_prefix(str,prefix,split_str=",")
	arr = str.split(split_str)
	arr.map! {|i| prefix+i}
	arr.join(split_str)
end

str = "name,thread#,sequence#,first_change#,next_change#,first_time"
new_str = "select #{map_add_prefix(str,'a.',',')} from"
p new_str