within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffIdealSwitch "Switch-off signal for an ideal switch"
  /* The only possible/expected switch-off signal for an ideal switch is:
     - a switch-off signal coming from the outside (event or controller)
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 1);

  Constants.state state(start = State0) "Ideal switch connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (running) then
    Timeline.logEvent1(TimelineKeys.IdealSwitchSwitchOff);
    state = Constants.state.Open;
  elsewhen running and not
                          (pre(running)) then
    Timeline.logEvent1(TimelineKeys.IdealSwitchSwitchOn);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffIdealSwitch;
