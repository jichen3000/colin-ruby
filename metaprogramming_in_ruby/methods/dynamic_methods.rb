# compire to the method_missing, it will define method at first time,
# so it cannot respond for other codes change. it has to stop and run again.
# the method_missing is more like dynamic way.
class Computer
    def initialize(computer_id, data_source)
        @id = computer_id
        @data_source = data_source
        data_source.methods.grep(/^get_(.*)_info$/) { Computer.define_component $1 }
    end
    def self.define_component(name) 
        define_method(name) do
            info = @data_source.send "get_#{name}_info", @id 
            price = @data_source.send "get_#{name}_price", @id 
            result = "#{name.capitalize}: #{info} ($#{price})" 
            return "* #{result}" if price >= 100
            result
        end 
    end
    # define_component :mouse
    # define_component :cpu
    # define_component :keyboard
end
