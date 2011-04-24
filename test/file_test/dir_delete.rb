class DirDelete
  def self.perform(dir,delete_dir)
#    if not File.directory?(dir)
#    end
#    p "dir:#{dir}"
    Dir.open(dir).each do |item|
      dir_item = File.join(dir,item)
      if item!='.' and item!='..' and File.directory?(dir_item)
        if item == delete_dir
          delete_full_dir(dir_item)
          p "delete:(#{dir_item})"
        else
#          p "perform:#{dir_item}"
          perform(dir_item,delete_dir)
        end
#        p "other:#{item}"
      end
    end
  end
  def self.delete_full_dir(dir)
    Dir.open(dir).each do |item|
      dir_item = File.join(dir,item)
      if item!='.' and item!='..' 
        if File.directory?(dir_item)
          begin
            Dir.delete(dir_item)
          rescue SystemCallError => e
            delete_full_dir(dir_item)
          end
        else
          File.delete(dir_item)
        end
      end
    end
    Dir.delete(dir)
  end
end

dir = "D:/tmp/three"
DirDelete.perform(dir,'.svn')
p 'ok'
#select greatest(col1,col2) from table;least