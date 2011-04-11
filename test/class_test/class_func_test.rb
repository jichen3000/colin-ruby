# �෽����ʹ��
# ע�������ʹ��
class ClassFuncTest
  @@is_re = false
  def self.set_attr(is_re)
    @@is_re = is_re
  end
  def self.perform
    puts " is_re:"+@@is_re.to_s
  end
end

ClassFuncTest.perform
ClassFuncTest.set_attr(true)
ClassFuncTest.perform
puts 1.class.to_s == 'Fixnum'
