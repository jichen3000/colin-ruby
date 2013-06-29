# grammar file...
#   stateMachine: eventBlock optionalResetBlock optionalCommandBlock stateList
#   eventBlock: eventKeyword eventDecList endKeyword
#   eventDecList: eventDec+
#   eventDec: identifier identifier
# 
# token_stream = [{:payload=>"stateMachine", :token_type=>:ITEM_NAME, :regexp=>/\Aevents/, :is_output=>true}},
#         {:payload=>"doorClosed", :token_type=>{:name=>:IDENTIFIER, :regexp=>/\A(\w)+/, :is_output=>true}},
#         {:payload=>"D1CL", :token_type=>{:name=>:IDENTIFIER, :regexp=>/\A(\w)+/, :is_output=>true}},
#         {:payload=>"drawOpened", :token_type=>{:name=>:IDENTIFIER, :regexp=>/\A(\w)+/, :is_output=>true}},
#         {:payload=>"D2OP", :token_type=>{:name=>:IDENTIFIER, :regexp=>/\A(\w)+/, :is_output=>true}},
#         {:payload=>"end", :token_type=>{:name=>:END, :regexp=>/\Aend/, :is_output=>true}}]

$:.unshift File.dirname(__FILE__)
require 'common_lexer'
class StateMachineTokenType
    extend TokenType
    create(:EVENTS, /\Aevents/)
    create(:RESET, /\AresetEvents/)
    create(:COMMANDS, /\Acommands/)
    create(:END, /\Aend/)
    create(:ACTIONS, /\Astate/)
    create(:LEFT, /\A\{/)
    create(:RIGHT, /\A\}/)
    create(:TRANSITION, /\A=>/)
    create(:IDENTIFIER, /\A(\w)+/)
    create(:WHITESPACE, /\A(\s)+/,is_output:false)
    create(:COMMENT, /\A\\(.)*$/,is_output:false)
    create(:EOF, /\AEOF/,is_output:false)
end
if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'

    describe "tokenize" do
        it "can tokenize the grammar string" do
            str = <<EOF
events
  doorClosed  D1CL
  drawOpened  D2OP
end
EOF
            result = [{:payload=>"events", :type_name=>:EVENTS}, 
                {:payload=>"doorClosed", :type_name=>:IDENTIFIER}, 
                {:payload=>"D1CL", :type_name=>:IDENTIFIER}, 
                {:payload=>"drawOpened", :type_name=>:IDENTIFIER}, 
                {:payload=>"D2OP", :type_name=>:IDENTIFIER}, 
                {:payload=>"end", :type_name=>:END}]

            StateMachineTokenType.tokenize(str).must_equal result
        end

    end

end