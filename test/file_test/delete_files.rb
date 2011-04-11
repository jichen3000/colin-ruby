
def delete_same_name_files(delete_dir,source_dir)
  puts "delete_dir:#{delete_dir}"
  puts "source_dir:#{source_dir}"
  Dir.open(source_dir).each do |cur_file_name|
    if cur_file_name != "." and cur_file_name != ".."
#      puts "cur_file_name:#{cur_file_name}"
      file_path = File.join(delete_dir,cur_file_name)
      if File.exist?(file_path)
        File.delete(file_path)
        puts "had deleted file: #{file_path}"
      end
    end
  end
end

delete_same_name_files(ENV['MEGATRUST_BIN_HOME'],ENV['MEGATRUST_SHELL_HOME'])
