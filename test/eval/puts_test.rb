data = [2,1]
value = 0.3
exp = "data[0]/data[1] > value"

p eval(exp)

p "ok"

def range_eval_true?(weight, eval_str)
    str = eval_str.gsub("?", "weight")
    eval(str) == true
end

p range_eval_true?(5,"?>1")
p range_eval_true?(5,"2<? and ?<=10")
