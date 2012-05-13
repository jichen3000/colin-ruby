require 'sinatra'
require 'haml'
require 'json'
get "/sudoku" do
  haml :main, :locals => {:sudoku_size => 9}
end
get "/index" do
  haml :index, :locals => {:hello => "colin"}
end

get "/sudoku/sudokuresult" do
  params[:fix_values].each {|point,v| p point,v}
  {"0_0"=>9,"5_3"=>3}.to_json
end

def helper(group_index, inner_index)
  y, x = group_index.divmod(3)
  inner_y, inner_x = inner_index.divmod(3)
  [x*3+inner_x, y*3+inner_y]
end
