@blocks = []
def setup(&block)
    @blocks << block
end
def event(description)
    @blocks.each do |block|
        block.call
    end
    puts "ALERT: #{description}" if yield
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            
            -> {load 'events.rb'}.must_output(
                    "Setting up sky\n"+
                    "Setting up mountains\n" +
                    "ALERT: the sky is falling\n" +
                    "Setting up sky\n"+
                    "Setting up mountains\n" +
                    "ALERT: it's getting closer\n"+
                    "Setting up sky\n"+
                    "Setting up mountains\n" +
                    "")
        end
    end
end
