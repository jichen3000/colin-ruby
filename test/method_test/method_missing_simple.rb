class Colin
    def self.my_puts(name)
        p name
    end
    def self.method_missing(method_name, *args, &block)
        if result = /^is_(\w+)/.match(method_name.to_s)
            puts "args:", args
            puts args[0]
            my_puts(result[1])
        end
        super
    end
end

Colin.is_mm("jc",22)
Colin.mm()