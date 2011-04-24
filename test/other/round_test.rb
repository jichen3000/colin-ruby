i1 = 7 
i2 = 4
#i3 = (i1 / i2).to_i
i3 = (i1 / i2)
require 'pp'
pp i3
pp (7.0/4).to_i
pp (7.to_f/4)

tmp_file_count=((FINAL_RATE.to_f * @total_row_count).round) / @mass_line_count