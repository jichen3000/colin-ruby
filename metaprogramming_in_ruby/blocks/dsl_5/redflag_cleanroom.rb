@blocks = []
def setup(&block)
    @blocks << block
end
def event(description, &block)
    env = Object.new
    @blocks.each do |setup_block|
        # block.call
        env.instance_eval &setup_block
    end
    # puts "ALERT: #{description}" if yield
    puts "ALERT: #{description}" if env.instance_eval &block
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
