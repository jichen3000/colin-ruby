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
require 'lexer'
class StateMachineTokenType
    include TokenType
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
        it "can read file" do
            File.open("potion.script") do |f|
                result = [
                    {:payload=>"events", :type_name=>:EVENTS}, 
                    {:payload=>"doorClosed", :type_name=>:IDENTIFIER}, 
                    {:payload=>"D1CL", :type_name=>:IDENTIFIER}, 
                    {:payload=>"drawerOpened", :type_name=>:IDENTIFIER}, 
                    {:payload=>"D2OP", :type_name=>:IDENTIFIER}, 
                    {:payload=>"lightOn", :type_name=>:IDENTIFIER}, 
                    {:payload=>"L1ON", :type_name=>:IDENTIFIER}, 
                    {:payload=>"doorOpened", :type_name=>:IDENTIFIER}, 
                    {:payload=>"D1OP", :type_name=>:IDENTIFIER}, 
                    {:payload=>"panelClosed", :type_name=>:IDENTIFIER}, 
                    {:payload=>"PNCL", :type_name=>:IDENTIFIER}, 
                    {:payload=>"end", :type_name=>:END}, 
                    {:payload=>"resetEvents", :type_name=>:RESET}, 
                    {:payload=>"doorOpened", :type_name=>:IDENTIFIER}, 
                    {:payload=>"end", :type_name=>:END}, 
                    {:payload=>"commands", :type_name=>:COMMANDS}, 
                    {:payload=>"unlockPanel", :type_name=>:IDENTIFIER}, 
                    {:payload=>"PNUL", :type_name=>:IDENTIFIER}, 
                    {:payload=>"lockPanel", :type_name=>:IDENTIFIER}, 
                    {:payload=>"PNLK", :type_name=>:IDENTIFIER}, 
                    {:payload=>"lockDoor", :type_name=>:IDENTIFIER}, 
                    {:payload=>"D1LK", :type_name=>:IDENTIFIER}, 
                    {:payload=>"unlockDoor", :type_name=>:IDENTIFIER}, 
                    {:payload=>"D1UL", :type_name=>:IDENTIFIER}, 
                    {:payload=>"end", :type_name=>:END}, 
                    {:payload=>"state", :type_name=>:ACTIONS}, 
                    {:payload=>"idle", :type_name=>:IDENTIFIER}, 
                    {:payload=>"actions", :type_name=>:IDENTIFIER}, 
                    {:payload=>"{", :type_name=>:LEFT}, 
                    {:payload=>"unlockDoor", :type_name=>:IDENTIFIER}, 
                    {:payload=>"lockPanel", :type_name=>:IDENTIFIER}, 
                    {:payload=>"}", :type_name=>:RIGHT}, 
                    {:payload=>"doorClosed", :type_name=>:IDENTIFIER}, 
                    {:payload=>"=>", :type_name=>:TRANSITION}, 
                    {:payload=>"active", :type_name=>:IDENTIFIER}, 
                    {:payload=>"end", :type_name=>:END}, 
                    {:payload=>"state", :type_name=>:ACTIONS}, 
                    {:payload=>"active", :type_name=>:IDENTIFIER}, 
                    {:payload=>"drawerOpened", :type_name=>:IDENTIFIER}, 
                    {:payload=>"=>", :type_name=>:TRANSITION}, 
                    {:payload=>"waitingForLight", :type_name=>:IDENTIFIER}, 
                    {:payload=>"lightOn", :type_name=>:IDENTIFIER}, 
                    {:payload=>"=>", :type_name=>:TRANSITION}, 
                    {:payload=>"waitingForDrawer", :type_name=>:IDENTIFIER}, 
                    {:payload=>"end", :type_name=>:END}, 
                    {:payload=>"state", :type_name=>:ACTIONS},
                    {:payload=>"waitingForLight", :type_name=>:IDENTIFIER},
                    {:payload=>"lightOn", :type_name=>:IDENTIFIER},
                    {:payload=>"=>", :type_name=>:TRANSITION},
                    {:payload=>"unlockedPanel", :type_name=>:IDENTIFIER},
                    {:payload=>"end", :type_name=>:END},
                    {:payload=>"state", :type_name=>:ACTIONS},
                    {:payload=>"waitingForDrawer", :type_name=>:IDENTIFIER},
                    {:payload=>"drawerOpened", :type_name=>:IDENTIFIER},
                    {:payload=>"=>", :type_name=>:TRANSITION},
                    {:payload=>"unlockedPanel", :type_name=>:IDENTIFIER},
                    {:payload=>"end", :type_name=>:END},
                    {:payload=>"state", :type_name=>:ACTIONS},
                    {:payload=>"unlockedPanel", :type_name=>:IDENTIFIER},
                    {:payload=>"actions", :type_name=>:IDENTIFIER},
                    {:payload=>"{", :type_name=>:LEFT},
                    {:payload=>"unlockPanel", :type_name=>:IDENTIFIER},
                    {:payload=>"lockDoor", :type_name=>:IDENTIFIER},
                    {:payload=>"}", :type_name=>:RIGHT},
                    {:payload=>"panelClosed", :type_name=>:IDENTIFIER}, 
                    {:payload=>"=>", :type_name=>:TRANSITION}, 
                    {:payload=>"idle", :type_name=>:IDENTIFIER}, 
                    {:payload=>"end", :type_name=>:END}]


                StateMachineTokenType.tokenize(f.readlines.join("")).must_equal result
            end
        end

    end

end