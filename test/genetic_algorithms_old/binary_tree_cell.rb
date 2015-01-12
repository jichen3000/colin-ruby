direc = File.dirname(__FILE__)
require "#{direc}/binary_tree_with_variables"


module ArithmeticMethod
    def am_add(a, b)
        a + b
    end
    def am_sub(a, b)
        a - b
    end
    def am_mul(a, b)
        a * b
    end
    def am_div(a, b)
        a / b
    end
end


module GA
    module BinaryTreeCell
        class << self
            include ArithmeticMethod
        end
        class CalculateException < Exception
        end
        def self.set_options(options={})
            @@functions = [:am_add, :am_sub, :am_mul, :am_div]
            @@variables = [:x, :x2]
            @@constant_threshold = 5
            @@mul_value = @@constant_threshold / 0.5

            @@node_terminal_value_is_const_probability = 0.75
            @@node_value_is_terminal_probility = 0.5

            @@stop_fitness_threshold = 0.1
            @@stop_iteration_count = 100

            variable_range = -@@constant_threshold..@@constant_threshold
            step_value = 0.1
            variable_procs = [lambda {|x| x}, lambda {|x| x**2}]
            @@variable_values = generate_variable_values(
                variable_range, step_value, variable_procs)

        end
        def self.get_random_function()
            @@functions[rand(@@functions.size)]
        end
        def self.get_random_variable()
            @@variables[rand(@@variables.size)]
        end
        def self.get_random_constant()
            (rand() - 0.5) * @@mul_value
        end
        def self.create_random_node_terminal_value()
            cur_prob = rand()
            if cur_prob <= @@node_terminal_value_is_const_probability
                return get_random_constant()
            else
                return get_random_variable()
            end
        end
        def self.create_random_node()
            cur_prob = rand()
            if cur_prob <= @@node_value_is_terminal_probility
                return BinaryNode.new(create_random_node_terminal_value(), true)
            else
                return BinaryNode.new(get_random_function(), false)
            end
        end
        def self.generate_randomly(the_depth)

            # root
            if the_depth == 0
                return BinaryTree.new(BinaryNode.new(create_random_node_terminal_value(), true))
            end
            tree = BinaryTree.new(BinaryNode.new(get_random_function(), false))

            # nodes in middle layers
            1.upto(the_depth-1) do |depth_index|
                tree.search(the_depth:depth_index-1).each do |node|
                    if not node.is_leaf
                        # BinaryNode.new(*create_random_node())
                        node.add_child_node(create_random_node())
                            .add_child_node(create_random_node())
                    end
                end 
            end

            # nodes in the last layers
            tree.search(the_depth:the_depth-1).each do |node|
                if not node.is_leaf
                    node.add_leaf_child_by_value(
                            create_random_node_terminal_value())
                        .add_leaf_child_by_value(
                            create_random_node_terminal_value())
                    # node.add_left(value:create_random_node_terminal_value(),
                    #     is_leaf:true)
                    # node.add_right(value:create_random_node_terminal_value(),
                    #     is_leaf:true)
                end
            end 

            tree
        end
        def self.from_hash_list(hash_list)
            BinaryTree.from_depth_first_list(hash_list)
        end
        def self.inspect(the_tree)
        end
        def self.generate_code_list(the_node)
            codes = []
            if the_node.is_leaf
                codes << the_node.value.to_s
            else
                codes << the_node.value.to_s
                codes << "("
                codes += generate_code_list(the_node.left)
                codes << ","
                codes += generate_code_list(the_node.right)
                codes << ")"
            end
            codes
        end
        def self.package_proc_code(proc_content)
            "proc { | "+@@variables.join(", ")+" | "+
                proc_content + " }"
        end
        def self.call_proc(the_proc, variable_values)
            if variable_values.size != @@variables.size
                raise CalculateException.new("Size of the variables are not match! "+
                    "There should be #{@@variables.size}, but #{variable_values.size} now!")
            end

            the_proc.call(*variable_values)        
        end

        def self.generate_proc(binary_tree)

            code_list = generate_code_list(binary_tree.root)
            proc_code = package_proc_code(code_list.join())
            eval(proc_code)
        end

        def self.generate_variable_values(variable_range, step_value, variable_procs)
            variable_range.step(step_value).map do |cur_value|
                variable_procs.map {|cur_proc| cur_proc.call(cur_value)}
            end
        end

        def self.cal_difference(the_proc, standard_proc, variable_values)
            variable_values.map do |cur_values|
                (standard_proc.call(*cur_values) - the_proc.call(*cur_values)).abs
            end.inject(:+)
        end

        def self.cal_fitness(binary_tree, standard_proc)
            cal_difference(generate_proc(binary_tree), standard_proc, @@variable_values)
        end

        def self.mutate(binary_tree)
            depth_first_list = binary_tree.to_depth_first_list
            rand_index = rand(depth_first_list.size)
            the_node = depth_first_list[rand_index]

            left_depth = binary_tree.depth - the_node.depth
            new_tree = generate_randomly(left_depth)
            the_node.change_self(new_tree.root)
            binary_tree
        end

    end
    class BinaryTree
        include BinaryTreeCell
        self.set_options()
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'
    include ArithmeticMethod

    describe GA::BinaryTreeCell do

        before do
            GA::BinaryTreeCell.set_options()
        end
        it "get_random_function" do
            srand(1)
            GA::BinaryTreeCell.get_random_function().must_equal(:am_sub)
        end
        it "get_random_constant" do
            srand(1)
            GA::BinaryTreeCell.get_random_constant().must_equal(-0.82977995297426)
        end
        it "create_random_node_terminal_value" do
            srand(1)
            GA::BinaryTreeCell.create_random_node_terminal_value().must_equal(2.2032449344215808)

            srand(4)
            GA::BinaryTreeCell.create_random_node_terminal_value().must_equal(:x2)
        end
        it 'generate_randomly' do
            # GA::BinaryTreeCell.generate_randomly()
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            binary_tree.must_equal(GA::BinaryTree.from_depth_first_list([
                {:value=>:am_mul, :is_leaf=>false}, 
                    {:value=>:x, :is_leaf=>true}, 
                    {:value=>:am_sub, :is_leaf=>false}, 
                        {:value=>-4.812519913495682, :is_leaf=>true}, 
                        {:value=>-2.5211170277396446, :is_leaf=>true}]))
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(0)
            binary_tree.must_equal(GA::BinaryTree.from_depth_first_list([
                {:value=>2.0814782261810483, :is_leaf=>true}]))
        end

        it "generate_code_list" do
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            # tree.pt
            GA::BinaryTreeCell.generate_code_list(binary_tree.root).join.must_equal(
                "am_mul(x,am_sub(-4.812519913495682,-2.5211170277396446))")
        end

        it "package_proc_code" do
            proc_content = "am_mul(x,am_sub(-4.812519913495682,-2.5211170277396446))"
            proc_code = "proc { | x, x2 | #{proc_content} }"
            GA::BinaryTreeCell.package_proc_code(proc_content).must_equal(proc_code)
            eval(proc_code).class.must_equal(Proc)
        end

        it "call_proc" do
            # notice, when you eval the proc, in this scope, it must have the functions
            # which will be used in the proc, otherwise, when you ran it, 
            # it would report cannot find the method.
            the_proc = eval("proc { | x, x2 | am_mul(x,am_sub(-4.0,-2.0)) }")
            GA::BinaryTreeCell.call_proc(the_proc, [2,4]).must_equal(-4.0)

            lambda { GA::BinaryTreeCell.call_proc(the_proc, [2,4,1]) }.must_raise(
                GA::BinaryTreeCell::CalculateException)
        end

        it "generate_proc" do
            srand(3)
            tree = GA::BinaryTreeCell.generate_randomly(2)
            GA::BinaryTreeCell.generate_proc(tree).call([2,4]).must_equal(-4.582805771512074)
        end

        it "generate_variable_values" do
            variable_range = -0.2..0.2
            step_value = 0.1
            variable_procs = [lambda {|x| x}, lambda {|x| x**2}]
            GA::BinaryTreeCell.generate_variable_values(
                variable_range, step_value, variable_procs).must_equal(
                [[-0.2, 0.04000000000000001],
                 [-0.1, 0.010000000000000002],
                 [0.0, 0.0],
                 [0.10000000000000003, 0.010000000000000007],
                 [0.2, 0.04000000000000001]])
        end

        it "cal_difference" do
            variable_values =
                [[-0.2, 0.04000000000000001],
                 [-0.1, 0.010000000000000002],
                 [0.0, 0.0],
                 [0.10000000000000003, 0.010000000000000007],
                 [0.2, 0.04000000000000001]]
            the_proc = eval("proc { | x, x2 | am_mul(x,am_sub(-4.0,-2.0)) }")
            standard_proc = eval("proc { | x, x2 | x2 + x + 1 }")
            GA::BinaryTreeCell.cal_difference(the_proc, standard_proc, variable_values).must_equal(5.1)
        end

        it "cal_fitness" do
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            standard_proc = eval("proc { | x, x2 | x2 + x + 1 }")
            GA::BinaryTreeCell.cal_fitness(binary_tree, standard_proc).must_equal(1019.0823675978681)
        end

        it "mutate" do
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            binary_tree.must_equal(GA::BinaryTree.from_depth_first_list([
                {:value=>:am_mul, :is_leaf=>false}, 
                    {:value=>:x, :is_leaf=>true}, 
                    {:value=>:am_sub, :is_leaf=>false}, 
                        {:value=>-4.812519913495682, :is_leaf=>true}, 
                        {:value=>-2.5211170277396446, :is_leaf=>true}]))
            # it will change the node which index == 2
            srand(3)
            GA::BinaryTreeCell.mutate(binary_tree).must_equal(
                GA::BinaryTree.from_depth_first_list([
                    {:value=>:am_mul, :is_leaf=>false}, 
                        {:value=>:x, :is_leaf=>true}, 
                        {:value=>:am_add, :is_leaf=>false}, 
                            {:value=>-2.0909526108705565, :is_leaf=>true}, 
                            {:value=>3.929469543476547, :is_leaf=>true}]))
            # srand(3)
            # binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            srand(1)
            # it will change the node which index == 2
            GA::BinaryTreeCell.mutate(binary_tree).must_equal(
                GA::BinaryTree.from_depth_first_list([
                    {:value=>:am_mul, :is_leaf=>false}, 
                        {:value=>:x, :is_leaf=>true}, 
                        {:value=>:am_add, :is_leaf=>false}, 
                            {:value=>-4.998856251826551, :is_leaf=>true}, 
                            {:value=>3.929469543476547, :is_leaf=>true}]))
        end

    end
end