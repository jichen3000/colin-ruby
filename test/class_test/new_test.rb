# ruby 中不支持将initialize私有化
class Colin
  private 
  def initialize
    p "ini"
  end
#  def put_jc
#    p "jc"
#  end
end


c = Colin.new
c.put_jc
p "ok"