
$:.unshift File.dirname(__FILE__)
require 'common_lexer'
class StateMachineTokenType
    include TokenType
    create(:EVENTS, /\A\s*(events)\s*/,get_group_num: 1)
    create(:CALLBACKS, /\A\s*(callbacks)\s*/,get_group_num: 1)
    create(:END, /\A\s*(end)\s*/,get_group_num: 1)
    create(:COMMENT, /\A\s*\#.*\s/,is_output:false)
    create(:IDENTIFIER, /\A\s*(\w+)\s*/,get_group_num: 1)
    create(:WHITESPACE, /\A\s+/,is_output:false)
end
if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'


    describe "tokenize" do
        it "can test regexp" do
            events_token_type = StateMachineTokenType.get_token_type(:EVENTS)
            events_str = "events \n      start "
            StateMachineTokenType.gen_new_token?(events_token_type,events_str).
                must_equal([true, {:payload=>"events", :type_name=>:EVENTS}, "start "])

            identifier_token_type = StateMachineTokenType.get_token_type(:IDENTIFIER)            
            identifier_str = "    before      start       log_proc "
            StateMachineTokenType.gen_new_token?(identifier_token_type,identifier_str).
                must_equal([true, {:payload=>"before", :type_name=>:IDENTIFIER}, "start       log_proc "])

            end_token_type = StateMachineTokenType.get_token_type(:END)            
            end_str = "    end "
            StateMachineTokenType.gen_new_token?(end_token_type,end_str).
                must_equal([true, {:payload=>"end", :type_name=>:END}, ""])

            comment_token_type = StateMachineTokenType.get_token_type(:COMMENT)            
            comment_str = " # for comment "
            StateMachineTokenType.gen_new_token?(comment_token_type,comment_str).
                must_equal([true, nil, ""])
        end
        it "can read file" do
            result = [
                 {:payload=>"events", :type_name=>:EVENTS},
                 {:payload=>"start", :type_name=>:IDENTIFIER},
                 {:payload=>"NIL", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"warn", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"yellow", :type_name=>:IDENTIFIER},
                 {:payload=>"panic", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"red", :type_name=>:IDENTIFIER},
                 {:payload=>"panic", :type_name=>:IDENTIFIER},
                 {:payload=>"yellow", :type_name=>:IDENTIFIER},
                 {:payload=>"red", :type_name=>:IDENTIFIER},
                 {:payload=>"calm", :type_name=>:IDENTIFIER},
                 {:payload=>"red", :type_name=>:IDENTIFIER},
                 {:payload=>"yellow", :type_name=>:IDENTIFIER},
                 {:payload=>"clear", :type_name=>:IDENTIFIER},
                 {:payload=>"red", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"clear", :type_name=>:IDENTIFIER},
                 {:payload=>"yellow", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"end", :type_name=>:END},
                 {:payload=>"callbacks", :type_name=>:CALLBACKS},
                 {:payload=>"before", :type_name=>:IDENTIFIER},
                 {:payload=>"start", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"start", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"before", :type_name=>:IDENTIFIER},
                 {:payload=>"warn", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"before", :type_name=>:IDENTIFIER},
                 {:payload=>"panic", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"before", :type_name=>:IDENTIFIER},
                 {:payload=>"calm", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"before", :type_name=>:IDENTIFIER},
                 {:payload=>"clear", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"warn", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"panic", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"calm", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"clear", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"after", :type_name=>:IDENTIFIER},
                 {:payload=>"anyevent", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"leave", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"leave", :type_name=>:IDENTIFIER},
                 {:payload=>"yellow", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"leave", :type_name=>:IDENTIFIER},
                 {:payload=>"red", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"yellow", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"red", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"enter", :type_name=>:IDENTIFIER},
                 {:payload=>"anystate", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"end", :type_name=>:END}]

            File.open("test.script") do |file|
                StateMachineTokenType.tokenize(file.readlines.join("")).must_equal result
            end
        end

    end

end