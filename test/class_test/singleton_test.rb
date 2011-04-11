require "singleton"

class Colin
  include Singleton
  def to_s
    "c"
  end
end

c = Colin.instance
Colin.new
puts c