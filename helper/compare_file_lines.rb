class CompareFileLines
  
  def self.perform(filename1,filename2)
    cf = CompareFileLines.new(filename1,filename2)
    cf.do_it
  end
  def initialize(filename1,filename2)
    @lines1 = File.open(filename1,'r').readlines
    @lines2 = File.open(filename2,'r').readlines
    
    
  end
  def do_it
    @lines_1to2=list_dec_list(@lines1, @lines2)
    write_lines('1to2.txt', @lines_1to2)
    @lines_2to1=list_dec_list(@lines2, @lines1)
    write_lines('2to1.txt', @lines_2to1)
#    @lines_1to2=list_dec_list(@lines1, @lines2)
  end
  def write_lines(filename,lines)
    file = File.new(filename,"w")
    lines.each do |line|
      file << (line)
    end
  end
  def list_dec_list(lines1,lines2)
    r = []
    lines1.each do |line1|
      if not lines2.include?(line1)
        r << line1
      end
    end
    r
  end
end

CompareFileLines.perform('t1.txt','t2.txt')
p "ok"