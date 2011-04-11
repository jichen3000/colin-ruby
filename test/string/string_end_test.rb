aString = <<END_OF_STRING
id
dbname
backset_id
blocks
block_size
completion_time
elapsed_seconds
is_flashback
flash_handle
flash_pieces
status
deleted
keep_untile
END_OF_STRING

arr = aString.split("\n")
arr.map!{|i| i.strip}
p arr.join(",")

e = %{
this is code.
   lets go.
}
puts e