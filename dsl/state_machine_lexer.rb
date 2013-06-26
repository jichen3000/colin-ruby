# grammar:
# declarations : eventBlock commandBlock;
# eventBlock   : Event-keyword eventDec* End-keyword;
# eventDec     : Identifier Identifier;
# commandBlock : Command-keyword commandDec* End-keyword;
# commandDec   : Identifier Identifier;
# 
# And this input:
# events
#   doorClosed  D1CL
#   drawOpened  D2OP
# end
# 
# token stream:
# [Event-keyword: "events"]
# [Identifier: "doorClosed"]
# [Identifier: "D1CL"]
# [Identifier: "drawOpened"]
# [Identifier:"D2OP"]
# [End-keyword: "end"]

class TokenType
    @@all = []
    def self.create(name, re, is_output: true)
        @@all.push({:name=>name,
            :regexp=>re,
            :is_output=>is_output})
        @@all.last
    end
    def self.all()
        @@all
    end
    def self.get(name)
        @@all.detect {|item| item[:name]==name}
    end
    TokenType.create(:EVENT, /\Aevents/)
    TokenType.create(:RESET, /\AresetEvents/)
    TokenType.create(:COMMANDS, /\Acommands/)
    TokenType.create(:END, /\Aend/)
    TokenType.create(:ACTIONS, /\Astate/)
    TokenType.create(:LEFT, /\A\{/)
    TokenType.create(:RIGHT, /\A\}/)
    TokenType.create(:TRANSITION, /\A=>/)
    TokenType.create(:IDENTIFIER, /\A(\w)+/)
    TokenType.create(:WHITESPACE, /\A(\s)+/,is_output:false)
    TokenType.create(:COMMENT, /\A\\(.)*$/,is_output:false)
    TokenType.create(:EOF, /\AEOF/,is_output:false)

end

def tokenize(content)
    token_list = []
    str = content
    find_flag = false
    while str.length > 1 do
        TokenType.all.each do |token_type|
            # p "token_type:", token_type
            if token_type[:regexp].match(str)
                if token_type[:is_output]
                    token_list.push({:payload=>$&, :token=>token_type})
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

def test_tokenize()
    str = <<EOF
events
  doorClosed  D1CL
  drawOpened  D2OP
end
EOF
    puts tokenize(str)
end

if __FILE__ == $0
    # puts TokenType.all()
    # puts TokenType.get(:END)
    test_tokenize()
    puts "ok"
end