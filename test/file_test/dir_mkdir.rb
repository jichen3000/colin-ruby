def create_if_missing(dir_name)
    Dir.mkdir(dir_name) unless File.directory?(dir_name)
end
file_name = 'D:/tmp/1/1.log' 
dir_name = File.dirname(file_name)
p "dir_name:#{dir_name}"
create_if_missing(dir_name)
p "ok"