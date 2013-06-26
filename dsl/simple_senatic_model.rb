class Task
    attr_reader :name
    attr_accessor :prerequisites

    def initialize(name, *prereqs)
        @name = name
        @prerequisites = prereqs
    end

    def to_s
        result = "task( name: "+@name
        if @prerequisites and @prerequisites.size() > 0
            result += ", prereqs: "+
                @prerequisites.map{|x| x.name}.join(", ")
        end
        result += " )"
    end
end

class TaskBuilder
    def load(a_stream)
        instance_eval(a_stream)
        self
    end
    def initialize
        @tasks = {}
    end
    def task(arg_map)
        raise "syntax error" if arg_map.keys.size !=1
        key = arg_map.keys[0]
        new_task = obtain_task(key)
        prereqs = arg_map[key].map{|item| obtain_task(item)}
        new_task.prerequisites = prereqs
        self
    end
    private
    def obtain_task(a_symbol)
        @tasks[a_symbol] = Task.new(a_symbol.to_s)
    end
    def to_s
        "task_builder's tasks(\n"+
            @tasks.map{|key,value| value.to_s}.join("\n")+" )"
    end
end

def test_me
    task_builder = TaskBuilder.new()
    task_builder.load("task :go_to_work => [:drink_coffee, :dress]").load(
        "task :drink_coffee => [:make_coffee, :wash]").load(
        "task :dress => [:wash]")
    # puts task_builder.task(:go_to_work => [:drink_coffee, :dress]).task(
    #     :drink_coffee => [:make_coffee, :wash]).task(
    #     :dress => [:wash])
    puts task_builder
end
if __FILE__ == $0
    test_me
end

