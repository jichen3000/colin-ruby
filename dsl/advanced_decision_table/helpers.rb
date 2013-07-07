class ArrayHelper
    class << self
        def differet(arr1, arr2)
            [arr1-arr2, arr2-arr1]
        end
        def to_hash_by_first_item(arr)
            arr.reduce({}) do |result, item|
                result[item.first] = item[1..-1]
                result
            end
        end
        def resort_by_first_item_array(arr, first_item_arr)
            hash = to_hash_by_first_item(arr)
            first_item_arr.map do |item|
                [item, *hash[item]]
            end
        end
    end
end
class ExpHelper
    class << self
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
        def range_eval_true?(weight, eval_str)
            str = eval_str.gsub("?", "weight")
            eval(str) == true
        end
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe ArrayHelper do
        it "can get difference" do
            ArrayHelper.differet([1,2,3],[3,1,4,5]).must_equal([[2], [4,5]])
            ArrayHelper.differet([1,3,5,4],[3,1,4,5]).must_equal([[], []])
        end
        it "can resort array by first item array" do
            arr = [["name2", 2,2,2], ["name1", 1,1,1], ["name3", 3,3,3]]
            names = ["name1","name2","name3"]
            result_arr = [["name1", 1,1,1], ["name2", 2,2,2], ["name3", 3,3,3]]
            ArrayHelper.resort_by_first_item_array(arr, names).must_equal result_arr
        end
        it "can to_hash_by_first_item" do
            arr = [["name2", 2,2,2], ["name1", 1,1,1], ["name3", 3,3,3]]
            hash = {"name2"=>[2,2,2], "name1"=> [1,1,1], "name3"=>[3,3,3]}
            ArrayHelper.to_hash_by_first_item(arr).must_equal hash
        end
    end
    describe ExpHelper do
        it "can gen_comparative_exp" do
            ExpHelper.gen_comparative_exp(nil).must_equal nil
            ExpHelper.gen_comparative_exp("").must_equal nil
            ExpHelper.gen_comparative_exp(' ').must_equal nil

            ExpHelper.gen_comparative_exp(">= 1 ").must_equal "? >= 1"
            ExpHelper.gen_comparative_exp("<= 1 ").must_equal "? <= 1"
            ExpHelper.gen_comparative_exp("> 1").must_equal "? > 1"
            ExpHelper.gen_comparative_exp("< 1 ").must_equal "? < 1"
            ExpHelper.gen_comparative_exp("== 100 ").must_equal "? == 100"

            ExpHelper.gen_comparative_exp("99 >= ").must_equal "99 >= ?"
            ExpHelper.gen_comparative_exp("99 > ").must_equal "99 > ?"
            ExpHelper.gen_comparative_exp("99<=  ").must_equal "99 <= ?"

            ExpHelper.gen_comparative_exp("99<= ? <=101 ").must_equal "99 <= ? and ? <= 101"
        end
        
    end

end