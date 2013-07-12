module MethodModule
    def gen_log_proc(str)
        p str
    end
end

gen_log_proc_method = MethodModule.instance_method("gen_log_proc")
p gen_log_proc_method.kind_of? UnboundMethod
gen_log_proc_method.bind(Object).call("sdf")

b = proc {puts "b"}
p b.kind_of? Proc
