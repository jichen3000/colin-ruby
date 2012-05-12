require 'sinatra'
require 'haml'
get "/sudoku" do
  haml :main, :locals => {:sudoku_size => 9}
end
get "/index" do
  haml :index, :locals => {:hello => "colin"}
end

def helper(group_index, inner_index)
  y, x = group_index.divmod(3)
  inner_y, inner_x = inner_index.divmod(3)
  [x*3+inner_x, y*3+inner_y]
end
