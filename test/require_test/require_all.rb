if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            __FILE__.pt
            Dir[File.join(File.dirname(__FILE__), 'all_objects', 
                '*.rb')].each {|file| require file }
            aa.must_equal("aa")
        end
    end
end
