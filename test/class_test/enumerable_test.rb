class MultiArray
  include Enumerable

  def initialize(*arrays)
    @arrays = arrays
  end

  def each
    @arrays.each { |a| a.each { |x| yield x } }
  end
end

ma = MultiArray.new([1, 2], [3], [4])
ma.collect                                       
ma.detect { |x| x > 3 }                       
ma.map { |x| x ** 2 } 
ma.each_with_index { |x, i| puts "Element #{i} is #{x}" }