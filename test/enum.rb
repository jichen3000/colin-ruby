module WeekDay
  Mon, Tue, Wed, Thu, Fri, Sat, Sun = *(1..7)
end
module WeekDayStr
  Mon, Tue, Wed, Thu, Fri, Sat, Sun = %w(Mon Tue Wed Thu Fri Sat Sun)
end

p WeekDay::Mon
p WeekDay::constants

p WeekDayStr::Tue
p WeekDayStr::constants

p "ok"