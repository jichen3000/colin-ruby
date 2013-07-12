$:.unshift File.dirname(__FILE__)
require 'combinator_parser'
require 'state_machine_lexer'
require 'semantic_models'

class StateMachineSemanticModelBuilder
    class << self
        def build(filename, callback_module)
            token_list = StateMachineTokenType.tokenize(File.readlines(filename).join(""))
            token_buffer = TokenBuffer.new(token_list)
            syntax_tree = StateMachineCombinatorParser.new(token_buffer).parse()
            build_to_models(syntax_tree, callback_module)
        end
        def build_to_models(syntax_tree, callback_module)
            state_machine = StateMachine.new
            syntax_tree[:events].each do |event_value_list|
                state_machine.add_event(*event_value_list )
            end
            syntax_tree[:callbacks].each do |timing, state_or_event_name, method_name|
                state_machine.add_callback(timing, state_or_event_name,
                    get_unbind_method(callback_module, method_name))
            end
            state_machine
        end
        def get_unbind_method(callback_module, method_name)
            callback_module.instance_method(method_name)
        end
    end
end
# In this module, you can defind the methods which you will used in the script files as method name
module CallbackModule
    def log_proc(event_or_state, callback)
        p "log: A callback is invoked #{callback.timing.to_s} the "+
            "#{event_or_state.name.to_s} #{callback.obj_class.to_s} "+
            "(actually #{callback.obj_name.to_s} #{callback.obj_class.to_s})."
    end
end
if __FILE__ == $0
    require "minitest/autorun"
    require "minitest/spec"
    describe StateMachineSemanticModelBuilder do
        it "can build" do
            state_machine = StateMachineSemanticModelBuilder.build("test.script", CallbackModule)
            state_machine.instance_variable_get("@callback_arr").size.must_equal 18

            state_machine.startup.availabe_events.size.must_equal(1)
            state_machine.current_state.name.must_equal :NIL
            state_machine.act("start")
            state_machine.current_state.name.must_equal :green
            state_machine.act("panic")

        end
    end
end



