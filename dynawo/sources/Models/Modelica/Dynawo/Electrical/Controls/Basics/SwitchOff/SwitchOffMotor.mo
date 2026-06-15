within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffMotor "Switch-off model for a motor"
  /* The three possible/expected switch-off signals for a motor are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
     - a switch-off signal coming from an automaton in the motor (under-voltage protection for example)
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 3);

  Constants.state state(start = State0) "Motor connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (running) then
    Timeline.logEvent1( TimelineKeys.MotorDisconnected);
    state = Constants.state.Open;
  elsewhen running and not
                          (pre(running)) then
    Timeline.logEvent1( TimelineKeys.MotorConnected);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffMotor;
