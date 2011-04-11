# ʵ�ַ�����̬����

class TFunc
  def initialize()
    @t_att = 'jc'
  end
  def read_block(other)
    puts "@t_att: #{@t_att}, other: #{other}"
  end
end

class TB
  def trans(func)
    func.call('mm')
  end
end

t_func = TFunc.new
t_b = TB.new
t_b.trans(t_func.method(:read_block))
p t_b.method(:trans).arity
