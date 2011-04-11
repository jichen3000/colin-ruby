def e(m,n)
  if m < n
    e(n,m)
  end
  r = m % n
  if r == 0
    return n
  end
  e(n,r)
end

m = 10
n = 40
r = e(m,n)
p "#{m} and #{n}'s bigest common divisor is #{r}"
p "ok"
