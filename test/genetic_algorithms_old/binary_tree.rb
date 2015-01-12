module GA
    class BinaryTreeException < Exception
    end

    class BinaryNode
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

        def change_self(other_node)
            other_hash_list = other_node.to_depth_first_list.map {|i| i.to_hash()}
            @value = other_node.value
            @is_leaf = other_node.is_leaf
            @left = nil
            @right = nil
            if other_hash_list.size > 1
                other_hash_list.shift()
                add_child_from_list(other_hash_list)
            end
            self
        end
        def inspect(with_children=false)
            the_list = to_depth_first_list().map do |the_item|
                the_item.to_hash()
            end
            "GA::BinaryNode.from_depth_first_list(" +
                the_list.inspect()+ ")"
        end
        def ==(other)
            return false if other == nil
            return false if not other.is_a?(BinaryNode)
            @value == other.value and @is_leaf == other.is_leaf and @left == other.left and @right == other.right
        end
        def self.from_hash(the_hash)
            # the_hash.pptl()
            return BinaryNode.new(the_hash[:value], the_hash[:is_leaf])
        end
        def to_hash()
            return {value: self.value, is_leaf: self.is_leaf}
        end
        def add_child_from_list(the_list)
            raise BinaryTreeException.new(
                "The list must have at least one item!") if the_list.size < 1
            next_node = BinaryNode.from_hash(the_list.shift())
            self.add_child_node(next_node)
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

            self
        end
        def add_child_from_hash(node_hash)
            child_node = BinaryNode.from_hash(node_hash)
            add_child_node(child_node)
            self
        end
        def add_leaf_child_by_value(the_value)
            child_node = BinaryNode.new(the_value, true)
            add_child_node(child_node)
            self
        end
        def find_father()
            if @is_leaf==false and (@left == nil or @right == nil)
                return self
            end
            return @parent.find_father()
        end
        def self.from_depth_first_list(the_list)
            copied_list = the_list.clone()
            root_node = BinaryNode.from_hash(copied_list.shift())
            if copied_list.size > 0
                root_node.add_child_from_list(copied_list)
            end
            return root_node
        end
        def to_depth_first_list()
            depth_first_search()
        end
        def validate()
        end

    end
    class BinaryTree
        attr_accessor :root

        def initialize(root_node)
            @root = root_node
            # root_node.tree = self
            @root.to_depth_first_list().each {|i| i.tree=self}
        end

        def depth()
            to_depth_first_list().map { |i| i.depth}.max
        end

        def count()
            to_depth_first_list().count
        end

        def inspect()
            node_str = @root.inspect()
            node_str.sub("BinaryNode.from_depth_first_list","BinaryTree.from_depth_first_list")
        end

        def ==(other)
            return false if other == nil
            self.to_depth_first_list().to_s == other.to_depth_first_list().to_s
        end

        def search(the_depth: nil, search_type: nil, the_value: nil)
            # raise BinaryTreeException.new(
            #     "The depth is out of maximum #{@depth}") if the_depth > @depth
            if the_depth
                raise BinaryTreeException.new(
                    "The depth #{the_depth} must larger than 0!") if the_depth < 0
                max_depth = depth()
                raise BinaryTreeException.new(
                    "The depth #{the_depth} is out of maximum #{max_depth}!") if the_depth > max_depth
                return root.search_same_depth(the_depth)
            end 
            if search_type                
                if search_type ==  :breadth_first
                    return root.breadth_first_search
                elsif search_type ==  :depth_first
                    return root.depth_first_search
                else
                    raise BinaryTreeException.new(
                        "Don't support the search type #{search_type}! Only breadth_first and depth_first")
                end
            end
            if the_value
                depth_first_list = search(search_type: :depth_first)
                return depth_first_list.select {|i| i.value == the_value}
            end
            raise BinaryTreeException.new(
                "Please input at least one argument! " +
                method(__method__).parameters.map{|i| i[1].to_s}.join(", "))
        end
        def self.from_depth_first_list(the_list)
            copied_list = the_list.clone()
            root_node = BinaryNode.from_hash(copied_list.shift())
            the_tree = BinaryTree.new(root_node)
            root_node.tree = the_tree
            return the_tree if copied_list.size == 0
            root_node.add_child_from_list(copied_list)
            return the_tree
        end
        def to_depth_first_list()
            search(search_type: :depth_first)

        end
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'


    the_list= [
        {value: "a", is_leaf: false},
           {value: "b", is_leaf: true},
           {value: "c", is_leaf: false},
                {value: "c1", is_leaf: true},
                {value: "c2", is_leaf: true}]


    describe GA::BinaryNode do
        it "self.from_depth_first_list and inspect" do
            tree_node = GA::BinaryNode.from_depth_first_list(the_list)
            tree_node.must_equal(GA::BinaryNode.from_depth_first_list(the_list))

            tree_node.depth.must_equal(0)
            tree_node.left.depth.must_equal(1)
            tree_node.right.depth.must_equal(1)

            no_leaf_list = [
                {value: "n", is_leaf: false},
                   {value: "n1", is_leaf: false},
                   {value: "n2", is_leaf: false}
            ]

        end

        it "chagne_self" do
            new_list = [
                {value: "n", is_leaf: false},
                   {value: "n1", is_leaf: true},
                   {value: "n2", is_leaf: true}
            ]
            n_node = GA::BinaryNode.from_depth_first_list(new_list)
            n_node.depth.must_equal(0)
            n_node.parent.must_equal(nil)
            # n_node.ptl
            # n_node.right.ptl
            n_node.right.depth.must_equal(1)
            n_tree = GA::BinaryTree.new(n_node)
            n_node.tree.must_equal(n_tree)

            tree_node = GA::BinaryNode.from_depth_first_list(the_list)
            new_tree = GA::BinaryTree.new(tree_node)
            b_node = tree_node.left
            b_node.depth.must_equal(1)
            new_b_node = b_node.change_self(n_node)
            new_b_node.must_equal(b_node)
            new_b_node.must_equal(GA::BinaryNode.from_depth_first_list([
                {:value=>"n", :is_leaf=>false}, {:value=>"n1", :is_leaf=>true}, {:value=>"n2", :is_leaf=>true}]))
            new_b_node.depth.must_equal(1)
            new_b_node.parent.must_equal(tree_node)
            new_b_node.right.depth.must_equal(2)
            new_b_node.right.tree.must_equal(new_tree)


            # c2_node = 
            # tree_node.ptl
            # n_node.ptl
        end

    end
    describe GA::BinaryTree do
        tree_node = GA::BinaryNode.from_depth_first_list(the_list)
        the_tree = GA::BinaryTree.new(tree_node)

        it "self.from_depth_first_list and inspect" do
            the_tree.must_equal(GA::BinaryTree.from_depth_first_list(the_list))
            # the_tree.ptl
            the_tree.depth().must_equal(2)
            the_tree.count().must_equal(5)
            tree_node.tree.must_equal(the_tree)
            tree_node.left.tree.must_equal(the_tree)
            tree_node.right.left.tree.must_equal(the_tree)
            tree_node.right.right.tree.must_equal(the_tree)

            GA::BinaryTree.from_depth_first_list([
                {:value=>2.0814782261810483, :is_leaf=>true}]).inspect.must_equal(
                "GA::BinaryTree.from_depth_first_list([{:value=>2.0814782261810483, :is_leaf=>true}])")

        end

        it "search" do
            the_tree.search(search_type: :depth_first).map{|i| i.to_hash}.must_equal(the_list)

            the_tree.search(the_depth:1).map{|i| i.to_hash}.must_equal(
                [{value: "b", is_leaf: true}, {value: "c", is_leaf: false}])
            the_tree.search(the_depth:2).map{|i| i.to_hash}.must_equal(
                [{value: "c1", is_leaf: true}, {value: "c2", is_leaf: true}])

            the_tree.search(the_value: "c").must_equal([
                GA::BinaryNode.from_depth_first_list([
                    {:value=>"c", :is_leaf=>false}, {:value=>"c1", :is_leaf=>true}, {:value=>"c2", :is_leaf=>true}])])
        end
    end

end