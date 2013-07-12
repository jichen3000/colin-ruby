This is a simple project for an easy finite state machine.
Now this machine just have State, Event, Callback.
before > leave > on event > enter > after > on state

    events: [
      { name: 'start', from: 'none',   to: 'green'  },
      { name: 'warn',  from: 'green',  to: 'yellow' },
      { name: 'panic', from: 'green',  to: 'red'    },
      { name: 'panic', from: 'yellow', to: 'red'    },
      { name: 'calm',  from: 'red',    to: 'yellow' },
      { name: 'clear', from: 'red',    to: 'green'  },
      { name: 'clear', from: 'yellow', to: 'green'  },
    ],

    callbacks: {
      onbeforestart: function(event, from, to) { log("STARTING UP"); },
      onstart:       function(event, from, to) { log("READY");       },

      onbeforewarn:  function(event, from, to) { log("START   EVENT: warn!",  true);  },
      onbeforepanic: function(event, from, to) { log("START   EVENT: panic!", true);  },
      onbeforecalm:  function(event, from, to) { log("START   EVENT: calm!",  true);  },
      onbeforeclear: function(event, from, to) { log("START   EVENT: clear!", true);  },

      onwarn:        function(event, from, to) { log("FINISH  EVENT: warn!");         },
      onpanic:       function(event, from, to) { log("FINISH  EVENT: panic!");        },
      oncalm:        function(event, from, to) { log("FINISH  EVENT: calm!");         },
      onclear:       function(event, from, to) { log("FINISH  EVENT: clear!");        },

      onleavegreen:  function(event, from, to) { log("LEAVE   STATE: green");  },
      onleaveyellow: function(event, from, to) { log("LEAVE   STATE: yellow"); },
      onleavered:    function(event, from, to) { log("LEAVE   STATE: red");    async(to); return StateMachine.ASYNC; },

      ongreen:       function(event, from, to) { log("ENTER   STATE: green");  },
      onyellow:      function(event, from, to) { log("ENTER   STATE: yellow"); },
      onred:         function(event, from, to) { log("ENTER   STATE: red");    },

      onchangestate: function(event, from, to) { log("CHANGED STATE: " + from + " to " + to); }
    }
  });
