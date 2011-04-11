require 'rubygems'  # allows for the loading of gems
require 'graphviz'  # this loads the ruby-graphviz gem

# Constants defining file names and paths
CSVRecipeFileName   = "recipes.csv"
CSVRecipeFilePath   = File.join(".")
CSVMaterialFileName = "materials.csv"
CSVMaterialFilePath = File.join(".")
CSVPlantFileName    = "plants.csv"
CSVPlantFilePath    = File.join(".")
OutputPath          = File.join(".")

# load 3 arrays with CSV data
recipes = []; materials = []; plants = []
[[CSVRecipeFileName,   CSVRecipeFilePath,   recipes], 
 [CSVMaterialFileName, CSVMaterialFilePath, materials],
 [CSVPlantFileName,    CSVPlantFilePath,    plants]].each do |array|
   File.open(File.join(array[1], array[0])).each do |line|
     item =  line.chop.split(",")
     p item
     array[2] << item
     
   end
end

# initialize new Graphviz graph
g = GraphViz::new( "structs", "type" => "graph" )
g[:rankdir] = "LR"

# set global node options
g.node[:color]    = "#ddaa66"
g.node[:style]    = "filled"
g.node[:shape]    = "box"
g.node[:penwidth] = "1"
g.node[:fontname] = "Trebuchet MS"
g.node[:fontsize] = "8"
g.node[:fillcolor]= "#ffeecc"
g.node[:fontcolor]= "#775500"
g.node[:margin]   = "0.0"

# set global edge options
g.edge[:color]    = "#999999"
g.edge[:weight]   = "1"
g.edge[:fontsize] = "6"
g.edge[:fontcolor]= "#444444"
g.edge[:fontname] = "Verdana"
g.edge[:dir]      = "forward"
g.edge[:arrowsize]= "0.5"

# draw our nodes, i.e., plants
plants.each do |plant|
  g.add_node(plant[0]).label = plant[1]+"\\n"+
    plant[2]+", "+plant[3]+"\\n("+plant[0]+")"
end

# brute force, but simple function to find a material record by number
def find_material_record(materials_array, material_number)
  materials_array.collect{|m| m[1] unless m.index(material_number).nil?}.compact[0]
end

# connect the nodes with our recipes, add labels from material data
recipes.each do |recipe|
  end_material = find_material_record(materials, recipe[1])
  component_material = find_material_record(materials, recipe[3])
  g.add_edge(recipe[4],recipe[2]).label=
    component_material+" for\\n"+end_material+"\\n(Recipe "+recipe[0]+")"
end

g.output( "output" => "png", :file => OutputPath+"/graph.png")
