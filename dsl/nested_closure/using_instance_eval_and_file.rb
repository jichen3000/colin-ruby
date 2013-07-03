# Using Instance Evaluation
# from DSL NO. 38 Chapter 

$:.unshift File.dirname(__FILE__)

Computer = Struct.new(:disks, :processor)
Processor = Struct.new(:cores, :type, :speed)
Disk = Struct.new(:size, :interface, :speed)

class ComputerBuilder
    attr_reader :content
    def load_file aFileName
        load(File.readlines(aFileName).join("\n"))
        @content
    end
    def load aStream
        instance_eval aStream
    end
    def computer
        yield
    end
    # def self.build &block
    #     builder = self.new
    #     builder.instance_eval &block
    #     return builder.content
    # end
    def initialize
        @content = Computer.new([])
    end
    def processor &block
        @content.processor = ProcessorBuilder.new.build(block)
    end
    def disk &block
        @content.disks << DiskBuilder.new.build(block)
    end
end

class ProcessorBuilder
    def build block
        @content = Processor.new
        instance_eval(&block)
        return @content
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
    def build block
        @content = Disk.new
        instance_eval(&block)
        return @content
    end
    def size arg
        @content.size = arg
    end
    def sata
        @content.interface = :sata
    end
    def speed arg
        @content.speed = arg
    end
end

p ComputerBuilder.new.load_file('computer.script')
