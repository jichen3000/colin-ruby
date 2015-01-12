direc = File.dirname(__FILE__)
require "#{direc}/binary_tree_cell"


module GA
    class Exception < Exception
    end

    class Cell
        attr_reader :nucleus
        def initialize(nucleus)
            @nucleus = nucleus
        end
        def self.set_options(options)
            if not options[:implete_module]
                raise Exception.new("Options must have implete_module!")
            end
            @@implete_module = Object.const_get(options[:implete_module])

            @@implete_module.set_options(options)
            # @@implete_module.methods.pt()

            @@scale_threshold = options['scale_threshold']
            @@scale_threshold ||= 2
        end
        def self.generate_randomly()
            the_scale = rand(@@scale_threshold) + 1
            the_nucleus = @@implete_module.generate_randomly(the_scale)
            Cell.new(the_nucleus)
        end
        def inspect()
            @nucleus.inspect.sub("BinaryTree.from_depth_first_list","Cell.from_hash_list")
        end
        def self.from_hash_list(hash_list)
            the_nucleus = @@implete_module.from_hash_list(hash_list)
            Cell.new(the_nucleus)
        end
        def mutate()
            @@implete_module.mutate(@nucleus)
        end
    end
    module Selection
        def self.set_options(options)
            if not options[:implete_module]
                raise Exception.new("Options must have implete_module!")
            end
            @@implete_module = Object.const_get(options[:implete_module])

            @@standard_proc = options['standard_proc']
            @@standard_proc ||= eval("proc { | x, x2 | x2 + x + 1 }")

            @@stop_iteration_count = options['stop_iteration_count']
            @@stop_iteration_count ||= 100

            @@stop_fitness_threshold = options['stop_fitness_threshold']
            @@stop_fitness_threshold ||= 0.1
        end
        def self.select_first_generation(pool_size)
            pool_size.times.map do |index|
                Cell.generate_randomly()
            end
        end
        def self.cal_fitness(the_cell)
            @@implete_module.cal_fitness(the_cell.nucleus, @@standard_proc)
        end
        def self.can_stop(fitness_arr, iteration_count)
            return true if iteration_count > @@stop_iteration_count
            fitness_arr.each do |cur_fitness|
                return true if cur_fitness <= @@stop_fitness_threshold
            end
            return false
        end
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

        def self.cal_mutation(pre_generation, pre_fitness_arr, mutation_count)
            mutation_arr = cal_direct_copy(pre_generation, pre_fitness_arr, mutation_count)
            mutation_arr.map do |the_cell|
                the_cell.mutate
            end
        end

        def self.choose_pare_randomly_by_fitness(pre_generation, pre_fitness_arr)
            cal_direct_copy(pre_generation, pre_fitness_arr, 2)
        end

        def self.crossover(father, mother)
            
        end

        def self.cal_crossover(pre_generation, pre_fitness_arr, crossover_count)
            choose_indexes_randomly_by_fitness(pre_fitness_arr, direct_copy_count).map do |index|
                pre_generation[index]
            end
        end

        def self.select_next_generation(pre_generation, pre_fitness_arr)
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
        def self.cal_fitness_arr(the_generation)
            the_generation.map{|the_cell| cal_fitness(the_cell)}
        end
    end
    def self.main(pool_size, generation_threshold, options)
        Cell.set_options(options)
        Selcetion.set_options(options)
        # Cell.set_probabilities()
        cur_generation = Selcetion.select_first_generation(pool_size)
        fitness_arr = Selcetion.cal_fitness_arr(cur_generation)
        index = 0
        while(not Selcetion.can_stop(fitness_arr, index))
            cur_generation = Selcetion.select_next_generation(cur_generation, fitness_arr)
            fitness_arr = Selcetion.cal_fitness_arr(cur_generation)
            index += 1
        end
        cur_generation
    end

end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe GA::Cell do
        before do
            GA::Cell.set_options({:implete_module => 'GA::BinaryTreeCell'})
        end
        it 'set_options' do
            # GA::Cell.set_options({:implete_module => 'GA::BinaryTreeCell'})
            GA::Cell.class_variable_get(:@@scale_threshold).must_equal(2)
            GA::Cell.class_variable_get(:@@implete_module).must_equal(GA::BinaryTreeCell)
        end
        it 'from_hash_list' do
            GA::Cell.from_hash_list([
                {:value=>:am_div, :is_leaf=>false}, 
                    {:value=>:am_div, :is_leaf=>false}, 
                        {:value=>-3.137397886223291, :is_leaf=>true}, 
                        {:value=>-1.0323252576933006, :is_leaf=>true}, 
                    {:value=>:x, :is_leaf=>true}]).pptl
        end
        it 'generate_randomly' do
            # GA::BinaryTreeCell.generate_randomly()
            srand(1)
            the_cell = GA::Cell.generate_randomly()
            the_cell.pptl
            the_cell.nucleus.must_equal(
                GA::BinaryTree.from_depth_first_list([
                    {:value=>:am_div, :is_leaf=>false}, 
                        {:value=>:am_div, :is_leaf=>false}, 
                            {:value=>-3.137397886223291, :is_leaf=>true}, 
                            {:value=>-1.0323252576933006, :is_leaf=>true}, 
                        {:value=>:x, :is_leaf=>true}]))
        end
    end
    describe GA::Selection do
        before do
            GA::Cell.set_options({:implete_module => 'GA::BinaryTreeCell'})
            GA::Selection.set_options({:implete_module => 'GA::BinaryTreeCell'})
        end
        it 'select_first_generation' do
            srand(1)
            first_generation = GA::Selection.select_first_generation(4)
            # first_generation.pptl
            # first_generation.must_equal([
            #     GA::BinaryTree.from_depth_first_list([
            #         {:value=>:am_div, :is_leaf=>false}, 
            #             {:value=>:am_div, :is_leaf=>false}, 
            #                 {:value=>-3.137397886223291, :is_leaf=>true}, 
            #                 {:value=>-1.0323252576933006, :is_leaf=>true}, 
            #             {:value=>:x, :is_leaf=>true}]),
            #     GA::BinaryTree.from_depth_first_list([{:value=>:am_add, :is_leaf=>false}, {:value=>1.852195003967595, :is_leaf=>true}, {:value=>3.781174363909454, :is_leaf=>true}]),
            #     GA::BinaryTree.from_depth_first_list([{:value=>:am_mul, :is_leaf=>false}, {:value=>:am_div, :is_leaf=>false}, {:value=>:x2, :is_leaf=>true}, {:value=>:x2, :is_leaf=>true}, {:value=>4.391277894236257, :is_leaf=>true}]),
            #     GA::BinaryTree.from_depth_first_list([{:value=>:am_mul, :is_leaf=>false}, {:value=>:am_add, :is_leaf=>false}, {:value=>:x2, :is_leaf=>true}, {:value=>3.7814250342941316, :is_leaf=>true}, {:value=>:am_add, :is_leaf=>false}, {:value=>-0.7889237499494783, :is_leaf=>true}, {:value=>:x2, :is_leaf=>true}])])
            # first_generation.size.must_equal(4)
            # first_generation.each do |the_cell|
            #     the_cell.nucleus.depth.must_be(:<=, 2)
            # end
        end
        it 'cal_fitness' do
            srand(2)
            the_cell = GA::Cell.generate_randomly()
            GA::Selection.cal_fitness(the_cell).must_equal(1022.4884694537808)
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

        it "cal_mutation" do
            srand(1)
            first_generation = GA::Selection.select_first_generation(4)
            # first_generation.ptl
            fitness_arr = GA::Selection.cal_fitness_arr(first_generation)
            # fitness_arr.ptl
            # cur_generation = GA::Selection.cal_mutation(first_generation, fitness_arr, 2)
            # cur_generation.pt
        end
    end
end