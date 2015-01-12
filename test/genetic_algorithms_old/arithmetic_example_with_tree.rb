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
    class << self
        include ArithmeticMethod
    end
    class CalculateException < Exception
    end


    def self.set_variables(node_terminal_value_is_const_probability:0.75, 
            node_value_is_terminal_probility:0.5)
        @@functions = [:am_add, :am_sub, :am_mul, :am_div]
        @@variables = [:x, :x2]
        @@constant_threshold = 5
        @@mul_value = @@constant_threshold / 0.5
        # @@functions = functions
        # @@variables = variables
        # @@constant_threshold = constant_threshold

        @@node_terminal_value_is_const_probability = node_terminal_value_is_const_probability
        @@node_value_is_terminal_probility = node_value_is_terminal_probility

        @@stop_fitness_threshold = 0.1
        @@stop_iteration_count = 100
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
    def self.create_random_node_value_and_is_leaf()
        cur_prob = rand()
        if cur_prob <= @@node_value_is_terminal_probility
            return {value:create_random_node_terminal_value(), is_leaf:true}
        else
            return {value:get_random_function(), is_leaf:false}
        end
    end
    def self.generate_random_tree(the_depth:2)

        # root
        tree = BinaryTree.new(get_random_function())

        # nodes in middle layers
        1.upto(the_depth-1) do |depth_index|
            tree.search(the_depth:depth_index-1).each do |node|
                # node.pt
                if not node.is_leaf
                    node.add_left(create_random_node_value_and_is_leaf)
                    node.add_right(create_random_node_value_and_is_leaf)
                end
            end 
        end

        # nodes in the last layers
        tree.search(the_depth:the_depth-1).each do |node|
            if not node.is_leaf
                node.add_left(value:create_random_node_terminal_value(),
                    is_leaf:true)
                node.add_right(value:create_random_node_terminal_value(),
                    is_leaf:true)
            end
        end 

        tree
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

    def self.can_stop(fitness_arr, iteration_count)
        # if fit value < 0.1
        # or count of iteration > 100
        return true if iteration_count > stop_iteration_count
        fitness_arr.each do |cur_fitness|
            return true if cur_fitness <= stop_fitness_threshold
        end
        return false
    end


    def self.main()
        set_variables()
        first_generation = count.times.map {GA.generate_random_tree()}

        fitness_arr = first_generation.map{|tree| fitness(tree)}
        iteration_count = 0
        while(not can_stop(fitness_arr, iteration_count))
            next_generation = cal_next_generation(first_generation)
            fitness_arr = next_generation.map{|tree| fitness(tree)}
            iteration_count += 1
        end

        next_generation[fitness_arr.index(fitness_arr.min)]
    end

    module Selection
        def self.cal_acculate_ratios(fitness_arr)
            maximum = fitness_arr.max
            ratios = fitness_arr.map{|x| Float(maximum) / x}
            sum = 0
            ratios.map { |x| sum += x }
        end
        def self.get_index_in_acculate_ratios(acculate_ratios, the_value)
            return -1 if the_value > acculate_ratios.last

            (acculate_ratios.size - 1).downto(1) do |i|
                if acculate_ratios[i-1] < the_value and 
                        the_value <= acculate_ratios[i]
                    return i
                end
            end
            return 0
        end
        def self.choose_one_index_randomly_by_fitness(fitness_arr)
            # according to roulette wheel rule to choose the index
            acculate_ratios = cal_acculate_ratios(fitness_arr)
            rand_value = rand() * acculate_ratios.last
            get_index_in_acculate_ratios(acculate_ratios, rand_value)
        end

        def self.choose_indexes_randomly_by_fitness(fitness_arr, count)
            if count >= fitness_arr.size
                return fitness_arr.size.times.map {|x| x}
            end
            acculate_ratios = cal_acculate_ratios(fitness_arr)
            choosed_indexes = []
            count.times do |i|
                flag = true
                while(flag)
                    rand_value = rand() * acculate_ratios.last
                    picked_index = get_index_in_acculate_ratios(acculate_ratios, rand_value)
                    if not choosed_indexes.member?(picked_index)
                        choosed_indexes << picked_index
                        flag = false
                    end
                end
            end
            choosed_indexes
        end

        def self.cal_direct_copy(pre_generation, pre_fitness_arr, direct_copy_count)
            choose_indexes_randomly_by_fitness(pre_fitness_arr, direct_copy_count).map do |index|
                pre_generation[index]
            end
        end

        def self.choose_pare_randomly_by_fitness(pre_generation, pre_fitness_arr)
            cal_direct_copy(pre_generation, pre_fitness_arr, 2)
        end

        def self.mutate(the_item)

        end

        def self.cal_mutation(pre_generation, pre_fitness_arr, mutation_count)
            mutation_arr = cal_direct_copy(pre_generation, pre_fitness_arr, mutation_count)
            mutation_arr.map do |item|
                mutate(item)
            end
            # mutation_count.times.map do |index|
            #     pair = choose_pare_randomly_by_fitness(pre_generation, pre_fitness_arr)
            #     crossover(pair.first, pair.last)
            # end
        end

        def self.crossover(father, mother)
            
        end

        def self.cal_crossover(pre_generation, pre_fitness_arr, crossover_count)
            choose_indexes_randomly_by_fitness(pre_fitness_arr, direct_copy_count).map do |index|
                pre_generation[index]
            end
        end

        def self.cal_next_generation(pre_generation, pre_fitness_arr)
            next_generation = []
            total_count = pre_generation.size

            direct_copy_count = (total_count * @@direct_copy_rate).round
            next_generation += cal_direct_copy(
                pre_generation, pre_fitness_arr, direct_copy_count)

            mutation_count = (total_count * @@mutation_rate).round
            next_generation += cal_mutation(
                pre_generation, pre_fitness_arr, mutation_count)

            crossover_count = (total_count * @@crossover_rate).round
            next_generation += cal_crossover(
                pre_generation, pre_fitness_arr, crossover_count)

            next_generation
        end
    end
end


if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'

    include ArithmeticMethod

    describe GA do
        before do
            GA.set_variables(node_terminal_value_is_const_probability:0.75, node_value_is_terminal_probility:0.5)
        end
        it "get_random_function" do
            srand(1)
            GA.get_random_function().must_equal(:am_sub)
        end
        it "get_random_constant" do
            srand(1)
            GA.get_random_constant().must_equal(-0.82977995297426)
        end
        it "create_random_node_terminal_value" do
            srand(1)
            GA.create_random_node_terminal_value().must_equal(2.2032449344215808)

            srand(4)
            GA.create_random_node_terminal_value().must_equal(:x2)
        end

        it "generate_random_tree" do
            srand(3)
            tree = GA.generate_random_tree()
            # tree.ppt
            # GA.generate_random_tree().pt
            # GA.generate_random_tree().pt
            # GA.generate_random_tree().pt

        end

        it "generate_code_list" do
            srand(3)
            tree = GA.generate_random_tree()
            # tree.pt
            GA.generate_code_list(tree.root).join.must_equal(
                "am_mul(x,am_sub(-4.812519913495682,-2.5211170277396446))")
        end

        it "package_proc_code" do
            proc_content = "am_mul(x,am_sub(-4.812519913495682,-2.5211170277396446))"
            proc_code = "proc { | x, x2 | #{proc_content} }"
            GA.package_proc_code(proc_content).must_equal(proc_code)
            eval(proc_code).class.must_equal(Proc)
        end

        it "call_proc" do
            # notice, when you eval the proc, in this scope, it must have the functions
            # which will be used in the proc, otherwise, when you ran it, 
            # it would report cannot find the method.
            the_proc = eval("proc { | x, x2 | am_mul(x,am_sub(-4.0,-2.0)) }")
            GA.call_proc(the_proc, [2,4]).must_equal(-4.0)

            lambda { GA.call_proc(the_proc, [2,4,1]) }.must_raise GA::CalculateException
        end

        it "generate_proc" do
            srand(3)
            tree = GA.generate_random_tree()
            GA.generate_proc(tree).call([2,4]).must_equal(-4.582805771512074)
        end

        it "generate_variable_values" do
            variable_range = -0.2..0.2
            step_value = 0.1
            variable_procs = [lambda {|x| x}, lambda {|x| x**2}]
            GA.generate_variable_values(
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
            GA.cal_difference(the_proc, standard_proc, variable_values).must_equal(5.1)
        end

        it "cal_acculate_ratios" do
            fitness_arr = [10, 15, 15, 30]
            GA::Selection.cal_acculate_ratios(
                fitness_arr).must_equal([3.0, 5.0, 7.0, 8.0])
        end

        it "get_index_in_acculate_ratios" do
            acculate_ratios = [3.0, 5.0, 7.0, 8.0]
            GA::Selection.get_index_in_acculate_ratios(
                acculate_ratios, 1.0).must_equal(0)
            GA::Selection.get_index_in_acculate_ratios(
                acculate_ratios, 6.0).must_equal(2)
            GA::Selection.get_index_in_acculate_ratios(
                acculate_ratios, 9.0).must_equal(-1)
        end

        it "choose_one_index_randomly_by_fitness" do
            fitness_arr = [10, 15, 15, 30]
            srand(1)
            GA::Selection.choose_one_index_randomly_by_fitness(
                fitness_arr).must_equal(1)
            GA::Selection.choose_one_index_randomly_by_fitness(
                fitness_arr).must_equal(2)
            GA::Selection.choose_one_index_randomly_by_fitness(
                fitness_arr).must_equal(0)
        end

        it "choose_indexes_randomly_by_fitness" do
            fitness_arr = [10, 15, 15, 30]
            srand(1)
            GA::Selection.choose_indexes_randomly_by_fitness(
                fitness_arr, 2).must_equal([1,2])
        end

        it "cal_direct_copy" do
            fake_arr = [1,2,3,4]
            fitness_arr = [10, 15, 15, 30]
            srand(1)
            GA::Selection.cal_direct_copy(
                fake_arr, fitness_arr, 2).must_equal([2,3])
        end

    end
end