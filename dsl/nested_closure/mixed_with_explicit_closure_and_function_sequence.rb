# Function Sequence with Explicit Closure Arguments
# from DSL NO. 38 Chapter 

$:.unshift File.dirname(__FILE__)

Computer = Struct.new(:disks, :processor)
Processor = Struct.new(:cores, :type, :speed)
Disk = Struct.new(:size, :interface, :speed)

class ComputerBuilder
    attr_reader :content
    def initialize
        @content = Computer.new([])
    end
    def self.build
        builder = self.new
        yield builder
        builder.content
    end
    def processor &block
        p = ProcessorBuilder.new
        yield p
        @content.processor = p.content
    end
    def disk
        currentDisk = DiskBuilder.new
        yield currentDisk
        @content.disks << currentDisk.content
        self
    end

end
class ProcessorBuilder
    attr_reader :content
    def initialize
        @content = Processor.new
    end
    def cores arg
        @content.cores = arg
    end
    def i386
        @content.type = :i386
    end
    def speed arg
        @content.speed = arg
    end 
end
class DiskBuilder
    attr_reader :content
    def initialize
        @content = Disk.new
    end
    def size arg
        @content.size = arg
        self
    end
    def sata
        @content.interface = :sata
        self 
    end
    def speed arg
        @content.speed = arg
        self
    end
end
content = ComputerBuilder.build do |c|
    c.processor do |p|
        p.cores 2
        p.i386
        p.speed 2.2
    end
    c.disk do |d|
        d.size 150
    end
    c.disk do |d|
        d.size 75
        d.speed 7200
        d.sata
    end 
end
p content