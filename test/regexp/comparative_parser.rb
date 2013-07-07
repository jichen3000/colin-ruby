def gen_comparative_exp(str)
    return nil if str == nil
    str = str.strip
    return nil if str.empty?
    if /^(\d+)\s*(>=|<=|==|!=|>|<)\s*\?\s*(>=|<=|==|!=|>|<)\s*(\d+)/.match(str)
        return [$1, $2, "?", "and", "?", $3, $4].join(" ")
    elsif /^(>=|<=|==|!=|>|<)\s*(\d+)/.match(str)
        return ["?", $1, $2].join(" ")
    elsif /^(\d+)\s*(>=|<=|==|!=|>|<)/.match(str)
        return [$1, $2, "?"].join(" ")
    end
    return false
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe "gen_comparative_exp" do
        it "can gen_comparative_exp" do
            gen_comparative_exp(nil).must_equal nil
            gen_comparative_exp("").must_equal nil
            gen_comparative_exp(' ').must_equal nil

            gen_comparative_exp(">= 1 ").must_equal "? >= 1"
            gen_comparative_exp("<= 1 ").must_equal "? <= 1"
            gen_comparative_exp("> 1").must_equal "? > 1"
            gen_comparative_exp("< 1 ").must_equal "? < 1"
            gen_comparative_exp("== 100 ").must_equal "? == 100"

            gen_comparative_exp("99 >= ").must_equal "99 >= ?"
            gen_comparative_exp("99 > ").must_equal "99 > ?"
            gen_comparative_exp("99<=  ").must_equal "99 <= ?"

            gen_comparative_exp("99<= ? <=101 ").must_equal "99 <= ? and ? <= 101"
        end
        
    end
end