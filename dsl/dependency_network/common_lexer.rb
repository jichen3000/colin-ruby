# this will support comman parser.

module TokenType
    def self.included(base)
        base.extend(ClassMethods)
    end
    module ClassMethods
        @@all = []
        def create(name, re, is_output: true, get_group_num: 0)
            @@all.push({:name=>name,
                :regexp=>re,
                :is_output=>is_output,
                :get_group_num=>get_group_num})
            @@all.last
        end
        def all()
            @@all
        end
        def get(name)
            @@all.detect {|item| item[:name]==name}
        end
        def is_type(type_name, token)
            type_name.upcase().to_sym() == token[:type_name]
        end
        def method_missing(method_name, *args, &block)
            if result = /^is_(\w+)/.match(method_name.to_s)
                return is_type(result[1], args[0])
            end
            super
        end

        def tokenize(content)
            token_list = []
            str = content
            find_flag = false
            while str.length > 1 do
                all.each do |token_type|
                    # p "token_type:", token_type
                    if reg_result = token_type[:regexp].match(str)
                        if token_type[:is_output]
                            token_list.push({:payload=>reg_result[token_type[:get_group_num]], 
                                :type_name=>token_type[:name]})
                        end
                        # p "current:",$&
                        # p "next:",$'
                        find_flag = true
                        str = $'
                        break
                    end
                end
                if not find_flag
                    raise "error: cannot match for "+str
                end
            end
            token_list
        end
    end
end


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
    class MyTokenType
        include TokenType
    end
    describe MyTokenType do
        it "can judge the token type" do
            token = {:payload=>"identifier", :type_name=>:IDENTIFIER}
            MyTokenType.is_identifier(token).must_equal true

            MyTokenType.is_type(:IDENTIFIER, token).must_equal true
        end
    end
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