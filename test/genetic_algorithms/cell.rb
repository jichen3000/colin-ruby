direc = File.dirname(__FILE__)
require "#{direc}/binary_tree"

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
        def self.generate_variable_values(variable_range, step_value, variable_procs)
            variable_range.step(step_value).map do |cur_value|
                variable_procs.map {|cur_proc| cur_proc.call(cur_value)}
            end
        end
        def self.create_random_node()
            cur_prob = rand()
            if cur_prob <= @@node_value_is_terminal_probility
                return TreeNode.new(create_random_node_terminal_value())
            else
                return TreeNode.new(get_random_function())
            end
        end
        def self.is_leaf(the_node)
            return (not @@functions.include?(the_node.value))
        end
        def self.generate_randomly(the_depth)

            # root
            if the_depth == 0
                return TreeNode.new(create_random_node_terminal_value())
            end
            tree = TreeNode.new(get_random_function())

            doing_stack = [tree]

            # nodes in middle layers
            1.upto(the_depth-1) do |depth_index|
                previous_depth_leaf_nodes = doing_stack.clone()
                doing_stack = []
                previous_depth_leaf_nodes.each do |node|
                    2.times.each do
                        child_node = create_random_node()
                        node.add_child(child_node)
                        if not is_leaf(child_node)
                            doing_stack.push(child_node)
                        end
                    end
                    # TreeNode.new(*create_random_node())
                    # node.add_child_node(create_random_node())
                    #     .add_child_node(create_random_node())
                end 
            end

            # nodes in the last layers
            doing_stack.each do |node|
                node.add_child(TreeNode.new(create_random_node_terminal_value()))
                    .add_child(TreeNode.new(create_random_node_terminal_value()))
            end 

            tree
        end
        def self.generate_randomly_and_safely(scale_threshold, standard_proc)
            100.times.each do |i|
                the_cell = BinaryTreeCell.generate_randomly(scale_threshold)
                fitness = BinaryTreeCell.cal_fitness(the_cell, standard_proc)
                if good_fitness?(fitness)
                    return the_cell
                # else 
                #     the_cell.ptl()
                end
            end
            raise Exception.new("Too many times!")
        end
        def self.generate_code_list(the_node)
            codes = []
            if the_node.is_leaf
                codes << the_node.value.to_s
            else
                codes << the_node.value.to_s
                codes << "("
                codes += generate_code_list(the_node.children[0])
                codes << ","
                codes += generate_code_list(the_node.children[1])
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

            code_list = generate_code_list(binary_tree)
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
        def self.exchange(source_node, target_node)
            if source_node.parent
                source_node.parent.children[source_node.position] = target_node
            end
        end

        def self.mutate(binary_tree)
            binary_tree = binary_tree.clone()
            depth_first_list = binary_tree.to_depth_first_list
            rand_index = rand(depth_first_list.size)
            the_node = depth_first_list[rand_index]

            left_depth = depth_first_list.last.depth - the_node.depth
            new_tree = generate_randomly(left_depth)
            the_node.replace(new_tree)
            binary_tree
        end
        def self.mutate_safely(binary_tree, standard_proc)
            100.times.each do |i|
                the_cell = BinaryTreeCell.mutate(binary_tree)
                fitness = BinaryTreeCell.cal_fitness(the_cell, standard_proc)
                if good_fitness?(fitness)
                    return the_cell
                # else 
                #     the_cell.ptl()
                end
            end
            raise Exception.new("Too many times!")
        end
        def self.crossover(mother_binary_tree, father_binary_tree)
            mother_binary_tree = mother_binary_tree.clone
            father_binary_tree = father_binary_tree.clone
            depth_first_list = mother_binary_tree.to_depth_first_list
            rand_index = rand(depth_first_list.size)
            mother_node = depth_first_list[rand_index]

            depth_first_list = father_binary_tree.to_depth_first_list
            rand_index = rand(depth_first_list.size)
            father_node = depth_first_list[rand_index]

            mother_node.replace(father_node)
            mother_binary_tree
        end
        def self.crossover_safely(mother_binary_tree, father_binary_tree, standard_proc)
            10.times.each do |i|
                the_cell = BinaryTreeCell.crossover(mother_binary_tree, father_binary_tree)
                fitness = BinaryTreeCell.cal_fitness(the_cell, standard_proc)
                if good_fitness?(fitness)
                    return the_cell
                # else 
                #     the_cell.ptl()
                #     fitness.ptl()
                end
            end
            "Too many times!".ptl()
            return mother_binary_tree.clone()
            # raise Exception.new("Too many times!")
        end
        def self.good_fitness?(fitness)
            (not fitness.to_f.nan?) and fitness != Float::INFINITY
        end
        # set default options
        set_options()
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'
    include ArithmeticMethod

    describe GA::BinaryTreeCell do

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
        it 'is_leaf' do
            GA::BinaryTreeCell.is_leaf(GA::TreeNode.new(
                    GA::BinaryTreeCell.get_random_function())).must_equal(false)
            GA::BinaryTreeCell.is_leaf(GA::TreeNode.new(
                    GA::BinaryTreeCell.create_random_node_terminal_value())).must_equal(true)
        end
        it 'generate_randomly' do
            # GA::BinaryTreeCell.generate_randomly()
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            # to_depth_first_hash_list
            binary_tree.must_equal(GA::TreeNode.from_depth_first_hash_list([
                {:value=>:am_mul, :children_positions=>[0, 1]}, 
                    {:value=>:x}, 
                    {:value=>:am_sub, :children_positions=>[0, 1]}, 
                        {:value=>-4.812519913495682}, 
                        {:value=>-2.5211170277396446}]))
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(0)
            binary_tree.must_equal(GA::TreeNode.from_depth_first_hash_list([
                {:value=>2.0814782261810483}]))
        end

        it "generate_randomly_and_safely" do
            standard_proc ||= eval("proc { | x, x2 | x2 + x + 1 }")
            # this seed 6, will get a special fitness cell
            srand(6)
            GA::BinaryTreeCell.generate_randomly_and_safely(
                    2, standard_proc).must_equal(
                    GA::TreeNode.from_depth_first_hash_list([
                        {:value=>:am_add, :children_positions=>[0, 1]}, 
                            {:value=>-3.4438490386787732}, 
                            {:value=>:am_mul, :children_positions=>[0, 1]}, 
                                {:value=>:x}, 
                                {:value=>3.0172090846120883}]))
        end

        it "generate_code_list" do
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            # tree.pt
            GA::BinaryTreeCell.generate_code_list(binary_tree).join.must_equal(
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

            # show some special value
            the_proc = eval("proc { | x, x2 | am_div(1.0,x) }")
            the_proc.call(0, 0).must_equal(Float::INFINITY)
            the_proc = eval("proc { | x, x2 | am_div(x,x2) }")
            # the_proc.call(0.0, 0.0).must_equal(Float::NAN)
        end

        it "cal_fitness" do
            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            standard_proc = eval("proc { | x, x2 | x2 + x + 1 }")
            GA::BinaryTreeCell.cal_fitness(binary_tree, standard_proc).must_equal(1019.0823675978681)
            binary_tree = GA::TreeNode.from_depth_first_hash_list([
                {:value=>:am_div, :children_positions=>[0, 1]}, 
                    {:value=>:am_add, :children_positions=>[0, 1]}, 
                        {:value=>:x2}, 
                        {:value=>:x2}, 
                    {:value=>:x2}])
            (GA::BinaryTreeCell.cal_fitness(binary_tree, standard_proc).nan?).must_equal(true)
        end

        it "mutate" do
            standard_proc = eval("proc { | x, x2 | x2 + x + 1 }")

            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            original_str = binary_tree.to_s()
            binary_tree.must_equal(GA::TreeNode.from_depth_first_hash_list([
                {:value=>:am_mul, :children_positions=>[0, 1]}, 
                    {:value=>:x}, 
                    {:value=>:am_sub, :children_positions=>[0, 1]}, 
                        {:value=>-4.812519913495682}, 
                        {:value=>-2.5211170277396446}]))
            # it will change the node which index == 2
            srand(3)
            GA::BinaryTreeCell.mutate(binary_tree).must_equal(
                GA::TreeNode.from_depth_first_hash_list([
                    {:value=>:am_mul, :children_positions=>[0, 1]}, 
                        {:value=>:x}, 
                        {:value=>:am_add, :children_positions=>[0, 1]}, 
                            {:value=>-2.0909526108705565}, 
                            {:value=>3.929469543476547}]))
            # test side effect
            binary_tree.to_s.must_equal(original_str)

            srand(3)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            srand(1)
            # it will change the node which index == 2
            GA::BinaryTreeCell.mutate(binary_tree).must_equal(
                GA::TreeNode.from_depth_first_hash_list([
                    {:value=>:am_mul, :children_positions=>[0, 1]}, 
                        {:value=>:x}, 
                        {:value=>:am_sub, :children_positions=>[0, 1]}, 
                            {:value=>-4.998856251826551}, 
                            {:value=>-2.5211170277396446}]))

            srand(6)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            mutated_tree = GA::BinaryTreeCell.mutate(binary_tree)
            GA::BinaryTreeCell.cal_fitness(mutated_tree, standard_proc).must_equal(
                    Float::INFINITY)
        end

        it "mutate_safely" do
            standard_proc = eval("proc { | x, x2 | x2 + x + 1 }")
            srand(6)
            binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            mutated_tree = GA::BinaryTreeCell.mutate_safely(binary_tree, standard_proc)
            GA::BinaryTreeCell.cal_fitness(mutated_tree, standard_proc).must_equal(
                    679.7318584994874)
        end
        it "crossover" do
            srand(3)
            mother_binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            mother_binary_tree.must_equal(GA::TreeNode.from_depth_first_hash_list([
                {:value=>:am_mul, :children_positions=>[0, 1]}, 
                    {:value=>:x}, 
                    {:value=>:am_sub, :children_positions=>[0, 1]}, 
                        {:value=>-4.812519913495682}, 
                        {:value=>-2.5211170277396446}]))
            father_binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            father_binary_tree.must_equal(GA::TreeNode.from_depth_first_hash_list([
                {:value=>:am_mul, :children_positions=>[0, 1]}, 
                    {:value=>-0.4316677560528892}, 
                    {:value=>:am_sub, :children_positions=>[0, 1]}, 
                        {:value=>-0.0736407495392255}, 
                        {:value=>:x2}]))

            mother_original_str = mother_binary_tree.to_s()
            father_original_str = father_binary_tree.to_s()
            srand(4)
            GA::BinaryTreeCell.crossover(mother_binary_tree, father_binary_tree).must_equal(
                GA::TreeNode.from_depth_first_hash_list([
                {:value=>:am_mul, :children_positions=>[0, 1]}, 
                    {:value=>:x}, 
                    {:value=>-0.4316677560528892}]))
            # test side effect
            mother_binary_tree.to_s().must_equal(mother_original_str)
            father_binary_tree.to_s().must_equal(father_original_str)
        end
        it "crossover_safely" do
            standard_proc = eval("proc { | x, x2 | x2 + x + 1 }")
            srand(6)
            mother_binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            father_binary_tree = GA::BinaryTreeCell.generate_randomly(2)
            crossovered_tree = GA::BinaryTreeCell.crossover_safely(
                mother_binary_tree, father_binary_tree, standard_proc)
            GA::BinaryTreeCell.cal_fitness(crossovered_tree, standard_proc).must_equal(
                    1265.58047247517)
        end
    end
end