require 'test/unit'

require File.join(File.dirname(__FILE__),'gen_model_test')

class TestGenModelTest < Test::Unit::TestCase
  def test_true
    assert(true)
  end
  def setup
    @gen_path  = 'D:\work\workspace\colin-ruby\project\gen_model_test\genfile'
    @test_path = 'D:\work\workspace\colin-ruby\project\gen_model_test\testfile'
    @gm = GenModelTest.new('Host')
  end
  def test_class_name_to_instance_name
    assert_equal("class_name",@gm.class_name_to_instance_name("ClassName"))
  end
  def test_instance_name_to_class_name
    assert_equal("ClassName",@gm.instance_name_to_class_name("class_name"))
  end
  def test_gen_rb_test_file
    gen_file_name = 'host_test.rb'
    check_gen_file(File.join(@gen_path,gen_file_name))
    compare_file(@gm.gen_rb_test_file(@gen_path),
      File.join(@test_path,gen_file_name))
  end
  def test_gen_yaml_file
    gen_file_name = 'host.yml'
    check_gen_file(File.join(@gen_path,gen_file_name))
    compare_file(@gm.gen_yml_file(@gen_path),
      File.join(@test_path,gen_file_name))
  end
  def test_gen_model_file
    gen_file_name = 'host.rb'
    check_gen_file(File.join(@gen_path,gen_file_name))
    compare_file(@gm.gen_model_file(@gen_path),
      File.join(@test_path,gen_file_name))
  end
  private
  def check_gen_file(path)
    if File.exist?(path)
      File.delete(path)
    end
  end 
  def compare_file(gen_file_path,test_file_path)
    gen_file = File.open(gen_file_path)
    test_file = File.open(test_file_path)
    test_con = test_file.readlines
    gen_con = gen_file.readlines
    test_con.size.times do |i|
      assert_equal(test_con[i], gen_con[i])
    end
  end
  
  
end