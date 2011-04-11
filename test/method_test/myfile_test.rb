class RawFile
  def self.rawfile?(filename)
    p "File.extname(filename) : #{File.extname(filename)}"
    File.extname(filename) == '.raw'
  end  
  def initialize(filename,mode)
    @file = File.new(filename,mode)
  end 
  def path
    @file.path
  end 
end

RAW_FILE = 'RAW'
NORMAL_FILE = 'NORMAL'
class MultiFile
  attr_reader :type
  def initialize(filename,mode)
    if File.exist?(filename) and RawFile.rawfile?(filename)
      @file = RawFile.new(filename,mode)
      @type = RAW_FILE
      @file_class = RawFile
    else
      @file = File.new(filename,mode)
      @type = NORMAL_FILE
      @file_class = File 
    end
    p @file_class
  end
  # for class method 
  def self.method_missing(id,*args)
    if File.respond_to?(id)
      result = File.send(id,*args)
    end
    result
  end
  # for object method
  def method_missing(id,*args)
#    p id
#    puts "@file.#{id}"
    if @file.respond_to?(id)
      result = @file.send(id,*args)
    end
    result
  end
  # for object respond_to?
  def respond_to?(id)
    @file.respond_to?(id)    
  end
  def self.respond_to?(id)
    p @file_class
    @file_class.respond_to?(id)    
  end
  private
  def normal?
    @type == NORMAL_FILE
  end
end

#p File.
filename = 'd:\findme.txt'
mf = MultiFile.new(filename,'r')
p "file path: #{mf.path}"
p "file type: #{mf.type}"
p MultiFile.exist?(filename)
p "mf.respond_to?(:path) : #{mf.respond_to?(:path)}"
p "MultiFile.respond_to?('exist?') : #{MultiFile.respond_to?('exist?')}"
p 'ok'

filename = 'd:\test.raw'
rf = MultiFile.new(filename,'r')
p "file path: #{rf.path}"
p "file type: #{rf.type}"
p "mf.respond_to?(:path) : #{mf.respond_to?(:path)}"
p "MultiFile.respond_to?('exist?') : #{MultiFile.respond_to?('exist?')}"
