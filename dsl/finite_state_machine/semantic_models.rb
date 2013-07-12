# obj will either event or state

class Event
    attr_reader :name, :from_state, :to_state
    def initialize(name, from_state, to_state)
        @name = name
        @from_state = from_state
        @to_state = to_state
    end
    def self.legal_timing?(timing)
        [:before, :on, :after].include?(timing)
    end
end

class State
    attr_reader :name
    def initialize(name)
        @name = name
    end
    def self.legal_timing?(timing)
        [:leave, :enter, :on].include?(timing)
    end
end

class Callback
    attr_reader :timing, :proc, :obj_class, :obj_name
    def initialize(timing, proc, obj_class, obj_name)
        @timing = timing
        @proc = proc
        @obj_class = obj_class
        @obj_name = obj_name
        check_timing()
    end
    def check_timing
        if not @obj_class.legal_timing?(@timing)
            raise "This is not a legal timing(#{@timing}) for the #{@obj_class}!"
        end
    end
    def name()
        (@timing.to_s) +"_"+ (@obj_name.to_s) + "_" + (:obj_class.to_s)
    end
    def call(*arg)
        if @proc.kind_of? UnboundMethod
            return @proc.bind(Object).call(*arg)
        elsif @proc.kind_of? Proc
            return @proc.call(*arg)
        else
            raise "Now, it just support to call the Proc and Method, "+
                "the others like #{@proc} are not support!"
        end
    end
end

class StateMachine
    CANCEL = :CANCEL
    START_SYM = :NIL
    # self_state in [:startup, :onstate, :acting]
    attr_reader :self_state, :current_state
    def initialize()
        @events = {}
        @states = {}
        # for keep the callback order
        @callback_arr = []
        @current_state = nil
        @self_state = :startup
    end
    def startup()
        @current_state = @states[START_SYM]
        if not @current_state
            raise "The start state(#{START_SYM}) cannot be found."
        end
        @self_state = :onstate
        self
    end
    def add_event(event_name, from_name, to_name)
        from_state, to_state = add_from_and_to_states(from_name.to_sym, to_name.to_sym)
        @events[gen_event_key(event_name,from_name)] = Event.new(event_name.to_sym, from_state, to_state)
    end
    def add_callback(timing, state_or_event_name, proc)
        state_or_event_name_sym = state_or_event_name.to_sym
        callback = Callback.new(timing.to_sym, proc,
            *get_state_or_event(state_or_event_name.to_sym))
        @callback_arr << callback
        callback
    end
    def availabe_events
        @events.values.select {|event| event.from_state == @current_state} 
    end
    def act(event_name)
        @self_state = :acting
        if availabe_event = @events[gen_event_key(event_name,@current_state.name.to_s)]
            @self_state = :onstate
            invoke_callbacks(availabe_event)
        else
            raise "This #{event_name} Event is not availabe "+
                "on the current #{@current_state.name.to_s} State!\n" +
                "The availabe events will be "+
                availabe_events.map{|event| event.name.to_s}.join(",")+"."
        end
    end
    private
    def gen_event_key(event_name,from_name)
        event_name+"::"+from_name
    end
    def invoke_callbacks(event)
        # get_act_callbacks
        # sort_callbacks_by_timing
        # before > leave(from state) > on event > enter(to state) > after > on(to state)
        #before event
        if select_callbacks(:before, Event, [:any, event.name]).any? {|callback| 
            callback.call(event, callback)==StateMachine::CANCEL}
            return StateMachine::CANCEL
        end
        select_callbacks(:leave, State, [:any, event.name]).map do |callback|
            callback.call(event.from_state, callback)
        end
        select_callbacks(:on, Event, [:any, event.name]).map do |callback|
            callback.call(event, callback)
        end
        select_callbacks(:enter, State, [:any, event.name]).map do |callback|
            callback.call(event.to_state, callback)
        end
        @current_state = event.to_state
        select_callbacks(:after, Event, [:any, event.name]).map do |callback|
            callback.call(event, callback)
        end
        select_callbacks(:on, State, [:any, event.name]).map do |callback|
            callback.call(event.to_state, callback)
        end
    end
    def select_callbacks(timing, obj_class, obj_names)
        @callback_arr.select do |callback|
            callback.obj_class == obj_class and callback.timing == timing and
                obj_names.include?(callback.obj_name)
        end
    end
    def get_state_or_event(state_or_event_name)
        if state_or_event_name == :anystate
            return [State, :any]
        elsif state_or_event_name == :anyevent
            return [Event, :any]
        elsif @states[state_or_event_name]
            return [State, state_or_event_name]
        elsif @events.values.any?{|event| event.name == state_or_event_name}
            return [Event, state_or_event_name]
        else
            raise "This #{state_or_event_name.to_s} is neither a State name or Event name!"
        end

    end
    def add_from_and_to_states(from_name_sym, to_name_sym)
        @states[from_name_sym] ||= State.new(from_name_sym)
        @states[to_name_sym] ||= State.new(to_name_sym)
        [@states[from_name_sym], @states[to_name_sym]]
    end
end

def log(str)
    p "log: "+str.to_s
end
class StateMachineMethod
    def self.gen_log_proc()
        proc do |event_or_state, callback| 
            p "log: A callback is invoked #{callback.timing.to_s} the "+
                "#{event_or_state.name.to_s} #{callback.obj_class.to_s} "+
                "(actually #{callback.obj_name.to_s} #{callback.obj_class.to_s})."
        end
    end
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'pp'
    describe "StateMachine" do
        it "can run" do
            # StateMachineMethod.gen_log_proc("star...").call
            state_machine = StateMachine.new
            state_machine.add_event('start', 'NIL',   'green'  )
            state_machine.add_event('warn',  'green',  'yellow' )
            state_machine.add_event('panic', 'green',  'red'    )
            state_machine.add_event('panic', 'yellow', 'red'    )
            state_machine.add_event('calm',  'red',    'yellow' )
            state_machine.add_event('clear', 'red',    'green'  )
            state_machine.add_event('clear', 'yellow', 'green'  )
            #name, timing, proc, state_or_event_name
            state_machine.add_callback('before', 'start',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('on', 'start',StateMachineMethod.gen_log_proc)

            state_machine.add_callback('before', 'warn',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('before', 'panic',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('before', 'calm',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('before', 'clear',StateMachineMethod.gen_log_proc)

            state_machine.add_callback('on', 'warn',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('on', 'panic',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('on', 'calm',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('on', 'clear',StateMachineMethod.gen_log_proc)

            state_machine.add_callback('after', 'anyevent',StateMachineMethod.gen_log_proc)

            state_machine.add_callback('leave', 'green',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('leave', 'yellow',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('leave', 'red',StateMachineMethod.gen_log_proc)

            state_machine.add_callback('on', 'green',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('on', 'yellow',StateMachineMethod.gen_log_proc)
            state_machine.add_callback('on', 'red',StateMachineMethod.gen_log_proc)

            state_machine.add_callback('enter', 'anystate',StateMachineMethod.gen_log_proc)
            state_machine.instance_variable_get("@callback_arr").size.must_equal 18

            state_machine.startup.availabe_events.size.must_equal(1)
            state_machine.current_state.name.must_equal :NIL
            state_machine.act("start")
            state_machine.current_state.name.must_equal :green
            state_machine.act("panic")


        end
    end
end