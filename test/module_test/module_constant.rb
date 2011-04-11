module Comm
  AA = 'AA'
  BB = 'BB'
end

# 在类里面include，module中的常量，只有在实例方法中使用。
# 在类的静态里面include，module中的常量，只有在类的静态方法中使用。
class Jc
#  AA = "AAJC"
  include Comm
  def self.perform
    p AA
  end
  class << self
#    include Comm
    def perform
      p Comm::AA
    end
  end
  def i_perform
    p Comm::BB
  end
end


Jc.perform
Jc.new.i_perform