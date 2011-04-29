=begin
  * Name: Jack Colin
  * Description   
  * Author:
  * Date:
  * License:
=end



# alias 定义 define_method
def 召唤 家丁  
  case 家丁  
  when '阿福', '旺财'  
    puts "……少爷，我系#{家丁}……"  
  else  
    puts '……(一段短短的沉默，然后一段长长的沉默)'  
  end  
end  
家丁甲, 家丁乙 = %w[阿福 旺财]  
召唤 家丁甲
召唤 家丁乙

def 如果 条件, 真块, 假块
  条件 ? 真块.call : 假块.call  
end  
def 那么 &块  
  块  
end  
def 否则 &块  
  块  
end  
def 问三围  
  puts '小……小柠檬？！小蜜瓜？！不想活了？！'  
end  
  
def 讲再见  
  puts '不是讲好一小时见血任做吗？你跑不掉的……hehehe……'  
end  

[true, false].each {|女的|  
  如果 女的, 那么{问三围}, 否则{讲再见}  
}  