require 'test/unit'

require File.join(File.dirname(__FILE__),'gen_model_test')

class TestGenModelTest < Test::Unit::TestCase
  def test_true
    assert(true)
  end
  def setup
    @gm = GenModelTest.new(
      'D:\work\workspace\colin-ruby\project\gen_model_test\genfile','Host')
  end
  def test_gen_rb_test_file
    if File.exist?('D:\work\workspace\colin-ruby\project\gen_model_test\genfile\host_test.rb')
      File.delete('D:\work\workspace\colin-ruby\project\gen_model_test\genfile\host_test.rb')
    end
    gen_file = File.open(@gm.gen_rb_test_file())
    test_file = File.open(File.join(File.dirname(__FILE__),"testfile/host_test_select.rb"))
    test_con = test_file.readlines
    gen_con = gen_file.readlines
    test_con.size.times do |i|
      assert_equal(test_con[i], gen_con[i])
    end
  end
  def test_gen_yaml_file
    if File.exist?('D:\work\workspace\colin-ruby\project\gen_model_test\genfile\host.yml')
      File.delete('D:\work\workspace\colin-ruby\project\gen_model_test\genfile\host.yml')
    end
    gen_file = File.open(@gm.gen_yaml_file())
    test_file = File.open(File.join(File.dirname(__FILE__),"testfile/host.yml"))
    test_con = test_file.readlines
    gen_con = gen_file.readlines
    test_con.size.times do |i|
      assert_equal(test_con[i], gen_con[i])
    end
  end
  def test_gen_model_file
    if File.exist?('D:\work\workspace\colin-ruby\project\gen_model_test\genfile\host.rb')
      File.delete('D:\work\workspace\colin-ruby\project\gen_model_test\genfile\host.rb')
    end
    gen_file = File.open(@gm.gen_model_file())
    test_file = File.open(File.join(File.dirname(__FILE__),"testfile/host.rb"))
    test_con = test_file.readlines
    gen_con = gen_file.readlines
    test_con.size.times do |i|
      assert_equal(test_con[i], gen_con[i])
    end
  end
  
end