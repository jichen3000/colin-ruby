# this will support regular grammer parser.
# using Recursive Descent Parser. Chaper 21 from DSL
# grammar file...
#   stateMachine: eventBlock commandBlock*
#   eventBlock: eventKeyword eventDecList endKeyword
#   eventDecList: eventDec+
#   eventDec: identifier identifier
#   commandBlock: commandKeyword commandDecList endKeyword
#   commandDecList: commandDec+
#   commandDec: identifier identifier
# 
# 
$:.unshift File.dirname(__FILE__)
require 'regular_grammer_lexer'

class RegularGrammerParser
    def initialize(token_buffer)
        @token_buffer = token_buffer
        @result = {}
        @items = []
    end
    def parser()
        item_block_list_parse()
    end

    # grammar file...
    #   stateMachine: eventBlock commandBlock*
    def item_block_list_parse()
        item_block_list = []
        begin
            current_token = @token_buffer.next_token()
            if RegularGrammerTokenType.is_item_name(current_token)
                item_name = consume(current_token)
                item_dec_list = item_dec_list_parse()
                item_block_list.push({:type=>:BLOCK, :name=>item_name, :dec_list=>item_dec_list})
            end
        end while (not @token_buffer.done?) and RegularGrammerTokenType.is_item_name(@token_buffer.next_token)
        item_block_list
    end
    # grammar file...
    #   eventBlock commandBlock*
    def item_dec_list_parse()
        item_dec_list = []
        begin
            current_token = @token_buffer.next_token
            if RegularGrammerTokenType.is_identifier(current_token)
                identifier_payload = consume(current_token)
                item_dec_list.push({:type=>:DEC, :name=>identifier_payload})
            end
            if RegularGrammerTokenType.is_sign(current_token)
                payload = consume(current_token)
                item_dec_list.last[:sign] = payload
            end
        end while (not @token_buffer.done?) and 
            not RegularGrammerTokenType.is_item_name(@token_buffer.next_token)
        item_dec_list
    end

    def consume(token)
        @token_buffer.pop_token()
        token[:payload]
    end

end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'

    describe RegularGrammerParser do
        it "can parser the token list" do
            str = <<EOF
stateMachine: eventBlock commandBlock*
eventBlock: eventKeyword eventDecList endKeyword
eventDecList: eventDec+
eventDec: identifier identifier
commandBlock: commandKeyword commandDecList endKeyword
commandDecList: commandDec+
commandDec: identifier identifier
EOF

            token_list = RegularGrammerTokenType.tokenize(str)
            result = [{:type=>:BLOCK, :name=>"stateMachine", 
                        :dec_list=>[{:type=>:DEC, :name=>"eventBlock"}, 
                                    {:type=>:DEC, :name=>"commandBlock", :sign=>"*"}]}, 
                    {:type=>:BLOCK, :name=>"eventBlock", 
                        :dec_list=>[{:type=>:DEC, :name=>"eventKeyword"}, 
                                    {:type=>:DEC, :name=>"eventDecList"}, 
                                    {:type=>:DEC, :name=>"endKeyword"}]}, 
                    {:type=>:BLOCK, :name=>"eventDecList", 
                        :dec_list=>[{:type=>:DEC, :name=>"eventDec", :sign=>"+"}]}, 
                    {:type=>:BLOCK, :name=>"eventDec", 
                        :dec_list=>[{:type=>:DEC, :name=>"identifier"}, 
                                    {:type=>:DEC, :name=>"identifier"}]}, 
                    {:type=>:BLOCK, :name=>"commandBlock", 
                        :dec_list=>[{:type=>:DEC, :name=>"commandKeyword"}, 
                                    {:type=>:DEC, :name=>"commandDecList"}, 
                                    {:type=>:DEC, :name=>"endKeyword"}]}, 
                    {:type=>:BLOCK, :name=>"commandDecList", 
                        :dec_list=>[{:type=>:DEC, :name=>"commandDec", :sign=>"+"}]}, 
                    {:type=>:BLOCK, :name=>"commandDec", 
                        :dec_list=>[{:type=>:DEC, :name=>"identifier"}, 
                                    {:type=>:DEC, :name=>"identifier"}]}]

            RegularGrammerParser.new(TokenBuffer.new(token_list)).parser().must_equal result
        end
    end
end


