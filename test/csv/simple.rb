$:.unshift File.dirname(__FILE__)

require 'csv'

csv_filename = "example.csv"
arr_of_arrs = CSV.read(csv_filename)
p arr_of_arrs

CSV.foreach(csv_filename) do |row|
    p row
end