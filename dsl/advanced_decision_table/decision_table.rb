# My advanced version
# from DSL chapter 48

class DecisionTable
    def initialize()
        @content = {}
        @conditions = []
        @consequences = []
    end
    def add_condition(description, test_function)
        @conditions << Condition.new(description, test_function)
    end
    def add_condition_possible_values(description, possible_values)
        condition = @conditions.select{|x| x.description == description}.first
        condition.possible_values = possible_values
    end
    def get_condition_descriptions
        @conditions.map {|item| item.description}
    end
    def get_consequence_descriptions
        @consequences.map {|item| item.description}
    end
    def add_consequence(description)
        @consequences << Consequence.new(description)
    end
    def add_column(condition_value_column, cosequence_value_column)
        @content[condition_value_column] = cosequence_value_column
    end
    def add_column_by_array(value_arr)
        add_column(ConditionValueColumn.new(value_arr.first(get_condition_descriptions.size)),
            ConsequenceValueColumn.new(value_arr.last(get_consequence_descriptions.size)))
    end
    def get_consequence_column(obj)
        condition_value_column = decide(obj)
        condition_value_column = match_condition_value_column(condition_value_column)
        @content[condition_value_column]
    end
    def match_condition_value_column(condition_value_column)
        @content.keys.each do |item|
            return item if match_tow_column(item.condition_value_list, 
                condition_value_column.condition_value_list)
        end
        return nil
    end
    def match_tow_column(origin, target)
        origin.zip(target).all? do |origin_item, target_item|
            origin_item == nil or origin_item == target_item
        end
    end
    def decide(obj)
        ConditionValueColumn.new(@conditions.map do |condition|
            condition.test_function.call(obj, condition.possible_values)
        end)
    end
end

Condition = Struct.new(:description, :test_function, :possible_values)
Consequence = Struct.new(:description)
ConditionValueColumn = Struct.new(:condition_value_list)
ConsequenceValueColumn = Struct.new(:consequence_value_list)

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe DecisionTable do
        
    end

end