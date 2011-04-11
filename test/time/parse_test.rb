require 'parsedate'
def time_trans(time)
     puts "time:#{time}"
     time_array=ParseDate.parsedate(time)
     p time_array
     puts "#{Time.local(time_array[0],time_array[1],time_array[2],time_array[3],time_array[4],time_array[5])}"
     return Time.local(time_array[0],time_array[1],time_array[2],time_array[3],time_array[4],time_array[5])
 end
time_trans("Fri Dec 12 14:43:04 2008")