class TokenBuffer
    def initialize(token_list, current_pos=0)
        @token_list = token_list
        @current_pos = current_pos
    end
    def get_current_position()
        @current_pos
    end
    def next_token()
        raise "The list has been out of size!" if @current_pos >= @token_list.size()
        @token_list[@current_pos]
    end
    def pop_token()
        @current_pos += 1
    end
    def reset_current_position(pos)
        @current_pos = pos
    end
    def done?()
        return @current_pos >= @token_list.size()
    end
    def create_next_copy(pos_interval: 1)
        TokenBuffer.new(@token_list, @current_pos+pos_interval)
    end
    def size()
        @token_list.size()
    end
    def ==(other)
        @token_list == other.instance_variable_get('@token_list') and 
            @current_pos == other.get_current_position
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe TokenBuffer do
        before do
            token_list = [{:payload=>"events", :type_name=>:EVENT}, 
                {:payload=>"doorClosed", :type_name=>:IDENTIFIER}, 
                {:payload=>"D1CL", :type_name=>:IDENTIFIER}, 
                {:payload=>"end", :type_name=>:END}]

            @token_buffer = TokenBuffer.new(token_list)
        end
        it "can be finished" do
            @token_buffer.size().times do 
                @token_buffer.next_token()
                @token_buffer.pop_token()
            end
            @token_buffer.done?.must_equal true
        end
        it "can be equaled!" do
            next_token_buffer = @token_buffer.create_next_copy()
            next_token_buffer.wont_equal @token_buffer
            @token_buffer.pop_token
            next_token_buffer.must_equal @token_buffer

        end
    end

end