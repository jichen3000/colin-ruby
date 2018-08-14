module StringExtensions
    refine String do |variable|
        def to_alphanumeric
            gsub(/[^\w\s]/,"")
        end
    end
end

using StringExtensions
puts "my *1st* refinement!".to_alphanumeric