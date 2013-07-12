# this will support comman parser.

module TokenType
    def self.included(base)
        base.extend(ClassMethods)
    end
    module ClassMethods
        @@token_type_list = []
        def create(name, re, is_output: true, get_group_num: 0)
            @@token_type_list.push({:name=>name,
                :regexp=>re,
                :is_output=>is_output,
                :get_group_num=>get_group_num})
            @@token_type_list.last
        end
        def get_token_type_list()
            @@token_type_list
        end
        def get_token_type(name)
            @@token_type_list.detect {|item| item[:name]==name}
        end
        def get_token_type_regexp(name)
            get_token_type(name)[:regexp]
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
        def gen_new_token?(token_type, str)
            find_flag = false
            new_token = nil
            if reg_result = token_type[:regexp].match(str)
                if token_type[:is_output]
                    new_token = {:payload=>reg_result[token_type[:get_group_num]], 
                        :type_name=>token_type[:name]}
                end
                find_flag = true
                str = $'
            end
            [find_flag, new_token, str]
        end
        def tokenize(content)
            token_list = []
            str = content
            find_flag = false
            while str.length > 1 do
                get_token_type_list.each do |token_type|
                    find_flag, new_token, str = gen_new_token?(token_type, str)
                    token_list.push(new_token) if new_token
                    break if find_flag
                end
                if not find_flag
                    raise "error: cannot match for "+str
                end
            end
            token_list
        end
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

end