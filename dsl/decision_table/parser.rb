
$:.unshift File.dirname(__FILE__)
require 'order_table'

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
class TableParser
    class << self
        @@proc_hash = {}
        def add_proc(description, proc)
            @@proc_hash[description] = proc
        end
        def csv_parse(filename, decision_table)
            cell_row_list = csv_read(filename)
            check(cell_row_list, 
                decision_table.get_condition_descriptions, 
                decision_table.get_consequence_descriptions)
            resorted_cell_row_list = resort_by_description(cell_row_list, 
                decision_table.get_condition_descriptions, 
                decision_table.get_consequence_descriptions)
            translated_cell_row_list = translate_values(resorted_cell_row_list)
            get_columns(translated_cell_row_list)
        end
        def csv_read(filename)
            require 'csv'
            CSV.read(filename)
        end
        def check(cell_row_list, table_condition_descriptions, table_consequence_descriptions)
            description_list = cell_row_list.transpose.first

            read_condition_descriptions = get_condition_descriptions(
                description_list, table_condition_descriptions.size)
            read_consequence_descriptions = get_consequence_descriptions(
                description_list, table_consequence_descriptions.size)

            check_conditions(
                read_condition_descriptions,
                table_condition_descriptions) and check_consequences(read_consequence_descriptions,
                table_consequence_descriptions)
        end
        def resort_by_description(cell_row_list, table_condition_descriptions, table_consequence_descriptions)
            ArrayHelper.resort_by_first_item_array(cell_row_list, 
                table_condition_descriptions+table_consequence_descriptions)
        end
        def translate_values(cell_row_list)
            cell_row_list.map do |row|
                proc = @@proc_hash[row.first]
                values = row.last(row.size-1)
                if proc
                    values = row.last(row.size-1).map do |cell|
                        proc.call(cell)
                    end
                end
                [row.first, *values]
            end
        end
        def get_columns(cell_row_list)
            cell_row_list.transpose[1..-1]
        end
        def get_condition_descriptions(description_list, size)
            description_list.first(size)
        end
        def get_consequence_descriptions(description_list, size)
            description_list.last(size)
        end
        def check_conditions(read_condition_descriptions,table_condition_descriptions)
            check_names("condition", read_condition_descriptions,table_condition_descriptions)
        end
        def check_consequences(read_consequence_descriptions,table_consequence_descriptions)
            check_names("consequence", read_consequence_descriptions,table_consequence_descriptions)
        end
        def check_names(name_str, read_names,table_names)
            redundant_list, lack_list= ArrayHelper.differet(
                read_names,table_names)
            if redundant_list.size > 0 
                raise "Some #{name_str}s (#{redundant_list}) are not defined!"
            end
            if lack_list.size > 0 
                raise "Some #{name_str}s (#{lack_list}) are not in files!"
            end
            redundant_list.size == 0 and lack_list.size == 0
        end
    end
end

class OrderTableParser < TableParser
    @@xyn_tans_proc = Proc.new do |value|
        case value
        when 'X' then nil
        when 'Y' then true
        when 'N' then false
        end
    end
    @@int_trans_proc = Proc.new do |value|
        value.to_i
    end
    OrderTableParser.add_proc("Premium Customer",@@xyn_tans_proc)
    OrderTableParser.add_proc("Priority Order",@@xyn_tans_proc)
    OrderTableParser.add_proc("International Order",@@xyn_tans_proc)
    OrderTableParser.add_proc("Fee",@@int_trans_proc)
    OrderTableParser.add_proc("Alert Rep",@@xyn_tans_proc)
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
    describe OrderTableParser do
        it "can parse csv file" do
            filename = "order.csv"
            order_decision_table = OrderDecistionTableBuilder.build
            result_columns = [
                [nil, true, true, 150, true], 
                [nil, false, true, 100, true], 
                [true, true, false, 70, true], 
                [true, false, false, 50, false], 
                [false, true, false, 80, false], 
                [false, false, false, 60, false]]
            columns = OrderTableParser.csv_parse(filename, order_decision_table)
            columns.must_equal result_columns

            columns.each do |column|
                order_decision_table.add_column_by_array(column)
            end

            consequence1 = ConsequenceValueColumn.new([150, true])
            consequence2 = ConsequenceValueColumn.new([100, true])
            consequence3 = ConsequenceValueColumn.new([70, true])
            consequence4 = ConsequenceValueColumn.new([50, false])
            consequence5 = ConsequenceValueColumn.new([80, false])
            consequence6 = ConsequenceValueColumn.new([60, false])
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