# using a Nested Closure in conjunction with a Function Sequence.
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
    def self.build &block
        builder = self.new
        block.call(builder)
        builder.content
    end
    def processor
        p = ProcessorBuilder.new
        yield p
        @content.processor = p.content
        self
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
        self
    end
    def i386
        @content.type = :i386
        self 
    end
    def speed arg
        @content.speed = arg
        self
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
# script
content = ComputerBuilder.build do |c|
    c.
    processor do |p|
        p.cores(2).
        i386.
        speed(2.2)
    end.
    disk do |d|
        d.size 150
    end.
    disk do |d|
        d.size(75).
        speed(7200).
        sata
    end 
end
p content

