# this will support regular grammer parser.
# Grammer file:
# grammar file...
#   stateMachine: eventBlock commandBlock*
#   eventBlock: eventKeyword eventDecList endKeyword
#   eventDecList: eventDec+
#   eventDec: identifier identifier?
#   commandBlock: commandKeyword commandDecList endKeyword
#   commandDecList: commandDec+
#   commandDec: identifier identifier?
# 
# token_stream = [{:payload=>"stateMachine", :token_type=>:ITEM_NAME},
#                 {:payload=>"eventBlock", :token_type=>:IDENTIFIER},
#                 {:payload=>"commandBlock", :token_type=>:SIGN},

$:.unshift File.dirname(__FILE__)
require 'common_lexer'

class RegularGrammerTokenType
    extend TokenType
    create(:ITEM_NAME, /\A(\w+)\:/, get_group_num:1)
    create(:IDENTIFIER, /\A\w+/)
    create(:SIGN, /\A[\*|\?|\+]/)
    create(:WHITESPACE, /\A\s+/,is_output:false)
    create(:COMMENT, /\A\#.*$/,is_output:false)
    create(:EOF, /\AEOF/,is_output:false)
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'

    describe "regular_grammer_tokenize" do
        it "can tokenize the grammar string" do
            str = <<EOF
stateMachine: eventBlock commandBlock*
eventBlock: eventKeyword eventDecList endKeyword
eventDecList: eventDec+
eventDec: identifier identifier?
commandBlock: commandKeyword commandDecList endKeyword
commandDecList: commandDec+
commandDec: identifier identifier?
EOF
            result = [{:payload=>"stateMachine", :type_name=>:ITEM_NAME}, 
                {:payload=>"eventBlock", :type_name=>:IDENTIFIER}, 
                {:payload=>"commandBlock", :type_name=>:IDENTIFIER}, 
                {:payload=>"*", :type_name=>:SIGN}, 
                {:payload=>"eventBlock", :type_name=>:ITEM_NAME}, 
                {:payload=>"eventKeyword", :type_name=>:IDENTIFIER}, 
                {:payload=>"eventDecList", :type_name=>:IDENTIFIER}, 
                {:payload=>"endKeyword", :type_name=>:IDENTIFIER}, 
                {:payload=>"eventDecList", :type_name=>:ITEM_NAME}, 
                {:payload=>"eventDec", :type_name=>:IDENTIFIER}, 
                {:payload=>"+", :type_name=>:SIGN}, 
                {:payload=>"eventDec", :type_name=>:ITEM_NAME}, 
                {:payload=>"identifier", :type_name=>:IDENTIFIER}, 
                {:payload=>"identifier", :type_name=>:IDENTIFIER}, 
                {:payload=>"?", :type_name=>:SIGN}, 
                {:payload=>"commandBlock", :type_name=>:ITEM_NAME}, 
                {:payload=>"commandKeyword", :type_name=>:IDENTIFIER}, 
                {:payload=>"commandDecList", :type_name=>:IDENTIFIER}, 
                {:payload=>"endKeyword", :type_name=>:IDENTIFIER}, 
                {:payload=>"commandDecList", :type_name=>:ITEM_NAME}, 
                {:payload=>"commandDec", :type_name=>:IDENTIFIER}, 
                {:payload=>"+", :type_name=>:SIGN}, 
                {:payload=>"commandDec", :type_name=>:ITEM_NAME}, 
                {:payload=>"identifier", :type_name=>:IDENTIFIER}, 
                {:payload=>"identifier", :type_name=>:IDENTIFIER}, 
                {:payload=>"?", :type_name=>:SIGN}]

            RegularGrammerTokenType.tokenize(str).must_equal result
            # p regular_grammer_tokenize(str)
        end

    end

end