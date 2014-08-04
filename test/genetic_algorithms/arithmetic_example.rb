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
    def self.generate_random_tree(depth:2)

        # root
        tree = BinaryTree.new(get_random_function())

        # nodes in middle layers
        1.upto(depth-1) do |depth_index|
            tree.search(depth:depth_index-1).each do |node|
                # node.pt
                if not node.is_leaf
                    node.add_left(create_random_node_value_and_is_leaf)
                    node.add_right(create_random_node_value_and_is_leaf)
                end
            end 
        end

        # nodes in the last layers
        tree.search(depth:depth-1).each do |node|
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
    def self.call_proc(proc_code, variable_values)
        eval(proc_code).call(*variable_values)        
    end

    def self.eval_tree(binary_tree, variable_values)
        if variable_values.size != @@variables.size
            raise CalculateException.new("Size of the variables are not match! "+
                "There should be #{@@variables.size}, but #{variable_values.size} now!")
        end

        code_list = generate_code_list(binary_tree.root)
        proc_code = package_proc_code(code_list.join())
        call_proc(proc_code, variable_values)
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'

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
            proc_code = "proc { | x, x2 | am_mul(x,am_sub(-4.0,-2.0)) }"
            GA.call_proc(proc_code, [2,4]).must_equal(-4.0)

        end

        it "eval_tree" do
            srand(3)
            tree = GA.generate_random_tree()
            GA.eval_tree(tree, [2,4]).must_equal(-4.582805771512074)

            lambda { GA.eval_tree(tree, [2,4,1]) }.must_raise GA::CalculateException
        end
    end
end