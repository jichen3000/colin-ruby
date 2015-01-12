direc = File.dirname(__FILE__)
require "#{direc}/cell"

DEBUG_OPTIONS = {}

module GA
    module Selection
        module PrivateMethods
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
            def self.choose_indexes_randomly_by_fitness_no_repeat(fitness_arr, count)
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
            def self.choose_indexes_randomly_by_fitness(fitness_arr, count)
                if count >= fitness_arr.size
                    return fitness_arr.size.times.map {|x| x}
                end
                acculate_ratios = cal_acculate_ratios(fitness_arr)
                count.times.map do |index|
                    rand_value = rand() * acculate_ratios.last
                    get_index_in_acculate_ratios(acculate_ratios, rand_value)
                end
            end
            def self.direct_copy(pre_generation, pre_fitness_arr, direct_copy_count)
                choose_indexes_randomly_by_fitness(pre_fitness_arr, direct_copy_count).map do |index|
                    pre_generation[index].clone()
                end
            end
            def self.mutate(pre_generation, pre_fitness_arr, mutation_count, standard_proc)
                choose_indexes_randomly_by_fitness(pre_fitness_arr, mutation_count).map do |index|
                    GA::BinaryTreeCell.mutate_safely(pre_generation[index], standard_proc)
                end
                # handle_arr = direct_copy(pre_generation, pre_fitness_arr, mutation_count)
                # handle_arr.map do |the_cell|
                #     GA::BinaryTreeCell.mutate_safely(the_cell, standard_proc)
                # end
            end
            def self.crossover(pre_generation, pre_fitness_arr, crossover_count, standard_proc)
                index_arr = choose_indexes_randomly_by_fitness(pre_fitness_arr, crossover_count+1)
                (index_arr.size-1).times.map do |i|
                    GA::BinaryTreeCell.crossover_safely(pre_generation[index_arr[i]], pre_generation[index_arr[i+1]], standard_proc)
                end
                # handle_arr = direct_copy(pre_generation, pre_fitness_arr, crossover_count+1)
                # (handle_arr.size-1).times.map do |index|
                #     result = GA::BinaryTreeCell.crossover_safely(handle_arr[index], handle_arr[index+1], standard_proc)
                #     result
                # end
            end
        end
        def self.set_options(options={})
            @@scale_threshold = 2

            @@standard_proc = options['standard_proc']
            @@standard_proc ||= eval("proc { | x, x2 | x2 + x + 1 }")

            @@stop_iteration_count = options['stop_iteration_count']
            @@stop_iteration_count ||= 100
            puts(@@stop_iteration_count)

            @@stop_fitness_threshold = options['stop_fitness_threshold']
            @@stop_fitness_threshold ||= 0.1

            @@direct_copy_rate = 0.5
            @@mutation_rate = 0.25
            @@crossover_rate = 0.25

        end
        def self.get_first(pool_size)
            pool_size.times.map {|i| BinaryTreeCell.generate_randomly_and_safely(
                    @@scale_threshold, @@standard_proc)}
        end
        def self.cal_fitness_arr(the_generation)
            the_generation.map {|the_cell| BinaryTreeCell.cal_fitness(the_cell, @@standard_proc)}
        end
        def self.can_stop(fitness_arr, iteration_index)
            return true if iteration_index > @@stop_iteration_count
            fitness_arr.each do |cur_fitness|
                return true if cur_fitness <= @@stop_fitness_threshold
            end
            return false
        end
        def self.verify_bad_fitness(cell_arr)
            cell_arr.each do |the_cell|
                fitness = BinaryTreeCell.cal_fitness(the_cell, @@standard_proc)
                if (not BinaryTreeCell.good_fitness?(fitness))
                    fitness.pt()
                    the_cell.ptl()
                    exit
                end
            end

        end
        def self.get_next(pre_generation, pre_fitness_arr)
            # "pre_generation".pt()
            # verify_bad_fitness(pre_generation)
            total_count = pre_generation.size

            direct_copy_count = (total_count * @@direct_copy_rate).round
            direct_copy_arr = PrivateMethods.direct_copy(
                pre_generation, pre_fitness_arr, direct_copy_count)
            # "direct_copy_arr".pt()
            # verify_bad_fitness(direct_copy_arr)

            mutation_count = (total_count * @@mutation_rate).round
            mutation_arr = PrivateMethods.mutate(
                pre_generation, pre_fitness_arr, mutation_count, @@standard_proc)
            # "mutation_arr".pt()
            # verify_bad_fitness(mutation_arr)

            crossover_count = (total_count * @@crossover_rate).round
            crossover_arr = PrivateMethods.crossover(
                pre_generation, pre_fitness_arr, crossover_count, @@standard_proc)
            # "crossover_arr".pt()
            # verify_bad_fitness(crossover_arr)

            direct_copy_arr + mutation_arr + crossover_arr
        end
        def self.evolve(pool_size)
            cur_generation = get_first(pool_size)
            fitness_arr = cal_fitness_arr(cur_generation)
            index = 0
            while(not can_stop(fitness_arr, index))
                if DEBUG_OPTIONS['debug?']
                    index.pt()
                    fitness_arr.min.pt()
                end
                cur_generation = get_next(cur_generation, fitness_arr)
                fitness_arr = cal_fitness_arr(cur_generation)
                index += 1
            end
            [cur_generation[fitness_arr.index(fitness_arr.min)], fitness_arr.min]
        end
        # set default options
        set_options()
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    # srand(1)
    # GA::Selection.evolve(8).pt()

    describe "GA::Selection" do
        it "cal_acculate_ratios" do
            fitness_arr = [10, 15, 15, 30]
            GA::Selection::PrivateMethods.cal_acculate_ratios(
                fitness_arr).must_equal([3.0, 5.0, 7.0, 8.0])
        end

        it "get_index_in_acculate_ratios" do
            acculate_ratios = [3.0, 5.0, 7.0, 8.0]
            GA::Selection::PrivateMethods.get_index_in_acculate_ratios(
                acculate_ratios, 1.0).must_equal(0)
            GA::Selection::PrivateMethods.get_index_in_acculate_ratios(
                acculate_ratios, 6.0).must_equal(2)
            GA::Selection::PrivateMethods.get_index_in_acculate_ratios(
                acculate_ratios, 9.0).must_equal(-1)
        end
        it "choose_indexes_randomly_by_fitness_no_repeat" do
            fitness_arr = [10, 15, 15, 30]
            srand(1)
            GA::Selection::PrivateMethods.choose_indexes_randomly_by_fitness_no_repeat(
                fitness_arr, 2).must_equal([1,2])

            # show the percent of every index
            fitness_arr = [100, 1000, 900, 700]
            iter_count = 1000
            results = iter_count.times.map do |index|
                GA::Selection::PrivateMethods.choose_indexes_randomly_by_fitness_no_repeat(
                    fitness_arr, 2)
            end.flatten!
            fitness_arr.size.times.map do |index|
                percent = results.count(index).to_f / results.size
                [index, percent]
            end.must_equal([[0, 0.4775], [1, 0.1515], [2, 0.1645], [3, 0.2065]])
        end
        it "choose_indexes_randomly_by_fitness" do
            fitness_arr = [10, 15, 15, 30]
            srand(1)
            GA::Selection::PrivateMethods.choose_indexes_randomly_by_fitness(
                fitness_arr, 2).must_equal([1,2])

            # show the percent of every index
            fitness_arr = [100, 1000, 900, 700]
            iter_count = 1000
            results = iter_count.times.map do |index|
                GA::Selection::PrivateMethods.choose_indexes_randomly_by_fitness(
                    fitness_arr, 2)
            end.flatten!
            fitness_arr.size.times.map do |index|
                percent = results.count(index).to_f / results.size
                [index, percent]
            end.must_equal([[0, 0.7215], [1, 0.0785], [2, 0.0825], [3, 0.1175]])
        end
        it "direct_copy" do
            fake_arr = ["1","2","3","4"]
            fitness_arr = [10, 15, 15, 30]
            srand(1)
            GA::Selection::PrivateMethods.direct_copy(
                fake_arr, fitness_arr, 2).must_equal(["2","3"])
            GA::Selection::PrivateMethods.direct_copy(
                fake_arr, fitness_arr, 5).must_equal(["1", "2", "3", "4"])
        end
        it "mutate" do
            standard_proc = eval("proc { | x, x2 | x2 + x + 1 }")
            srand(1)
            first_generation = GA::Selection.get_first(4)
            fitness_arr = GA::Selection.cal_fitness_arr(first_generation)
            cur_generation = GA::Selection::PrivateMethods.mutate(
                    first_generation, fitness_arr, 2, standard_proc)
            cur_generation.size.must_equal(2)
        end
        it "crossover" do
            standard_proc = eval("proc { | x, x2 | x2 + x + 1 }")
            srand(1)
            first_generation = GA::Selection.get_first(4)
            first_original_str = first_generation.to_s()
            fitness_arr = GA::Selection.cal_fitness_arr(first_generation)
            cur_generation = GA::Selection::PrivateMethods.crossover(
                    first_generation, fitness_arr, 2, standard_proc)
            first_other_str = first_generation.to_s()
            first_original_str.must_equal(first_other_str)
            cur_generation.size.must_equal(2)
            # cur_generation.to_s.must_equal(first_original_str)
        end
    end
    describe "GA::Selection" do
        it 'get_first' do
            srand(1)
            first_generation = GA::Selection.get_first(4)
            first_generation.must_equal([
                GA::TreeNode.from_depth_first_hash_list([
                    {:value=>:am_sub, :children_positions=>[0, 1]}, 
                        {:value=>:am_add, :children_positions=>[0, 1]}, 
                            {:value=>-3.137397886223291}, 
                            {:value=>-1.0323252576933006}, 
                        {:value=>-3.5324410918288693}]),
                GA::TreeNode.from_depth_first_hash_list([
                    {:value=>:am_div, :children_positions=>[0, 1]}, 
                        {:value=>0.9306551829805687}, 
                    {:value=>:am_sub, :children_positions=>[0, 1]}, 
                        {:value=>1.9187711395047335}, 
                        {:value=>1.8650092768158366}]),
                GA::TreeNode.from_depth_first_hash_list([
                    {:value=>:am_add, :children_positions=>[0, 1]}, 
                        {:value=>1.240299864773533}, 
                        {:value=>:am_sub, :children_positions=>[0, 1]}, 
                            {:value=>2.892793284514885}, 
                            {:value=>-0.5210647382409483}]), 
                GA::TreeNode.from_depth_first_hash_list([
                    {:value=>:am_sub, :children_positions=>[0, 1]}, 
                        {:value=>:x2}, 
                        {:value=>1.7883553293989096}])
            ])
            first_generation.each do |the_cell|
                the_cell.depth.must_be(:<=, 2)
            end
        end
        it "cal_fitness_arr" do
            srand(1)
            first_generation = GA::Selection.get_first(4)
            # since Float::NAN cannot be compared, so I have to use string.
            GA::Selection.cal_fitness_arr(first_generation).must_equal(
                    [1023.8654872608597, 1008.3523670212973, 695.1543685868248, 332.75954311694])
        end
        it "can_stop" do
            GA::Selection.can_stop([0.2, 0.3], 100).must_equal(false)
            GA::Selection.can_stop([0.1, 0.3], 99).must_equal(true)
            GA::Selection.can_stop([0.2, 0.3], 101).must_equal(true)
        end
        it "get_next" do
            srand(1)
            first_generation = GA::Selection.get_first(4)
            first_original_str = first_generation.to_s()
            fitness_arr = GA::Selection.cal_fitness_arr(first_generation)
            # GA::Selection.get_next(first_generation, fitness_arr)
            first_other_str = first_generation.to_s()
            first_original_str.must_equal(first_other_str)
        end
        it "evolve" do
            srand(1)
            DEBUG_OPTIONS['debug?'] = false
            GA::Selection.evolve(30).must_equal([GA::TreeNode.from_depth_first_hash_list([{:value=>:am_add, :children_positions=>[0, 1]}, {:value=>:am_add, :children_positions=>[0, 1]}, {:value=>3.7269272298487213}, {:value=>:x}, {:value=>:am_add, :children_positions=>[0, 1]}, {:value=>:x2}, {:value=>-2.6781769035552525}]), 4.9237829556403305])
            # GA::Selection.set_options({'stop_iteration_count'=>300}) # 0.08947803867021453
            # GA::Selection.set_options({'stop_iteration_count'=>100, 'stop_fitness_threshold'=>0.001})
            # GA::Selection.evolve(10000).pt()
            # using GA::Selection.set_options({'stop_iteration_count'=>100, 'stop_fitness_threshold'=>0.001})
            # GA::Selection.evolve(10000) : [GA::TreeNode.from_depth_first_hash_list([{:value=>:am_add, :children_positions=>[0, 1]}, {:value=>:am_div, :children_positions=>[0, 1]}, {:value=>-4.9048168299675075}, {:value=>-4.9048168299675075}, {:value=>:am_add, :children_positions=>[0, 1]}, {:value=>:x}, {:value=>:x2}]), 0.0]
        end
    end
end