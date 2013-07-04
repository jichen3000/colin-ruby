# from DSL chapter 45


class DiscountRulePolisher
    def polish aString
        @buffer = aString
        process_percent
        process_value_at_least
        process_if
        replace_spaces
        @buffer
    end

    def process_percent
        @buffer = @buffer.gsub(/\b(\d+)%\s+/, 'percent(\1) ')
    end


    def process_value_at_least
        @buffer = @buffer.gsub(/\bvalue\s+at\s+least\s+\$?(\d+)\b/, 
            'minimum(\1)')
    end
    def process_if
        @buffer = @buffer.gsub(/\bif\b/, 'when')
    end
    def replace_spaces
        @buffer = @buffer.strip.gsub(/ +/, ".")
    end
end






str = '3% if  value at least $30000'
p DiscountRulePolisher.new.polish(str)
