# grammar file...

# event_dec: IDENTIFIER IDENTIFIER IDENTIFIER
# event_dec_list: (event_dec)*
# event_block: EVENTS event_dec_list END
# callback_dec: IDENTIFIER IDENTIFIER IDENTIFIER
# callback_dec_list: (callback_dec)*
# callback_block: CALLBACKS callback_dec_list END
# state_machine: (event_block) (callback_block)

$:.unshift File.dirname(__FILE__)
require 'common_lexer'
require 'state_machine_lexer'
require 'token_buffer'

class StateMachineCombinatorParser
    def initialize(token_buffer)
        @token_buffer = token_buffer
        @syntax_tree = {events:[],callbacks:[]}

        @end_keyword_parser = generate_terminal_parser(:END)
        @identifer_keyword_parser = generate_terminal_parser(:IDENTIFIER)
        @events_keyword_parser = generate_terminal_parser(:EVENTS)
        @event_dec_parser = generate_sequence_combinator(
            @identifer_keyword_parser, @identifer_keyword_parser, @identifer_keyword_parser,
            action:generate_event_dec_action())
        @event_dec_list_parser = generate_list_combinator(@event_dec_parser)
        @event_block_parser = generate_sequence_combinator(
            @events_keyword_parser, @event_dec_list_parser, @end_keyword_parser)

        @callbacks_keyword_parser = generate_terminal_parser(:CALLBACKS)
        @callback_dec_parser = generate_sequence_combinator(
            @identifer_keyword_parser, @identifer_keyword_parser, @identifer_keyword_parser,
            action:generate_callback_dec_action())
        @callback_dec_list_parser = generate_list_combinator(@callback_dec_parser)
        @callback_block_parser = generate_sequence_combinator(
            @callbacks_keyword_parser, @callback_dec_list_parser, @end_keyword_parser)

        @state_machine_parser = generate_sequence_combinator(@event_block_parser, @callback_block_parser)

    end
    def parse()
        @state_machine_parser.call(gen_default_result)
        @syntax_tree
    end
    def gen_default_result
        {:match_flag=>true, :token_buffer=>@token_buffer, :match_value=>nil}
    end
    def get_syntax_tree
        @syntax_tree
    end
    private
    def generate_event_dec_action()
        Proc.new do |result_list|
            @syntax_tree[:events] << result_list
        end
    end
    def generate_callback_dec_action()
        Proc.new do |result_list|
            @syntax_tree[:callbacks] << result_list
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
            end
            # even there is not one sub item, it also means successful
            {:match_flag=>true, 
                    :token_buffer=>last_result[:token_buffer], :match_value=>match_value_list}
        end

    end

end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe StateMachineCombinatorParser do

        it "can generate parser" do
            token_list = [
                 {:payload=>"events", :type_name=>:EVENTS},
                 {:payload=>"start", :type_name=>:IDENTIFIER},
                 {:payload=>"NIL", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"warn", :type_name=>:IDENTIFIER},
                 {:payload=>"green", :type_name=>:IDENTIFIER},
                 {:payload=>"yellow", :type_name=>:IDENTIFIER},
                 {:payload=>"end", :type_name=>:END},
                 {:payload=>"callbacks", :type_name=>:CALLBACKS},
                 {:payload=>"before", :type_name=>:IDENTIFIER},
                 {:payload=>"start", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"on", :type_name=>:IDENTIFIER},
                 {:payload=>"start", :type_name=>:IDENTIFIER},
                 {:payload=>"log_proc", :type_name=>:IDENTIFIER},
                 {:payload=>"end", :type_name=>:END}]

            token_buffer = TokenBuffer.new(token_list)
            parser = StateMachineCombinatorParser.new(token_buffer)
            parser.parse.must_equal(
                {:events=>[["start", "NIL", "green"], ["warn", "green", "yellow"]],
                 :callbacks=>[["before", "start", "log_proc"], ["on", "start", "log_proc"]]})
        end

    end
end