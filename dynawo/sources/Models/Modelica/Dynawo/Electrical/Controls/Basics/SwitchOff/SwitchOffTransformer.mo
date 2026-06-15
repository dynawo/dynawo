within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffTransformer "Switch-off signal for a transformer"
  /* The only possible/expected switch-off signal for a transformer is:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  Constants.state state(start = State0) "Transformer connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (running) then
    Timeline.logEvent1(TimelineKeys.TransformerSwitchOff);
    state = Constants.state.Open;
  elsewhen running and not
                          (pre(running)) then
    Timeline.logEvent1(TimelineKeys.TransformerSwitchOn);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffTransformer;
