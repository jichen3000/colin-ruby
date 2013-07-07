$:.unshift File.dirname(__FILE__)
require 'table'

def premium_customer?(order)
    return nil if (not order) or (not order.costomer_name)
    order.costomer_name == "colin"
end
class Order
    attr_reader :costomer_name
    def initialize(costomer_name, cost, from)
        @from = from
        @cost = cost
        @costomer_name = costomer_name
    end
    def priority?
        @cost > 1000
    end
    def international?
        @from != :China
    end
end
class OrderDecistionTableBuilder
    def self.build
        # There are two types of functions, 
        # one of which is methods that belong to a object,
        # the other is a function that will be created temporarily.
        order_decision_table = DecisionTable.new
        order_decision_table.add_condition("Premium Customer", lambda {|order| premium_customer?(order)})
        order_decision_table.add_condition("Priority Order", lambda {|order| order.priority?})
        order_decision_table.add_condition("International Order", lambda {|order| order.international?})

        order_decision_table.add_consequence("Fee")
        order_decision_table.add_consequence("Alert Rep")

        order_decision_table
    end
end
            
if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe OrderDecistionTableBuilder do
        it "can work!" do
            order_decision_table = OrderDecistionTableBuilder.build


            order_decision_table.instance_variable_get("@consequences").must_equal(
                [Consequence.new("Fee"),Consequence.new("Alert Rep")])



            consequence1 = ConsequenceValueColumn.new([150, true])
            order_decision_table.add_column(ConditionValueColumn.new([nil, true, true]),
              consequence1)
            consequence2 = ConsequenceValueColumn.new([100, true])
            order_decision_table.add_column(ConditionValueColumn.new([nil, false, true]),
              consequence2)
            consequence3 = ConsequenceValueColumn.new([70, true])
            order_decision_table.add_column(ConditionValueColumn.new([true, true, false]),
              consequence3)
            consequence4 = ConsequenceValueColumn.new([50, false])
            order_decision_table.add_column(ConditionValueColumn.new([true, false, false]),
              consequence4)
            consequence5 = ConsequenceValueColumn.new([80, false])
            order_decision_table.add_column(ConditionValueColumn.new([false, true, false]),
              consequence5)
            consequence6 = ConsequenceValueColumn.new([60, false])
            order_decision_table.add_column(ConditionValueColumn.new([false, false, false]),
              consequence6)

            order_decision_table.get_consequence_column(Order.new(nil, 1200, :US)).must_equal consequence1
            order_decision_table.get_consequence_column(Order.new(nil, 800, :US)).must_equal consequence2
            order_decision_table.get_consequence_column(Order.new("colin", 1200, :China)).must_equal consequence3
            order_decision_table.get_consequence_column(Order.new("colin", 800, :China)).must_equal consequence4
            order_decision_table.get_consequence_column(Order.new("john", 1200, :China)).must_equal consequence5
            order_decision_table.get_consequence_column(Order.new("john", 800, :China)).must_equal consequence6
            order_decision_table.get_consequence_column(Order.new(nil, 1200, :China)).must_equal nil

        end
        
    end

end
