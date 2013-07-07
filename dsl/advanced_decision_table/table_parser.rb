# notic, actually, when a table changed I mean client want to add some condition to csv,
# I need to change OrderTableBuilder and this OrderTableParser

$:.unshift File.dirname(__FILE__)
require 'helpers'

class TableParser
    def initialize()
        @proc_hash = {}
    end
    def add_proc(description, proc)
        @proc_hash[description] = proc
    end
    def csv_parse(filename, decision_table)
        cell_row_list = csv_read(filename)
        # check(cell_row_list, 
        #     decision_table.get_condition_descriptions, 
        #     decision_table.get_consequence_descriptions)
        resorted_cell_row_list = resort_by_description(cell_row_list, 
            decision_table.get_condition_descriptions, 
            decision_table.get_consequence_descriptions)
        translated_cell_row_list = translate_values(resorted_cell_row_list)
        condition_row_list = translated_cell_row_list.first(
            decision_table.get_condition_descriptions.size)
        columns = get_columns(translated_cell_row_list)
        [columns,condition_row_list]
    end
    def csv_read(filename)
        require 'csv'
        CSV.read(filename)
    end
    # def check(cell_row_list, table_condition_descriptions, table_consequence_descriptions)
    #     description_list = cell_row_list.transpose.first

    #     read_condition_descriptions = get_condition_descriptions(
    #         description_list, table_condition_descriptions.size)
    #     read_consequence_descriptions = get_consequence_descriptions(
    #         description_list, table_consequence_descriptions.size)

    #     check_conditions(
    #         read_condition_descriptions,
    #         table_condition_descriptions) and check_consequences(read_consequence_descriptions,
    #         table_consequence_descriptions)
    # end
    def resort_by_description(cell_row_list, table_condition_descriptions, table_consequence_descriptions)
        ArrayHelper.resort_by_first_item_array(cell_row_list, 
            table_condition_descriptions+table_consequence_descriptions)
    end
    def translate_values(cell_row_list)
        cell_row_list.map do |row|
            proc = @proc_hash[row.first]
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

