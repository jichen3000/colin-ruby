require 'sinatra'
require 'haml'
get "/sudoku" do
  haml :main, :locals => {:sudoku_size => 9}
end
get "/index" do
  haml :index, :locals => {:hello => "colin"}
end

def helper(group_index, inner_index)
  i,j = group_index.divmod(3)
  inner_i, inner_j = inner_index.divmod(3)
  [i+inner_i, j+inner_j]
end
