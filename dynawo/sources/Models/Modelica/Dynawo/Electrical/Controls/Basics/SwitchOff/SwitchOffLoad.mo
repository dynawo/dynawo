within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffLoad "Switch-off model for a load"
  /* The two possible/expected switch-off signals for a load are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  Constants.state state(start = State0) "Load connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (running) then
    Timeline.logEvent1(TimelineKeys.LoadDisconnected);
    state = Constants.state.Open;
  elsewhen running and not
                          (pre(running)) then
    Timeline.logEvent1(TimelineKeys.LoadConnected);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffLoad;
