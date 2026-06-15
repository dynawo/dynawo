within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffProtection "Switch-off signal for a protection"
  /* The two possible/expected switch-off signals for a protection are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  Constants.state state(start = State0) "Protection connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (running) then
    Timeline.logEvent1( TimelineKeys.ProtectionDisconnected);
    state = Constants.state.Open;
  elsewhen running and not
                          (pre(running)) then
    Timeline.logEvent1( TimelineKeys.ProtectionConnected);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffProtection;
