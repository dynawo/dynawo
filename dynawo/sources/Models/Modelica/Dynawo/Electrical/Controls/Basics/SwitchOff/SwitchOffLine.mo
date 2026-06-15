within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffLine "Switch-off signal for a line"
  /* The two possible/expected switch-off signals for a line are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  Constants.state state(start = State0) "Line connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (running) then
    Timeline.logEvent1(TimelineKeys.LineOpen);
    state = Constants.state.Open;
  elsewhen running and not
                          (pre(running)) then
    Timeline.logEvent1(TimelineKeys.LineClosed);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffLine;
