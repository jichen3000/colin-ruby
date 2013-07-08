# grammar file...

# need_dec: IDENTIFIER
# need_dec_list: (need_dec)*
# need_block: NEEDS need_dec_list END
# potions: (need_block)+

$:.unshift File.dirname(__FILE__)
require 'common_lexer'
require 'potion_lexer'
require 'token_buffer'

class PotionCombinatorParser
    def initialize(token_buffer)
        @token_buffer = token_buffer
        @syntax_tree = []

        @end_keyword_parser = generate_terminal_parser(:END)
        @needs_keyword_parser = generate_terminal_parser(:NEEDS,action:generate_needs_keyword_action())
        @need_dec_parser = generate_terminal_parser(:IDENTIFIER,
            action:generate_need_dec_action())
        @need_dec_list_parser = generate_list_combinator(@need_dec_parser)
        @need_block_parser = generate_sequence_combinator(
            @needs_keyword_parser, @need_dec_list_parser, @end_keyword_parser)
        @potion_parser = generate_list_combinator(@need_block_parser)

    end
    def parse()
        @potion_parser.call(gen_default_result)
        @syntax_tree
    end
    def gen_default_result
        {:match_flag=>true, :token_buffer=>@token_buffer, :match_value=>nil}
    end
    def get_syntax_tree
        @syntax_tree
    end
    private
    TEMP_POTION_NAME = :TEMP
    def generate_needs_keyword_action()
        Proc.new do |potion_name|
            @syntax_tree.push({:parent=>potion_name, :children=>[]})
        end
    end
    def generate_need_dec_action()
        Proc.new do |potion_name|
            @syntax_tree.last()[:children].push(potion_name)
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
            if PotionTokenType.is_type(token_type_name, current_token)
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
    describe PotionCombinatorParser do
        before do
            token_list = [
                {:payload=>"Clarified Water", :type_name=>:IDENTIFIER},
                {:payload=>"Octopus Essence", :type_name=>:IDENTIFIER}]
            @need_dec_token_buffer = TokenBuffer.new(token_list)
            @need_dec_parser = PotionCombinatorParser.new(@need_dec_token_buffer)
            @need_dec_parser.get_syntax_tree.push(
                {:parent=>"Health Portion", :children=>[]})
        end
        # it "can generate event dec sequence parser" do
        #     need_dec_parser = @need_dec_parser.instance_variable_get('@need_dec_parser')

        #     need_dec_parser.call(@need_dec_parser.gen_default_result).must_equal(
        #         {:match_flag=>true, 
        #          :token_buffer=>@need_dec_token_buffer.create_next_copy(pos_interval: 1), 
        #          :match_value=>"Clarified Water"})
        #     @need_dec_parser.get_syntax_tree.must_equal(
        #         [{:parent=>"Health Portion", :children=>["Clarified Water"]}])
        # end
        # it "can generate_nil_action" do
        #     nil_action = @need_dec_parser.send(:generate_nil_action)
        #     nil_action.call().must_equal nil
        # end
        # it "can generate need_dec_list_parser" do
        #     need_dec_list_parser = @need_dec_parser.instance_variable_get('@need_dec_list_parser')
        #     need_dec_list_parser.call(@need_dec_parser.gen_default_result).must_equal(
        #         {:match_flag=>true, 
        #          :token_buffer=>@need_dec_token_buffer.create_next_copy(pos_interval: 2),
        #          :match_value=>["Clarified Water", "Octopus Essence"]})
        #     @need_dec_parser.get_syntax_tree.must_equal(
        #         [{:parent=>"Health Portion", :children=>["Clarified Water", "Octopus Essence"]}])
        # end
        # it "can generate need_block_parser" do
        #     token_list = [
        #         {:payload=>"Health Portion", :type_name=>:NEEDS},
        #         {:payload=>"Clarified Water", :type_name=>:IDENTIFIER},
        #         {:payload=>"Octopus Essence", :type_name=>:IDENTIFIER},
        #         {:payload=>"end", :type_name=>:END}]
        #     token_buffer = TokenBuffer.new(token_list)
        #     parser = PotionCombinatorParser.new(token_buffer)
        #     need_block_parser = parser.instance_variable_get('@need_block_parser')
        #     need_block_parser.call(parser.gen_default_result).must_equal(
        #         {:match_flag=>true, 
        #          :token_buffer=>token_buffer.create_next_copy(pos_interval: 4),
        #          :match_value=>"end"})
        #     parser.get_syntax_tree.must_equal(
        #         [{:parent=>"Health Portion", :children=>["Clarified Water", "Octopus Essence"]}])
        # end
        it "can generate parser" do
            token_list = [
                {:payload=>"Health Portion", :type_name=>:NEEDS},
                {:payload=>"Clarified Water", :type_name=>:IDENTIFIER},
                {:payload=>"Octopus Essence", :type_name=>:IDENTIFIER},
                {:payload=>"end", :type_name=>:END},
                {:payload=>"Clarified Water", :type_name=>:NEEDS},
                {:payload=>"Dessicated Glass", :type_name=>:IDENTIFIER},
                {:payload=>"end", :type_name=>:END},
                {:payload=>"Octopus Essence", :type_name=>:NEEDS},
                {:payload=>"Clarified Water", :type_name=>:IDENTIFIER},
                {:payload=>"Octopus", :type_name=>:IDENTIFIER},
                {:payload=>"end", :type_name=>:END},
                {:payload=>"Dessicated Glass", :type_name=>:NEEDS}, 
                {:payload=>"end", :type_name=>:END},
                {:payload=>"Octopus", :type_name=>:NEEDS}, 
                {:payload=>"end", :type_name=>:END},
                {:payload=>"Magic Young", :type_name=>:NEEDS},
                {:payload=>"end", :type_name=>:END}]

            token_buffer = TokenBuffer.new(token_list)
            parser = PotionCombinatorParser.new(token_buffer)
            parser.parse.must_equal(
                [{:parent=>"Health Portion", :children=>["Clarified Water", "Octopus Essence"]},
                 {:parent=>"Clarified Water", :children=>["Dessicated Glass"]},
                 {:parent=>"Octopus Essence", :children=>["Clarified Water", "Octopus"]},
                 {:parent=>"Dessicated Glass", :children=>[]},
                 {:parent=>"Octopus", :children=>[]},
                 {:parent=>"Magic Young", :children=>[]}])
        end

    end
end