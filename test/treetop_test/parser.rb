# In file parser.rb
require 'treetop'
# Find out what our base path is
base_path = File.expand_path(File.dirname(__FILE__))

# Load our custom syntax node classes so the parser can use them
require File.join(base_path, 'node_extensions.rb')
class Parser
  
  # Load the Treetop grammar from the 'sexp_parser' file, and 
  # create a new instance of that parser as a class variable 
  # so we don't have to re-create it every time we need to 
  # parse a string
  base_path = File.expand_path(File.dirname(__FILE__))
  Treetop.load(File.join(base_path, 'sexp_parser.treetop'))
  @@parser = SexpParser.new
  def self.parse(data)
    p @@parser
    p data
    tree = @@parser.parse(data)
    p tree
    p self.clean_tree(tree)
    if(tree.nil?)
      raise Exception, "Parse error at offset:#{@@parser.index}"
    end
    return tree.to_array
  end
  private 
  def self.clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if do |node|
      node.instance_of?(Treetop::Runtime::SyntaxNode)
    end
    root_node.elements.each do |node|
      self.clean_tree(node)
    end
  end
end

#p Parser.parse('(this "is" a test( 1 2.0 3))')
p Parser.parse('(select a.id, "is" from issue a where id=2 and (select))')
#Parser.parse("(is)")
p "ok"