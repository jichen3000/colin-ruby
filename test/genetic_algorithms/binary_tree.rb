module GA
    class BinaryTreeException < Exception
    end


    class BinaryTreeNode
        attr_accessor :parent, :left, :right, :value, :is_leaf, :tree
        attr_reader :node_position, :depth
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
        def add_child(node_position, value, is_leaf)
            # self.is_leaf = false
            raise BinaryTreeException.new(
                "The leaf node cannot have children!") if @is_leaf
            child = BinaryTreeNode.new(value, is_leaf, self.tree, self, node_position)
            if node_position == :left
                @left = child
            else
                @right = child
            end
            # child.value.pt
            @tree.check_and_set_depth(child.depth)
            @tree.add_count()

            self
        end
        def add_left(value:nil, is_leaf:true)
            add_child(:left, value, is_leaf)
        end
        def add_right(value:nil, is_leaf:true)
            add_child(:right, value, is_leaf)
        end
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
            result = "  " * @depth + "value:#{@value}, is_leaf:#{@is_leaf}"
            # if not @is_leaf
            #     result += "\n"+@left.inspect() + 
            #         "\n" + @right.inspect()
            # end
            result
        end
    end
    class BinaryTree
        attr_accessor :root
        attr_reader :depth, :count
        def initialize(root_value)
            # self.pt
            @root = BinaryTreeNode.new(root_value, false, self, nil, nil)
            @depth = 0
            @count = 1
        end
        def inspect()
            search().inspect()
        end
        def check_and_set_depth(the_depth)
            if the_depth > @depth
                @depth = the_depth
            end

            self
        end
        def add_count()
            @count += 1
            self
        end
        def del_count()
            @count -= 1
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

            @tree_2_depth.search(the_depth:1).to_s.must_equal(
                '[  value:b, is_leaf:false,   value:c, is_leaf:false]')
            @tree_2_depth.search(the_depth:2).to_s.must_equal(
                '[    value:b1, is_leaf:true,     value:d, is_leaf:true,'+
                '     value:c1, is_leaf:true,     value:e, is_leaf:true]')

            @tree_2_depth.search(search_type: :breadth_first_search).to_s.must_equal(
                '[value:a, is_leaf:false,'+
                '   value:b, is_leaf:false,'+
                '   value:c, is_leaf:false,'+
                '     value:b1, is_leaf:true,'+
                '     value:d, is_leaf:true,'+
                '     value:c1, is_leaf:true,'+
                '     value:e, is_leaf:true]'
                )

            @tree_2_depth.search(search_type: :depth_first_search).to_s.must_equal(
                '[value:a, is_leaf:false,'+
                '   value:b, is_leaf:false,'+
                '     value:b1, is_leaf:true,'+
                '     value:d, is_leaf:true,'+
                '   value:c, is_leaf:false,'+
                '     value:c1, is_leaf:true,'+
                '     value:e, is_leaf:true]'
                )
        end

        it "depth" do
            @tree_2_depth.depth.must_equal(2)
        end

        it "count" do
            @tree_2_depth.count.must_equal(7)
        end

        it "change" do
            
            node_list = @tree_2_depth.search(search_type: :depth_first_search)
            old_node = node_list[2]
            changed_node = old_node.change_self(GA::BinaryTreeNode.new('new', true))
            changed_node.tree.object_id.must_equal(@tree_2_depth.object_id)
            changed_node.parent.object_id.must_equal(old_node.parent.object_id)
            changed_node.depth.must_equal(old_node.depth)
            # @tree_2_depth.search(search_type: :depth_first_search).ppt()

            new_tree = GA::BinaryTree.new('h')
            new_tree.root.add_left(value:'i', is_leaf:false)
            new_tree.root.left.add_left(value:'j', is_leaf:true)
            old_node = node_list[4]
            changed_node = old_node.change_self(new_tree.root)
            changed_node.tree.object_id.must_equal(@tree_2_depth.object_id)
            changed_node.parent.object_id.must_equal(old_node.parent.object_id)
            changed_node.left.left.tree.object_id.must_equal(@tree_2_depth.object_id)
            @tree_2_depth.depth.must_equal(3)
            # @tree_2_depth.search(search_type: :depth_first_search).ppt()

        end
    end
end