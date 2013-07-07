# using Recursive Descent Parser. Chaper 21 from DSL


$:.unshift File.dirname(__FILE__)
require 'lexer'

class StateMachineParser
    def initialize(token_buffer)
        @token_buffer = token_buffer
        # private StateMachine machineResult;
        # private ArrayList<Event> machineEvents;
        # private ArrayList<Command> machineCommands;
        # private ArrayList<Event> resetEvents;
        # private Map<String, State> machineStates;
        # private State partialState;
        @machine_result = {}
        @machine_events = []
        @reset_events = []
    end
    def parser()
        if state_machine()
            # load_reset_event()
        end
        build()
    end
    def build()
        if @machine_events
            @machine_result[{:type=>:EVENT_BLOCK}] = @machine_events
        end
        @machine_result
    end

    # grammar file...
    #   stateMachine: eventBlock optionalResetBlock optionalCommandBlock stateList
    def state_machine()
        parse_sucess = false
        if event_block && optional_reset_block()
        # if event_block() && optional_reset_block() &&
        #     optional_command_block() && state_list()
            parse_sucess = true
        end
        parse_sucess
    end

    # grammar file...
    #   eventBlock: eventKeyword eventDecList endKeyword
    # private boolean eventBlock() {
    #     Token t;
    #     boolean parseSuccess = false;
    #     int save = tokenBuffer.getCurrentPosition();
    #     t = tokenBuffer.nextToken();
    #     if (t.isTokenType(ScannerPatterns.TokenTypes.TT_EVENT)) {
    #       tokenBuffer.popToken();
    #       parseSuccess = eventDecList();
    #     }
    #     if (parseSuccess) {
    #       t = tokenBuffer.nextToken();
    #       if (t.isTokenType(ScannerPatterns.TokenTypes.TT_END)) {
    #         tokenBuffer.popToken();
    #       }
    #       else {
    #         parseSuccess=false;
    # } }
    #     if (!parseSuccess) {
    #       tokenBuffer.resetCurrentPosition(save);
    # }
    #     return parseSuccess;
    #   }
    def event_block()
        parse_sucess = false;
        previous_position = @token_buffer.get_current_position()
        current_token = @token_buffer.next_token()
        if StateMachineTokenType.is_events(current_token)
            @token_buffer.pop_token()
            parse_sucess = event_dec_list()
        end
        if parse_sucess
            current_token = @token_buffer.next_token()
            if StateMachineTokenType.is_end(current_token)
                @token_buffer.pop_token()
            else
                parse_sucess = false
            end
        end
        if not parse_sucess
            @token_buffer.reset_current_position(previous_position)
        end
        parse_sucess
    end
    # grammar file...
    #   eventDecList: eventDec+
    # class StateMachineParser...
    #   private boolean eventDecList() {
    #     int save = tokenBuffer.getCurrentPosition();
    #     boolean parseSuccess = false;
    #     if (eventDec()) {
    #       parseSuccess = true;
    #       while (parseSuccess) {
    #         parseSuccess = eventDec();
    #       }
    #       parseSuccess = true;
    #     }
    #     else {
    #       tokenBuffer.resetCurrentPosition(save);
    # }
    #     return parseSuccess;
    #   }
    def event_dec_list()
        previous_position = @token_buffer.get_current_position()
        parse_sucess = false;
        if event_dec()
            parse_sucess = true
            while parse_sucess do
                parse_sucess = event_dec()
            end
            parse_sucess = true
        else
            @token_buffer.reset_current_position(previous_position)
        end
        parse_sucess
    end
    # grammar file...
    #   eventDec: identifier identifier
    # private boolean eventDec() {
    #     Token t;
    #     boolean parseSuccess = false;
    #     int save = tokenBuffer.getCurrentPosition();
    #     t = tokenBuffer.nextToken();
    #     String elementLeft = "";
    #     String elementRight = "";
    #     if (t.isTokenType(ScannerPatterns.TokenTypes.TT_IDENTIFIER)) {
    #       elementLeft = consumeIdentifier(t);
    #       t = tokenBuffer.nextToken();
    #       if (t.isTokenType(ScannerPatterns.TokenTypes.TT_IDENTIFIER)) {
    #         elementRight = consumeIdentifier(t);
    #         parseSuccess = true;
    #       }
    # }
    #     if (parseSuccess) {
    #       makeEventDec(elementLeft, elementRight);
    #     } else {
    #       tokenBuffer.resetCurrentPosition(save);
    # }
    #     return parseSuccess;
    #   }
    def event_dec()
        parse_sucess = false
        previous_position = @token_buffer.get_current_position()
        current_token = @token_buffer.next_token
        element_left = ""
        element_right = ""
        if StateMachineTokenType.is_identifier(current_token)
            element_left = consume_identifier(current_token)
            current_token = @token_buffer.next_token()
            if StateMachineTokenType.is_identifier(current_token)
                element_right = consume_identifier(current_token)
                parse_sucess = true
            end
        end
        if parse_sucess
            make_event_dec(element_left,element_right)
        else
            @token_buffer.reset_current_position(previous_position)
        end
        parse_sucess
    end
    # private String consumeIdentifier(Token t) {
    #      String identName = t.tokenValue;
    #     tokenBuffer.popToken();
    #     return identName;
    # }
    def consume_identifier(token)
        @token_buffer.pop_token()
        token[:payload]
    end
    # private void makeEventDec(String left, String right) {
    #     machineEvents.add(new Event(left, right));
    #   }    
    def make_event_dec(left, right)
        # @machine_events.push(Event.new(left,right))       
        @machine_events.push({:type=>:EVENT, :left=>left, :right=>right})       
    end

    # grammar file...
    #   optionalResetBlock: (resetBlock)?
    #   resetBlock: resetKeyword (resetEvent)* endKeyword
    #   resetEvent: identifier    
    # private boolean optionalResetBlock() {
    #     int save = tokenBuffer.getCurrentPosition();
    #     boolean parseSuccess = true;
    #     Token t = tokenBuffer.nextToken();
    #     if (t.isTokenType(ScannerPatterns.TokenTypes.TT_RESET)) {
    #       tokenBuffer.popToken();
    #       t = tokenBuffer.nextToken();
    #       parseSuccess = true;
    #       while ((!(t.isTokenType(ScannerPatterns.TokenTypes.TT_END))) &
    #             (parseSuccess)) {
    #         parseSuccess = resetEvent();
    #         t = tokenBuffer.nextToken();
    #       }
    #       if (parseSuccess) {
    #         tokenBuffer.popToken();
    #       } else {
    #         tokenBuffer.resetCurrentPosition(save);
    # } }
    #     return parseSuccess;
    #   }
    def optional_reset_block()
        parse_sucess = false
        return parse_sucess if @token_buffer.done?
        previous_position = @token_buffer.get_current_position()
        current_token = @token_buffer.next_token()
        if StateMachineTokenType.is_reset(current_token) 
            @token_buffer.pop_token()
            current_token = @token_buffer.next_token()
            parse_sucess = true
            while (not StateMachineTokenType.is_end(current_token)) and parse_sucess
                parse_sucess = reset_event()
                current_token = @token_buffer.next_token()
            end
            if parse_sucess
                @token_buffer.pop_token()
            else
                @token_buffer.reset_current_position(previous_position)
            end
        end
        parse_sucess
    end
    # private boolean resetEvent() {
    #     Token t;
    #     boolean parseSuccess = false;
    #     t = tokenBuffer.nextToken();
    #     if (t.isTokenType(ScannerPatterns.TokenTypes.TT_IDENTIFIER)) {
    #       resetEvents.add(findEventFromName(t.tokenValue));
    #       parseSuccess = true;
    #       tokenBuffer.popToken();
    #     }
    #     return parseSuccess;
    #   }    
    def reset_event()
        parse_sucess = false;
        current_token = @token_buffer.next_token()
        if StateMachineTokenType.is_identifier(current_token)
            @reset_events.push(find_event_from_name(current_token[:payload]))
            parse_sucess = true
            @token_buffer.pop_token()
        end
        parse_sucess
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'

    describe StateMachineParser do
        it "can parser the token list" do
            str = <<EOF
events
  doorClosed  D1CL
  drawOpened  D2OP
end
EOF

            token_list = [{:payload=>"events", :type_name=>:EVENTS}, 
                {:payload=>"doorClosed", :type_name=>:IDENTIFIER}, 
                {:payload=>"D1CL", :type_name=>:IDENTIFIER}, 
                {:payload=>"drawOpened", :type_name=>:IDENTIFIER}, 
                {:payload=>"D2OP", :type_name=>:IDENTIFIER}, 
                {:payload=>"end", :type_name=>:END}]
            StateMachineParser.new(TokenBuffer.new(token_list)).parser().must_equal({
                {:type=>:EVENT_BLOCK}=>[{:type=>:EVENT, :left=>"doorClosed", :right=>"D1CL"}, 
                    {:type=>:EVENT, :left=>"drawOpened", :right=>"D2OP"}]})
        end
    end
end
