

def new_one(factor)
    Proc.new {|x| x*factor}
end

def proc_one(factor)
    proc {|x| x*factor}
end

def eval_one(factor)
    eval('Proc.new {|x| x*factor}')
end

def eval_block_part(factor)
    Proc.new eval('{|x| x*factor}')
end


if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'

    describe Proc do
        it "new_one" do
            mul_3_proc = new_one(3)
            mul_3_proc.call(5).must_equal(15)
        end
        it "proc_one" do
            mul_3_proc = proc_one(3)
            mul_3_proc.call(5).must_equal(15)
        end

        it "eval_one" do
            mul_3_proc = eval_one(3)
            mul_3_proc.call(5).must_equal(15)
        end

        it "eval_block_part" do
            mul_3_proc = eval_block_part(3)
            mul_3_proc.call(5).must_equal(15)
        end
    end
end