class Frog
  def speaks_english
    @speaks_english
  end

  def speaks_english=(value)
    @speaks_english = value
  end
end

f = Frog.new
f.speaks_english = "jc"
p f.speaks_english

p f.instance_variable_get("@speaks_english")
f.instance_variable_set("@speaks_english","mm")
p f.speaks_english

p Frog.ancestors
