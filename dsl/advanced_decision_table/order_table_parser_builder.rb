# notic, actually, when a table changed I mean client want to add some condition to csv,
# I need to change OrderTableBuilder and this OrderTableParser

$:.unshift File.dirname(__FILE__)
require 'order_decision_table_builder'
require 'table_parser'
require 'helpers'



class OrderTableParserBuilder
    class << self
        def gen_xyn_tans_proc
            Proc.new do |value|
                case value
                when 'X' then nil
                when 'Y' then true
                when 'N' then false
                end
            end
        end
        def gen_int_trans_proc
            Proc.new do |value|
                value.to_i
            end
        end
        def gen_weight_exp_proc
            Proc.new do |value|
                ExpHelper.gen_comparative_exp(value)
            end
        end
        def build
            order_table_parser =TableParser.new
            order_table_parser.add_proc("Premium Customer",gen_xyn_tans_proc())
            order_table_parser.add_proc("Priority Order",gen_xyn_tans_proc())
            order_table_parser.add_proc("International Order",gen_xyn_tans_proc())
            order_table_parser.add_proc("Weight Range(kg)",gen_weight_exp_proc())
            order_table_parser.add_proc("Fee",gen_int_trans_proc())
            order_table_parser.add_proc("Alert Rep",gen_xyn_tans_proc())

            order_table_parser
        end
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe TableParser do
        it "can parse csv file" do
            filename = "order.csv"
            order_decision_table = OrderDecisionTableBuilder.first_build
            order_table_parser = OrderTableParserBuilder.build

            columns, condition_row_list = order_table_parser.csv_parse(filename, order_decision_table)

            OrderDecisionTableBuilder.add_condition_possible_values(order_decision_table, condition_row_list)

            OrderDecisionTableBuilder.add_columns(order_decision_table, columns)

            consequence1 = ConsequenceValueColumn.new([150, true])
            consequence2 = ConsequenceValueColumn.new([100, true])
            consequence3 = ConsequenceValueColumn.new([70, true])
            consequence4 = ConsequenceValueColumn.new([50, false])
            consequence5 = ConsequenceValueColumn.new([80, false])
            consequence6 = ConsequenceValueColumn.new([60, false])
            order_decision_table.get_consequence_column(Order.new(nil, 1200, :US, 20)).must_equal consequence1
            order_decision_table.get_consequence_column(Order.new(nil, 800, :US, 5)).must_equal consequence2
            order_decision_table.get_consequence_column(Order.new("colin", 1200, :China, 2)).must_equal consequence3
            order_decision_table.get_consequence_column(Order.new("colin", 800, :China, 1)).must_equal consequence4
            order_decision_table.get_consequence_column(Order.new("john", 1200, :China, 5)).must_equal consequence5
            order_decision_table.get_consequence_column(Order.new("john", 800, :China, 5)).must_equal consequence6
            order_decision_table.get_consequence_column(Order.new(nil, 1200, :China, 5)).must_equal nil

        end
    end
end