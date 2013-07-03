# using a Nested Closure in conjunction with a Function Sequence.
# from DSL NO. 38 Chapter 

$:.unshift File.dirname(__FILE__)

Computer = Struct.new(:disks, :processor)
Processor = Struct.new(:cores, :type, :speed)
Disk = Struct.new(:size, :interface, :speed)
class ComputerBuilder
    def computer &block
        @result = Computer.new
        @result.disks = []
        block.call
    end
    def processor &block
        @result.processor = Processor.new
        block.call
    end
    def cores arg
        @result.processor.cores = arg
    end
    def i386
        @result.processor.type = :i386
    end
    def processorSpeed arg
        @result.processor.speed = arg
    end
    def disk
        @result.disks << Disk.new
        yield 
    end
    def size arg
        @result.disks.last.size = arg
    end
    def sata
        @result.disks.last.interface = :sata
    end
    def diskSpeed arg
        @result.disks.last.speed = arg
    end
    def content
        @result
    end
end
# script
class BasicComputerBuilder < ComputerBuilder
    def doBuild
        computer do
            processor do
                cores 2
                i386
                processorSpeed 2.2
            end 
            disk do
                size 150 
            end
            disk do
                size 75
                diskSpeed 7200
                sata 
            end
        end 
    end
end

builder = BasicComputerBuilder.new
builder.doBuild
p builder.content