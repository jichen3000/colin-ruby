begin
eval("begin en")
rescue SyntaxError => e
  p e
  p "catched"
end 