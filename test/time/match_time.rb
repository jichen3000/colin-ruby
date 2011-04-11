month = %w'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'
week = %w'Mon Tue Wed Thu Fri Sat Sun'
p month
p week
m = Regexp.new(week.join('|')+" "+month.join("|"))
str = 'Tue Jan'
p (str=~m)
p ('dfkjsdlfjkd'=~m)
