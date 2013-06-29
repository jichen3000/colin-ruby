# grammar file...
# eventDec: IDENTIFIER IDENTIFIER
# eventDecList: (eventDec)*
# eventBlock: EVENTS eventDecList END
# eventList: (IDENTIFIER)*
# resetBlock: (RESET eventList END)?
# commandDec: IDENTIFIER IDENTIFIER
# commandDecList: (commandDec)*
# commandBlock: (COMMAND commandDecList END)?
# transition: IDENTIFIER TRANSITION IDENTIFIER
# transitionList: (transition)*
# actionDec: IDENTIFIER
# actionList: (actionDec)*
# actionBlock: (ACTIONS LEFT actionList RIGHT)?
# stateDec: STATE IDENTIFIER actionBlock transitionList END
# stateList: (stateDec)*
# stateMachine: eventBlock resetBlock commandBlock stateList

# On Wikipedia, a closure is defined as a function that refers to free variables in its lexical context. 

$:.unshift File.dirname(__FILE__)
require 'state_machine_lexer'
require 'common_lexer'

class StateMachineCombinatorParser
    def initialize(token_buffer)
        @token_buffer = token_buffer
        @syntax_tree = {:events=>[]}

        @end_keyword_parser = generate_terminal_parser(:END)
        @events_keyword_parser = generate_terminal_parser(:EVENTS)
        @identifer_keyword_parser = generate_terminal_parser(:IDENTIFIER)
        @event_dec_parser = generate_sequence_combinator(
            @identifer_keyword_parser, @identifer_keyword_parser,
            action:generate_event_dec_action())
        @event_dec_list_parser = generate_list_combinator(@event_dec_parser)
        @event_block_parser = generate_sequence_combinator(
            @events_keyword_parser, @event_dec_list_parser, @end_keyword_parser)
        # @match_state_machine = generate_sequence_combinator(
        #     @event_block_parser)

    end
    def parse()
        @match_state_machine.call(@token_buffer)
    end
    private
    def generate_event_dec_action()
        Proc.new do |result_list|
            @syntax_tree[:events].push({:left=>result_list[0], :right=>result_list[1]})
        end
    end
    def generate_nil_action()
        Proc.new do |*payload|
            nil
        end
    end
    def generate_terminal_parser(token_type_name, action: generate_nil_action)
        lambda do |combinator_result|
            return combinator_result if not combinator_result[:match_flag]
            current_token_buffer = combinator_result[:token_buffer]
            if current_token_buffer.done?
                return {:match_flag=>false, :token_buffer=>current_token_buffer, :match_value=>nil}
            end
            current_token = current_token_buffer.next_token
            if StateMachineTokenType.is_type(token_type_name, current_token)
                result =   {:match_flag=>true, 
                            :token_buffer=>current_token_buffer.create_next_copy(), 
                            :match_value=>current_token[:payload]}
                action.call(current_token[:payload])
            else
                result = {:match_flag=>false, :token_buffer=>current_token_buffer, :match_value=>nil}
            end
            result
        end
    end

    def generate_sequence_combinator(*parser_list, is_optional: false, action: generate_nil_action)
        lambda do |combinator_result|
            return combinator_result if not combinator_result[:match_flag]
            match_value_list = []
            last_result = combinator_result
            parser_list.each do |parser|
                last_result = parser.call(last_result)
                match_value_list.push(last_result[:match_value])
                break if not last_result[:match_flag] 
            end
            if last_result[:match_flag]
                action.call(match_value_list)
            elsif is_optional
                last_result = {:match_flag=>true, 
                    :token_buffer=>combinator_result[:token_buffer], :match_value=>nil}
            else
                last_result = {:match_flag=>false, 
                    :token_buffer=>combinator_result[:token_buffer], :match_value=>nil}
            end
            last_result
        end
    end

    def generate_list_combinator(parser, action: generate_nil_action)
        lambda do |combinator_result|
            return combinator_result if not combinator_result[:match_flag]
            match_value_list = []
            last_result = combinator_result
            while last_result[:match_flag]
                last_result = parser.call(last_result)
                if last_result[:match_flag]
                    match_value_list.push(last_result[:match_value])
                end
            end
            if match_value_list.size() > 0
                action.call(match_value_list)
                last_result= {:match_flag=>true, 
                    :token_buffer=>last_result[:token_buffer], :match_value=>match_value_list}
            end
            last_result
        end

    end

end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe StateMachineCombinatorParser do
        before do
            token_list =   [{:payload=>"doorClosed", :type_name=>:IDENTIFIER}, 
                            {:payload=>"D1CL", :type_name=>:IDENTIFIER}, 
                            {:payload=>"drawOpened", :type_name=>:IDENTIFIER}, 
                            {:payload=>"D2OP", :type_name=>:IDENTIFIER}]
            @event_dec_token_buffer = TokenBuffer.new(token_list)
            @event_dec_sm_parser = StateMachineCombinatorParser.new(@event_dec_token_buffer)
            @event_dec_combinator_result = {:match_flag=>true, :token_buffer=>@event_dec_token_buffer, :match_value=>nil}
        end
        it "can generate identifier terminal parser" do
            identifer_keyword_parser = @event_dec_sm_parser.instance_variable_get('@identifer_keyword_parser')

            identifer_keyword_parser.call(@event_dec_combinator_result).must_equal(
                {:match_flag=>true, 
                 :token_buffer=>@event_dec_token_buffer.create_next_copy, 
                 :match_value=>"doorClosed"})
        end
        it "can generate event dec sequence parser" do
            event_dec_parser = @event_dec_sm_parser.instance_variable_get('@event_dec_parser')

            event_dec_parser.call(@event_dec_combinator_result).must_equal(
                {:match_flag=>true, 
                 :token_buffer=>@event_dec_token_buffer.create_next_copy(pos_interval: 2), 
                 :match_value=>"D1CL"})
            @event_dec_sm_parser.instance_variable_get('@syntax_tree').must_equal(
                {:events=>[{:left=>"doorClosed", :right=>"D1CL"}]})
        end
        it "can generate_nil_action" do
            nil_action = @event_dec_sm_parser.send(:generate_nil_action)
            nil_action.call().must_equal nil
        end
        it "can generate event_dec_list_parser" do
            event_dec_list_parser = @event_dec_sm_parser.instance_variable_get('@event_dec_list_parser')
            event_dec_list_parser.call(@event_dec_combinator_result).must_equal(
                {:match_flag=>true, 
                 :token_buffer=>@event_dec_token_buffer.create_next_copy(pos_interval: 4),
                 :match_value=>["D1CL", "D2OP"]})
        end
        it "can generate event_dec_list_parser" do
            token_list =   [{:payload=>"events", :type_name=>:EVENTS}, 
                {:payload=>"doorClosed", :type_name=>:IDENTIFIER}, 
                {:payload=>"D1CL", :type_name=>:IDENTIFIER}, 
                {:payload=>"drawOpened", :type_name=>:IDENTIFIER}, 
                {:payload=>"D2OP", :type_name=>:IDENTIFIER}, 
                {:payload=>"end", :type_name=>:END}]
            event_block_token_buffer = TokenBuffer.new(token_list)
            event_block_sm_parser = StateMachineCombinatorParser.new(event_block_token_buffer)
            event_block_combinator_result = {:match_flag=>true, :token_buffer=>event_block_token_buffer, :match_value=>nil}

            event_block_parser = event_block_sm_parser.instance_variable_get('@event_block_parser')
            event_block_parser.call(event_block_combinator_result).must_equal(
                {:match_flag=>true, 
                 :token_buffer=>event_block_token_buffer.create_next_copy(pos_interval: 6),
                 :match_value=>"end"})
        end

    end
end