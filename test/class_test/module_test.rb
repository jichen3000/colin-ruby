module A
  C = 'CC'
  AC = 'AC'
  def mm
    puts "A mm"
  end
  def aa
    puts "aa"
  end
end
module B
  C = 'CC'
  BC = 'BC'
  def mm
    puts "B mm"
  end
  def bb
    puts "bb"
  end
end
class AB
  include A  
  include B 
  def bb
    puts "AB bb"
  end 
end

ab = AB.new
puts AB::C
puts AB::BC
 ab.bb
 ab.mm
 ab.aa
