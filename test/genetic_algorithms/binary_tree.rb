module GA
    class BinaryTreeException < Exception
    end


    class BinaryTreeNode
        attr_accessor :parent, :left, :right, :value, :is_leaf, :depth, :tree
        def initialize(value=nil, tree=nil, parent=nil, is_leaf=true)
            raise BinaryTreeException.new(
                "Node's value cannot be null!") if not value
            raise BinaryTreeException.new(
                "Node's tree cannot be null!") if not tree
            # tree.pt
            @value = value
            @tree = tree
            @parent = parent
            @is_leaf = is_leaf
            @depth = @parent ? @parent.depth + 1 : 0
        end
        def add_child(node_type, value, is_leaf)
            # self.is_leaf = false
            raise BinaryTreeException.new(
                "The leaf node cannot have children!") if @is_leaf
            child = BinaryTreeNode.new(value, self.tree, self, is_leaf)
            if node_type == :left
                @left = child
            else
                @right = child
            end
            # child.value.pt
            child.tree.check_and_set_depth(child.depth)

            self
        end
        def add_left(value:nil, is_leaf:true)
            add_child(:left, value, is_leaf)
        end
        def add_right(value:nil, is_leaf:true)
            add_child(:right, value, is_leaf)
        end
        def search_same_depth(depth)
            nodes = []
            if @depth == depth
                nodes << self
            else
                nodes += @left.search_same_depth(depth) if @left
                nodes += @right.search_same_depth(depth) if @right
            end

            nodes
        end
        def breadth_first_search()
            nodes = []
            # add root
            nodes << self if @depth == 0

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
        def inspect()
            result = "  " * depth + "value:#{@value}, is_leaf:#{@is_leaf}"
            # if not @is_leaf
            #     result += "\n"+@left.inspect() + 
            #         "\n" + @right.inspect()
            # end
            result
        end
    end
    class BinaryTree
        attr_accessor :root
        attr_reader :depth
        def initialize(root_value)
            # self.pt
            @root = BinaryTreeNode.new(root_value, self, nil, false)
            @root.depth = 0
            @depth = 0
        end
        def inspect()
            search().inspect
        end
        def check_and_set_depth(depth)
            if depth > @depth
                @depth = depth
            end

            self
        end
        def search(depth:-1, search_type: :breadth_first_search)
            raise BinaryTreeException.new(
                "The depth is out of maximum #{@depth}") if depth > @depth
            if depth and depth > 0
                root.search_same_depth(depth)
            else
                if search_type ==  :breadth_first_search
                    root.breadth_first_search
                else
                    root.depth_first_search
                end
            end
        end
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'

    describe GA::BinaryTree do

        before do
            @tree_2_depth = GA::BinaryTree.new('a')
            @tree_2_depth.root.add_left(value:'b', is_leaf:false)
                .add_right(value:'c', is_leaf:false)
            @tree_2_depth.root.left.add_left(value:'b1').add_right(value:'d')
            @tree_2_depth.root.right.add_left(value:'c1').add_right(value:'e')
        end

        it "search" do
            @tree_2_depth.depth.must_equal(2)

            @tree_2_depth.search(depth:1).to_s.must_equal(
                '[  value:b, is_leaf:false,   value:c, is_leaf:false]')
            @tree_2_depth.search(depth:2).to_s.must_equal(
                '[    value:b1, is_leaf:true,     value:d, is_leaf:true,'+
                '     value:c1, is_leaf:true,     value:e, is_leaf:true]')

            @tree_2_depth.search.ppt

            @tree_2_depth.search(search_type: :depth_first_search).ppt
        end

        
    end
end