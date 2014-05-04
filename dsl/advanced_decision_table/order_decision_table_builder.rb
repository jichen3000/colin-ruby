$:.unshift File.dirname(__FILE__)
require 'decision_table'
require 'orders'
require 'helpers'

class OrderDecisionTableBuilder
    class << self
        def gen_premium_proc
            lambda do |order, possible_values|
                possible_values.each do |value|
                    return value if (premium_customer?(order) == value)
                end
            end
        end
        def gen_priority_proc
            lambda do |order, possible_values|
                possible_values.each do |value|
                    return value if (order.priority? == value)
                end
            end
        end
        def gen_international_proc
            lambda do |order, possible_values|
                possible_values.each do |value|
                    return value if (order.international? == value)
                end
            end
        end
        def gen_weight_proc
            lambda do |order, possible_values|
                possible_values.each do |value|
                    return nil if value == nil
                    return value if (ExpHelper.range_eval_true?(order.weight, value))
                end
            end
        end
        def first_build
            # There are two types of functions, 
            # one of which is methods that belong to a object,
            # the other is a function that will be created temporarily.
            order_decision_table = DecisionTable.new
            order_decision_table.add_condition("Premium Customer", gen_premium_proc())
            order_decision_table.add_condition("Priority Order", gen_priority_proc())
            order_decision_table.add_condition("International Order", gen_international_proc())
            order_decision_table.add_condition("Weight Range(kg)", gen_weight_proc())


            order_decision_table.add_consequence("Fee")
            order_decision_table.add_consequence("Alert Rep")

            order_decision_table
        end
        def add_columns(order_decision_table, columns)
            columns.each do |column|
                order_decision_table.add_column_by_array(column)
            end     
            order_decision_table       
        end
        def add_condition_possible_values(order_decision_table, condition_row_list)
            condition_row_list.each do |row|
                # p row
                # uniq_row = row.uniq
                order_decision_table.add_condition_possible_values(row.first, row.uniq[1..-1])
            end

            order_decision_table
        end
    end
end
            
if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe OrderDecisionTableBuilder do
        it "can work!" do
            order_decision_table = OrderDecisionTableBuilder.first_build


            order_decision_table.instance_variable_get("@consequences").must_equal(
                [Consequence.new("Fee"),Consequence.new("Alert Rep")])

            order_decision_table.add_condition_possible_values("Premium Customer", [true,false,nil])
            order_decision_table.add_condition_possible_values("Priority Order", [true,false])
            order_decision_table.add_condition_possible_values("International Order", [true,false])
            order_decision_table.add_condition_possible_values("Weight Range(kg)", ["?>10","2<? and ?<=10","?<=2",nil])


            consequence1 = ConsequenceValueColumn.new([150, true])
            order_decision_table.add_column(ConditionValueColumn.new([nil, true, true, "?>10"]),
              consequence1)
            consequence2 = ConsequenceValueColumn.new([100, true])
            order_decision_table.add_column(ConditionValueColumn.new([nil, false, true, "2<? and ?<=10"]),
              consequence2)
            consequence3 = ConsequenceValueColumn.new([70, true])
            order_decision_table.add_column(ConditionValueColumn.new([true, true, false, "?<=2"]),
              consequence3)
            consequence4 = ConsequenceValueColumn.new([50, false])
            order_decision_table.add_column(ConditionValueColumn.new([true, false, false, "?<=2"]),
              consequence4)
            consequence5 = ConsequenceValueColumn.new([80, false])
            order_decision_table.add_column(ConditionValueColumn.new([false, true, false, nil]),
              consequence5)
            consequence6 = ConsequenceValueColumn.new([60, false])
            order_decision_table.add_column(ConditionValueColumn.new([false, false, false, nil]),
              consequence6)

            order_decision_table.get_consequence_column(Order.new(nil, 1200, :US, 20)).must_equal consequence1
            order_decision_table.get_consequence_column(Order.new(nil, 800, :US, 5)).must_equal consequence2
            order_decision_table.get_consequence_column(Order.new("colin", 1200, :China, 2)).must_equal consequence3
            order_decision_table.get_consequence_column(Order.new("colin", 800, :China, 1)).must_equal consequence4
            order_decision_table.get_consequence_column(Order.new("john", 1200, :China, 5)).must_equal consequence5
            order_decision_table.get_consequence_column(Order.new("john", 800, :China, 5)).must_equal consequence6
            order_decision_table.get_consequence_column(Order.new(nil, 1200, :China, 5)).must_equal nil

        end
        
    end
    describe "some" do
        it "can work!" do
            "jc".must_equal("jc")
        end
    end
end
