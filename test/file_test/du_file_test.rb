class File
  def self.real_size(filename)
#    `du -sk #{filename} | awk '{print $1}'`.to_i*1024
    `du -sk #{filename}`.split(' ')[0].to_i
  end
end
filename = 'path_test.rb'
p "file_size : #{File.size(filename)}"
p "real file_size : #{File.real_size(filename)}"
