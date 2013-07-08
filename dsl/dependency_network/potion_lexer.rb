
$:.unshift File.dirname(__FILE__)
require 'common_lexer'
class PotionTokenType
    include TokenType
    create(:NEEDS, /\A\s*(\w+(\s+\w+)*)\s+needs\s*/,get_group_num: 1)
    create(:END, /\A\s*(end)\s*/,get_group_num: 1)
    create(:COMMENT, /\A\s*\#.*\s/,is_output:false)
    create(:IDENTIFIER, /\A\s*(\w+(\s+\w+)*)\s*/,get_group_num: 1)
    create(:WHITESPACE, /\A\s+/,is_output:false)
end
if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'


    describe "tokenize" do
        it "can test regexp" do
            needs_token_type = PotionTokenType.get_token_type(:NEEDS)
            needs_str = "Health Portion needs "
            PotionTokenType.gen_new_token?(needs_token_type,needs_str).
                must_equal([true, {:payload=>"Health Portion", :type_name=>:NEEDS}])

            identifier_token_type = PotionTokenType.get_token_type(:IDENTIFIER)            
            identifier_str = "    Dessicated Glass "
            PotionTokenType.gen_new_token?(identifier_token_type,identifier_str).
                must_equal([true, {:payload=>"Dessicated Glass", :type_name=>:IDENTIFIER}])

            identifier_token_type = PotionTokenType.get_token_type(:IDENTIFIER)            
            identifier_str = "    Octopus "
            PotionTokenType.gen_new_token?(identifier_token_type,identifier_str).
                must_equal([true, {:payload=>"Octopus", :type_name=>:IDENTIFIER}])

            end_token_type = PotionTokenType.get_token_type(:END)            
            end_str = "    end "
            PotionTokenType.gen_new_token?(end_token_type,end_str).
                must_equal([true, {:payload=>"end", :type_name=>:END}])

            comment_token_type = PotionTokenType.get_token_type(:COMMENT)            
            comment_str = " # for comment "
            PotionTokenType.gen_new_token?(comment_token_type,comment_str).
                must_equal([true, nil])
        end
        it "can read file" do
            result = [
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
            File.open("potion.script") do |file|
                PotionTokenType.tokenize(file.readlines.join("")).must_equal result
            end
        end

    end

end