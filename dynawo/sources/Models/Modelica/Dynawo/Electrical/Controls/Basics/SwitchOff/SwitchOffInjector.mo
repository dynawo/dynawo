within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffInjector "Switch-off model for an injector"
  /* The three possible/expected switch-off signals for a generator are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
     - a switch-off signal coming from an automaton/control block
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 3);

  Constants.state state(start = State0) "Injector connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (running) then
    Timeline.logEvent1(TimelineKeys.ComponentDisconnected);
    state = Constants.state.Open;
  elsewhen running and not
                          (pre(running)) then
    Timeline.logEvent1(TimelineKeys.ComponentConnected);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffInjector;
