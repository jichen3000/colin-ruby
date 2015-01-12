def get_indexes(the_list)
    the_list.map.with_index {|x, index| index if x}.select{|x| x!=nil}
end

module GA
    class TreeException < Exception
    end


    class TreeNode
        attr_accessor :parent, :children, :value, :position, :depth
        # attr_reader :depth
        def initialize(value=nil, parent=nil)
            raise TreeException.new(
                "Node's value cannot be null!") if not value
            # raise TreeException.new(
            #     "Node's tree cannot be null!") if not tree
            # tree.pt
            @value = value
            @parent = parent
            @depth = @parent ? @parent.depth + 1 : 0
            @children = []
        end
        def add_child(child_node, position=nil)
            # @children ||= []
            if position
                if @children[position]
                    raise TreeException.new(
                        "There has been a child in this position #{position}!")
                end
                @children[position] = child_node
                child_node.position = position
            else
                @children.push(child_node) 
                child_node.position = @children.size()-1
            end
            child_node.parent = self
            child_node.depth = @depth + 1
            self
        end
        def to_hash()
            if @children and @children.size > 0
                {value: self.value, children_positions: get_indexes(@children)}
            else
                {value: self.value}
            end
        end
        def tree_depth()
            self.to_breadth_first_list().last.depth - self.depth
        end
        def to_depth_first_hash_list()
            to_depth_first_list().map{|item| item.to_hash}
        end
        def to_depth_first_list()
            results = []
            doing_stack = [self]
            while doing_stack.size > 0
                cur_node = doing_stack.pop()
                results.push(cur_node)
                cur_node.children.reverse.map do |item|
                    doing_stack.push(item) if item
                end
            end
            results
        end
        def self.from_depth_first_hash_list(node_list, root=nil, first_position=nil)
            cloned_list = node_list.clone()
            parent_node_stack = [root]
            if first_position
                child_position_stack = [first_position]
            else
                child_position_stack = []
            end
            # root = nil
            while cur_hash = cloned_list.shift()
                cur_node = TreeNode.new(cur_hash[:value])
                if parent_node = parent_node_stack.pop()
                    parent_node.add_child(cur_node, child_position_stack.pop())
                else
                    root = cur_node
                end
                if cur_hash[:children_positions]
                    cur_hash[:children_positions].reverse.map() do |item|
                        child_position_stack.push(item)
                        parent_node_stack.push(cur_node)
                    end
                end
            end
            root
        end
        def to_breadth_first_hash_list()
            to_breadth_first_list().map {|item| item.to_hash}
        end
        def to_breadth_first_list()
            doing_stack = [self]
            results = []
            while doing_stack.size > 0
                cur_node = doing_stack.shift()
                results.push(cur_node)
                cur_node.children.each do |item|
                    doing_stack.push(item) if item
                end
            end
            results
        end
        def self.from_breadth_first_hash_list(node_list, root=nil)
            cloned_list = node_list.clone()
            parent_node_stack = [root]
            child_position_stack = []
            # root = nil
            while cur_hash = cloned_list.shift()
                cur_node = TreeNode.new(cur_hash[:value])
                if parent_node = parent_node_stack.shift()
                    parent_node.add_child(cur_node, child_position_stack.shift())
                else
                    root = cur_node
                end
                if cur_hash[:children_positions]
                    cur_hash[:children_positions].map do |item|
                        child_position_stack.push(item)
                        parent_node_stack.push(cur_node)
                    end
                end
            end
            root
        end
        def inspect()
            "GA::TreeNode.from_depth_first_hash_list(" +
                to_depth_first_hash_list().inspect()+ ")"
        end
        def to_s()
            inspect()
        end
        def ==(other)
            return false if other == nil
            return false if not other.is_a?(TreeNode)
            inspect() == other.inspect()
        end
        def is_leaf()
            return @children.length == 0
        end
        def replace(other)
            other_hash_list = other.to_depth_first_hash_list()
            if self.parent == nil
                return TreeNode.from_depth_first_hash_list(other_hash_list)
            end
            self.parent.children[self.position] = nil
            TreeNode.from_depth_first_hash_list(
                    other_hash_list, self.parent, self.position)
            self
        end
        def clone()
            TreeNode.from_depth_first_hash_list(self.to_depth_first_hash_list)
        end
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    the_list= [
        {value: "a", children_positions: [0,1]},
           {value: "b", children_positions: [1]},
                {value: "b2", children_positions: nil},
           {value: "c", children_positions: [0,1]},
                {value: "c1", children_positions: nil},
                {value: "c2", children_positions: nil}]
    the_list_simple = [
        {value: "a", children_positions: [0,1]},
           {value: "b", children_positions: [1]},
                {value: "b2"},
           {value: "c", children_positions: [0,1]},
                {value: "c1"},
                {value: "c2"}]
    # the_list.pt

    describe GA::TreeNode do
        node_a = GA::TreeNode.new("a")
        node_b = GA::TreeNode.new("b")
        node_b2 = GA::TreeNode.new("b2")
        node_c = GA::TreeNode.new("c")
        node_c1 = GA::TreeNode.new("c1")
        node_c2 = GA::TreeNode.new("c2")
        node_a.add_child(node_b).add_child(node_c)
        node_c.add_child(node_c1).add_child(node_c2)
        node_b.add_child(node_b2, 1)
        it "to_hash" do
            node_a.to_hash().must_equal(
                {:value=>"a", :children_positions=>[0, 1]})
            node_c2.to_hash().must_equal({:value=>"c2",})
        end
        it "to_depth_first_hash_list" do
            node_a.to_depth_first_hash_list().must_equal(the_list_simple)       
        end
        it "from_depth_first_hash_list" do
            node_a_tree = GA::TreeNode.from_depth_first_hash_list(the_list_simple)
            node_a_tree1 = GA::TreeNode.from_depth_first_hash_list(the_list)
            node_a_tree.to_depth_first_hash_list.must_equal(the_list_simple)
            node_a_tree1.to_depth_first_hash_list.must_equal(the_list_simple)

            node_b_tree = GA::TreeNode.from_depth_first_hash_list([
                        {value: "0e", children_positions: [0]},
                           {value: "1f"}])
            node_b_tree.to_depth_first_hash_list.must_equal(
                    [{:value=>"0e", :children_positions=>[0]}, {:value=>"1f"}])
            node_c_tree = GA::TreeNode.from_depth_first_hash_list(the_list,
                    node_b_tree.children[0])
            node_c_tree.to_depth_first_hash_list.must_equal([
                    {:value=>"1f", :children_positions=>[0]}, 
                        {:value=>"a", :children_positions=>[0, 1]}, 
                            {:value=>"b", :children_positions=>[1]}, 
                                {:value=>"b2"}, 
                            {:value=>"c", :children_positions=>[0, 1]}, 
                                {:value=>"c1"}, 
                                {:value=>"c2"}])
            node_b_tree.to_depth_first_hash_list.must_equal(
                    [{:value=>"0e", :children_positions=>[0]},
                        {:value=>"1f", :children_positions=>[0]}, 
                            {:value=>"a", :children_positions=>[0, 1]}, 
                                {:value=>"b", :children_positions=>[1]}, 
                                    {:value=>"b2"}, 
                                {:value=>"c", :children_positions=>[0, 1]}, 
                                    {:value=>"c1"}, 
                                    {:value=>"c2"}])
        end
        it "to_breadth_first_hash_list" do
            node_a.to_breadth_first_hash_list().must_equal([
                {:value=>"a", :children_positions=>[0, 1]}, 
                    {:value=>"b", :children_positions=>[1]}, 
                    {:value=>"c", :children_positions=>[0, 1]}, 
                        {:value=>"b2"}, 
                        {:value=>"c1"}, 
                        {:value=>"c2"}])
        end
        it "from_breadth_first_hash_list" do
            breadth_first_list = [
                {:value=>"a", :children_positions=>[0, 1]}, 
                    {:value=>"b", :children_positions=>[1]}, 
                    {:value=>"c", :children_positions=>[0, 1]}, 
                        {:value=>"b2"}, 
                        {:value=>"c1"}, 
                        {:value=>"c2"}]
            # breadth_first_list.pt()
            node_a_tree = GA::TreeNode.from_breadth_first_hash_list(breadth_first_list)
            node_a_tree.to_breadth_first_hash_list.must_equal(breadth_first_list)
            # (1).must_equal(2)
        end
        it "tree_depth" do
            node_a_tree = GA::TreeNode.from_depth_first_hash_list(the_list_simple)
            node_a_tree.tree_depth.must_equal(2)
            node_a_tree.children[0].tree_depth.must_equal(1)
        end
        it "inspect" do
            node_a_tree = GA::TreeNode.from_depth_first_hash_list(the_list_simple)
            # node_a_tree.pt()
            node_a_tree.inspect.must_equal('GA::TreeNode.from_depth_first_hash_list([{:value=>"a", :children_positions=>[0, 1]}, {:value=>"b", :children_positions=>[1]}, {:value=>"b2"}, {:value=>"c", :children_positions=>[0, 1]}, {:value=>"c1"}, {:value=>"c2"}])')
        end
        it "is_leaf" do
            node_a_tree = GA::TreeNode.from_depth_first_hash_list(the_list_simple)
            node_a_tree.is_leaf.must_equal(false)
            node_a_tree.children[1].children[0].is_leaf.must_equal(true)
        end
        it "replace" do
            node_a_tree = GA::TreeNode.from_depth_first_hash_list(the_list_simple)
            node_a_tree.tree_depth.must_equal(2)
            node_b_tree = GA::TreeNode.from_depth_first_hash_list([
                        {value: "0e", children_positions: [0]},
                           {value: "1f", children_positions: [0]},
                                {value: "1g"}])
            node_a_tree.children[1].replace(node_b_tree)
            node_a_tree.to_depth_first_hash_list.must_equal([
                    {:value=>"a", :children_positions=>[0, 1]}, 
                        {:value=>"b", :children_positions=>[1]}, 
                            {:value=>"b2"}, 
                        {:value=>"0e", :children_positions=>[0]}, 
                            {:value=>"1f", :children_positions=>[0]}, 
                                {:value=>"1g"}])
            node_a_tree.tree_depth.must_equal(3)

            node_c_tree = GA::TreeNode.from_depth_first_hash_list([
                        {value: "0e", children_positions: [0, 1]},
                           {value: "1f0"},
                           {value: "1f1"}])
            node_a_tree.children[1].replace(node_c_tree)
            node_a_tree.to_depth_first_hash_list.must_equal([
                    {:value=>"a", :children_positions=>[0, 1]}, 
                        {:value=>"b", :children_positions=>[1]}, 
                            {:value=>"b2"}, 
                        {:value=>"0e", :children_positions=>[0, 1]}, 
                            {:value=>"1f0"}, 
                            {:value=>"1f1"}])
        end

        it "clone" do
            node_a_tree = GA::TreeNode.from_depth_first_hash_list(the_list_simple)
            node_a_clone = node_a_tree.clone()
            node_a_tree.object_id.wont_equal(node_a_clone.object_id)
            node_a_tree.must_equal(node_a_clone)
            node_a_clone.children[1].children[1].value = "m"
            node_a_tree.wont_equal(node_a_clone)
            # node_a_tree.pt
            # node_a_clone.pt
        end
    end


end