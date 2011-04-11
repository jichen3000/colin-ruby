require 'pp'
# 说明：
# 在Array中的uniq和uniq!方法，不会根据Objcet#eql?或equal?或==方法来删除。
# 只会根据对象的hash值来删除。
# 在下面提供了uniq_by_sort_and_eql?方法。不过要对象提供eql?方法，同时数组要先排序。
class Array
  def uniq_by_sort_and_eql?
    old_item = nil
    i = self.size
    while i >= 0
      cur_item = self[i]
      if old_item!=nil and cur_item.eql?(old_item)
        self.delete_at(i)
      end
      old_item = cur_item
      i -= 1
    end
    self
  end
end
class A
  attr_reader :a1, :a2, :a3
  def initialize(a1,a2,a3)
    @a1 = a1
    @a2 = a2
    @a3 = a3    
  end
  def eql?(other)
    puts "eql?"
    @a1 == other.a1 and @a2 == other.a2 and @a3 == other.a3
  end
  def equal?(other)
    puts "eql?"
    @a1 == other.a1 and @a2 == other.a2 and @a3 == other.a3
  end
#  def ==(other)
#    puts "=="
#    @a1 == other.a1 and @a2 == other.a2 and @a3 == other.a3
#  end
  def <=> (other)
#    puts "<=>"
    if @a1 > other.a1
      return 1
    elsif @a1 == other.a1
      if @a2 > other.a2
        return 1
      elsif @a2 == other.a2
        if @a3 > other.a3
          return 1
        elsif @a3 == other.a3
          return 0
        end
      end
    end
    -1
  end
end

a_arr = Array.new
aa1 = A.new(1,2,3)
aa2 = A.new(1,1,3)
aa3 = A.new(1,2,3)
aa4 = A.new(1,5,3)
a_arr << aa2
a_arr << aa2
a_arr << aa4
a_arr << aa2
a_arr << aa1
a_arr << aa3
pp a_arr
require 'set'
p "set:"
p a_arr.to_set
a_arr.sort!
a_arr.uniq_by_sort_and_eql?
pp a_arr


#pp a_arr.uniq!
#pp a_arr
pp aa1 == aa3
