module GA
    class BinaryTreeException < Exception
    end


    class BinaryTreeNode
        attr_accessor :parent, :left, :right, :value, :is_leaf, :tree, :node_position, :depth
        # attr_reader :depth
        def initialize(value=nil, is_leaf=true, tree=nil, parent=nil, node_position=nil)
            raise BinaryTreeException.new(
                "Node's value cannot be null!") if not value
            # raise BinaryTreeException.new(
            #     "Node's tree cannot be null!") if not tree
            # tree.pt
            @value = value
            @tree = tree
            @parent = parent
            @is_leaf = is_leaf
            @depth = @parent ? @parent.depth + 1 : 0
            @node_position = node_position
        end
        # def add_child(node_position, value, is_leaf)
        #     # self.is_leaf = false
        #     raise BinaryTreeException.new(
        #         "The leaf node cannot have children!") if @is_leaf
        #     child = BinaryTreeNode.new(value, is_leaf, self.tree, self, node_position)
        #     if node_position == :left
        #         @left = child
        #     else
        #         @right = child
        #     end
        #     # child.value.pt
        #     if @tree
        #         @tree.check_and_set_depth(child.depth)
        #     end
        #     # @tree.add_count()

        #     self
        # end
        # def add_left(value:nil, is_leaf:true)
        #     add_child(:left, value, is_leaf)
        # end
        # def add_right(value:nil, is_leaf:true)
        #     add_child(:right, value, is_leaf)
        # end
        def search_same_depth(the_depth)
            nodes = []
            if @depth == the_depth
                nodes << self
            else
                nodes += @left.search_same_depth(the_depth) if @left
                nodes += @right.search_same_depth(the_depth) if @right
            end

            nodes
        end
        def breadth_first_search()
            nodes = []
            # add root
            nodes << self if parent == nil

            nodes << @left if @left
            nodes << @right if @right

            nodes += @left.breadth_first_search() if @left
            nodes += @right.breadth_first_search() if @right

            nodes
        end 
        def depth_first_search()
            nodes = []

            nodes << self

            nodes += @left.depth_first_search() if @left
            nodes += @right.depth_first_search() if @right

            nodes
        end
        def set_self_and_children(the_depth, the_tree)
            @depth = the_depth
            @tree = the_tree
            if @left
                @left.set_self_and_children(the_depth+1, the_tree)
            end
            if @right
                @right.set_self_and_children(the_depth+1, the_tree)
            end
                
            @tree.check_and_set_depth(the_depth)
            self
        end
        def change_self(other_node)
            other_node.parent = @parent
            other_node.set_self_and_children(@depth, @tree)
            if node_position==:left
                @parent.left = other_node
            elsif node_position==:right
                @parent.right = other_node
            else # it is the root
                @tree.root = other_node
            end
            other_node
        end
        def inspect()
            # result = "  " * @depth + "value:#{@value}, is_leaf:#{@is_leaf}"
            # result
            to_hash()
        end
        def ==(other)
            return false if other == nil
            @value == other.value and @is_leaf == other.is_leaf and @left == other.left and @right == other.right
        end
        # def to_hash()
        #     the_hash = {:value => @value}
        #     if not @is_leaf
        #         the_hash[:children] = [@left.to_hash, @right.to_hash]
        #     end
        #     the_hash
        # end
        # def self.from_hash(the_hash)
        #     is_leaf = false
        #     if the_hash[:children]
        #         is_leaf = true
        #     end
        #     new_node = BinaryTreeNode.new(the_hash[:value], is_leaf)
        #     if is_leaf
        #         new_node.add_left(the_hash[:children][0])
        #         new_node.add_right(the_hash[:children][1])
        #     end

        # end
        def self.from_hash(the_hash)
            # the_hash.pptl()
            return BinaryTreeNode.new(the_hash["value"], the_hash["is_leaf"])
        end
        def to_hash()
            return {"value"=>self.value, "is_leaf"=>self.is_leaf}
        end
        def add_child_from_list(the_list)
            next_node = BinaryTreeNode.from_hash(the_list.shift())
            self.add_child_node(next_node)
            # self.ptl()
            # self.left.pt()
            # self.right.pt()
            return next_node if the_list.size == 0
            father_node = next_node.find_father()
            # father_node.pt()
            father_node.add_child_from_list(the_list)
        end
        def add_child_node(child_node)
            if @left == nil
                @left = child_node
                child_node.node_position = :left
            elsif @right == nil
                @right = child_node 
                child_node.node_position = :right
            else
                raise BinaryTreeException.new(
                    "The node alread had two children, so cannot add one more!")
            end
            child_node.parent = self
            child_node.depth = self.depth + 1
            child_node.tree = self.tree
            if @tree
                @tree.check_and_set_depth(child_node.depth)
            end
            # self.ptl()
            # @tree.depth.ptl()

            self
        end
        def find_father()
            if @is_leaf==false and (@left == nil or @right == nil)
                return self
            end
            return @parent.find_father()
        end

    end
    class BinaryTree
        attr_accessor :root
        attr_reader :depth
        def initialize(root_value:nil, is_leaf:false, root_node:nil)
            # self.pt
            # root_value.ptl
            if root_value
                # 1.ptl()
                @root = BinaryTreeNode.new(root_value, is_leaf, self, nil, nil)
            elsif root_node
                # 2.ptl()
                @root = root_node
            end
            @depth = 0
                
            # @count = 1
        end
        # def to_hash()
        #     # search().map do |node|
        #     #     node.to_hash()
        #     # end
        #     @root.to_hash
        # end
        def inspect()
            # search().inspect()
            "GA::BinaryTree.from_depth_first_list(" +
                to_depth_first_list().inspect()+ ")"
        end
        def ==(other)
            return false if other == nil
            self.to_depth_first_list().to_s == other.to_depth_first_list().to_s
        end
        def check_and_set_depth(the_depth)
            if the_depth > @depth
                @depth = the_depth
            end

            self
        end
        def search(the_depth:-1, search_type: :depth_first_search)
            raise BinaryTreeException.new(
                "The depth is out of maximum #{@depth}") if the_depth > @depth
            if the_depth and the_depth > 0
                root.search_same_depth(the_depth)
            else
                if search_type ==  :breadth_first_search
                    root.breadth_first_search
                else
                    root.depth_first_search
                end
            end
        end
        def self.from_depth_first_list(the_list)
            copied_list = the_list.clone()
            root_node = BinaryTreeNode.from_hash(copied_list.shift())
            the_tree = BinaryTree.new(root_node:root_node)
            root_node.tree = the_tree
            # the_tree.ptl()
            root_node.add_child_from_list(copied_list)
            # root_node.pptl()
            # if not root_node.is_leaf
            #     next_node = BinaryTreeNode.from_hash(the_list.shift())
            #     # next_node.pptl()
            #     root_node.add_child_node(root_node)
            #     if next_node.is_leaf
            #         father_node = next_node.find_father()
            #     else 
            #         father_node = next_node
            #     end
            #     father_node.add_child_from_list(the_list)
            # end
            return the_tree
        end
        def to_depth_first_list()
            search(search_type: :depth_first_search)

        end
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'

    describe GA::BinaryTreeNode do
        it "from_hash, to_hash" do
            the_hash = {"value"=>"a", "is_leaf"=>false}
            GA::BinaryTreeNode.from_hash(the_hash).to_hash().must_equal(the_hash)
        end
    end

    describe GA::BinaryTree do

        before do
            # @tree_2_depth = GA::BinaryTree.new(root_value:'a')
            # @tree_2_depth.root.add_left(value:'b', is_leaf:false)
            #     .add_right(value:'c', is_leaf:false)
            # @tree_2_depth.root.left.add_left(value:'b1').add_right(value:'d')
            # @tree_2_depth.root.right.add_left(value:'c1').add_right(value:'e')
            # @tree_2_depth.pt()

            @tree_2_depth = GA::BinaryTree.from_depth_first_list([
                {"value"=>"a", "is_leaf"=>false}, 
                    {"value"=>"b", "is_leaf"=>false}, 
                        {"value"=>"b1", "is_leaf"=>true}, 
                        {"value"=>"d", "is_leaf"=>true}, 
                    {"value"=>"c", "is_leaf"=>false}, 
                        {"value"=>"c1", "is_leaf"=>true}, 
                        {"value"=>"e", "is_leaf"=>true}])
        end

        it "search" do
            @tree_2_depth.depth.must_equal(2)

            # @tree_2_depth.search(the_depth:1).to_s.must_equal(
            #     '[  value:b, is_leaf:false,   value:c, is_leaf:false]')
            # @tree_2_depth.search(the_depth:2).to_s.must_equal(
            #     '[    value:b1, is_leaf:true,     value:d, is_leaf:true,'+
            #     '     value:c1, is_leaf:true,     value:e, is_leaf:true]')

        #     @tree_2_depth.search(search_type: :breadth_first_search).to_s.must_equal(
        #         '[value:a, is_leaf:false,'+
        #         '   value:b, is_leaf:false,'+
        #         '   value:c, is_leaf:false,'+
        #         '     value:b1, is_leaf:true,'+
        #         '     value:d, is_leaf:true,'+
        #         '     value:c1, is_leaf:true,'+
        #         '     value:e, is_leaf:true]'
        #         )

        #     @tree_2_depth.search(search_type: :depth_first_search).to_s.must_equal(
        #         '[value:a, is_leaf:false,'+
        #         '   value:b, is_leaf:false,'+
        #         '     value:b1, is_leaf:true,'+
        #         '     value:d, is_leaf:true,'+
        #         '   value:c, is_leaf:false,'+
        #         '     value:c1, is_leaf:true,'+
        #         '     value:e, is_leaf:true]'
        #         )
        #     # @tree_2_depth.search(search_type: :depth_first_search).ptl()
        end

        it "depth" do
            @tree_2_depth.depth.must_equal(2)
        end

        # it "change" do
            
        #     node_list = @tree_2_depth.search(search_type: :depth_first_search)
        #     old_node = node_list[2]
        #     changed_node = old_node.change_self(GA::BinaryTreeNode.new('new', true))
        #     changed_node.tree.object_id.must_equal(@tree_2_depth.object_id)
        #     changed_node.parent.object_id.must_equal(old_node.parent.object_id)
        #     changed_node.depth.must_equal(old_node.depth)
        #     # @tree_2_depth.search(search_type: :depth_first_search).ppt()

        #     new_tree = GA::BinaryTree.new('h')
        #     new_tree.root.add_left(value:'i', is_leaf:false)
        #     new_tree.root.left.add_left(value:'j', is_leaf:true)
        #     old_node = node_list[4]
        #     changed_node = old_node.change_self(new_tree.root)
        #     changed_node.tree.object_id.must_equal(@tree_2_depth.object_id)
        #     changed_node.parent.object_id.must_equal(old_node.parent.object_id)
        #     changed_node.left.left.tree.object_id.must_equal(@tree_2_depth.object_id)
        #     @tree_2_depth.depth.must_equal(3)
        #     # @tree_2_depth.search(search_type: :depth_first_search).ppt()

        # end

        it "from_depth_first_list" do
            the_list= [
                {"value"=>"a", "is_leaf"=>false},
                   {"value"=>"b", "is_leaf"=>true},
                   {"value"=>"c", "is_leaf"=>true}]
            the_tree = GA::BinaryTree.from_depth_first_list(the_list)
            # Notice: cannot use the_tree.to_depth_first_list().must_equal(the_list)
            # bacause although their print result looks same:
            # [{"value"=>"a", "is_leaf"=>false}, {"value"=>"b", "is_leaf"=>true}, {"value"=>"c", "is_leaf"=>true}]
            # but in the_tree.to_depth_first_list(), every {"value"=>"a", "is_leaf"=>false} is an instance of TreeNode
            # not the Hash.
            the_tree.must_equal(GA::BinaryTree.from_depth_first_list([
                {"value"=>"a", "is_leaf"=>false},
                   {"value"=>"b", "is_leaf"=>true},
                   {"value"=>"c", "is_leaf"=>true}]))

            the_list= [
                {"value"=>"a", "is_leaf"=>false},
                   {"value"=>"b", "is_leaf"=>false},
                     {"value"=>"b1", "is_leaf"=>true},
                     {"value"=>"b2", "is_leaf"=>true},
                   {"value"=>"c", "is_leaf"=>false},
                     {"value"=>"c1", "is_leaf"=>true},
                     {"value"=>"c2", "is_leaf"=>true}]
            the_tree = GA::BinaryTree.from_depth_first_list(the_list)
            the_tree.depth.must_equal(2)
            the_tree.must_equal(GA::BinaryTree.from_depth_first_list([
                {"value"=>"a", "is_leaf"=>false},
                   {"value"=>"b", "is_leaf"=>false},
                     {"value"=>"b1", "is_leaf"=>true},
                     {"value"=>"b2", "is_leaf"=>true},
                   {"value"=>"c", "is_leaf"=>false},
                     {"value"=>"c1", "is_leaf"=>true},
                     {"value"=>"c2", "is_leaf"=>true}]
                 ))

        end
    end
end