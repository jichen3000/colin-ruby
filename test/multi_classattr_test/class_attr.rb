class ClassAttr
	class << self
		def add_item(item)
#			@@arr = Array.new if !@arr
			@@arr ||= Array.new
			@@arr << item
		end
		def get_arr
			@@arr
		end
	end
end