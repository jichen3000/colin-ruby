$:.unshift File.dirname(__FILE__)

require 'csv'

csv_filename = "example.csv"
arr_of_arrs = CSV.read(csv_filename)
p arr_of_arrs

a = []
CSV.foreach(csv_filename) do |row|
    a << row
end
p a

CSV.open("write.csv", "wb") do |csv|
  csv << ["row", "of", "CSV", "data"]
  csv << ["another", "row"]
end

def dump_to_csv(filepath, rows)
    CSV.open(filepath, "wb") do |csv|
        rows.each do |row|
            csv << row
        end
    end
end
def load_from_csv(filepath)
    a = []
    CSV.foreach(filepath) do |row|
        a << row
    end
    a
end
