require File.join(File.dirname(__FILE__),'gen_model_test')

def file_generate(class_name)
gen = GenModelTest.new(class_name) 
ruby_test_path='D:\work\workspace\megatrust\megatrust-web\test\unit'
ruby_filename = gen.gen_rb_test_file(ruby_test_path)
yml_test_path = 'D:\work\workspace\megatrust\megatrust-web\test\fixtures'
yml_filename = gen.gen_yml_file(yml_test_path)
model_path = 'D:\work\workspace\megatrust\megatrust-web\app\models'
model_filename = gen.gen_model_file(model_path)
puts ruby_filename+" has generated!" if ruby_filename
puts yml_filename+" has generated!" if yml_filename
puts model_filename+" has generated!" if model_filename
end

#class_name_arr = ['ForwardActivity','SearchActivity','ResolveActivity',
#  'LevelActivity','ActorActivity','ReportActivity']
class_name_arr = ['IssueMail']
class_name_arr.each do |class_name|
  file_generate(class_name)
end

puts "ok"

