class String

  def bin
    val = self.strip
    pattern = /^([+-]?)(0b)?([01]+)(.*)$/
    parts = pattern.match(val)
    return 0 if not parts
    sign = parts[1]
    num  = parts[3]
    eval(sign+"0b"+num)
  end

end

def analyze(dba)
  puts dba
  puts dba.hex.to_s(2)
  bin_str = dba.hex.to_s(2).rjust(dba.size*4,'0')
  puts bin_str
  rfn = bin_str[0..9]
  puts rfn
  puts rfn.bin
  bn =  bin_str[10..-1]
  puts bn
  puts bn.bin
end

analyze('02C003B2')
#analyze('02C00425')
#analyze('01403E31')
#analyze('02C00427')
#analyze('01403E3C')

def ors_split(ors)
#  ors = ors.sub('@','/')
  user,pwd,server = ors.sub('@','/').split('/')
  puts " user : #{user}"
  puts " pwd : #{pwd}"
  puts " server : #{server.class}"
end

ors_split('gt/gmt@jc')
ors_split('gt/gmt')
ors_split('gt')
'aa'.upcase

