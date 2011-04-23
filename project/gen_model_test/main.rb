require File.join(File.dirname(__FILE__),'gen_model_test')

class_name = 'Database'
path='D:\work\workspace\megatrust\megatrust-web\test\unit'
filename = GenModelTest.new.gen_file(path,class_name)
puts filename+" has generated!" if filename
puts "ok"
