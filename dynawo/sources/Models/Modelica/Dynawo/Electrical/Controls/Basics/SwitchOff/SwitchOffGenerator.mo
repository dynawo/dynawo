within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffGenerator "Switch-off model for a generator"
  /* The three possible/expected switch-off signals for a generator are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
     - a switch-off signal coming from an automaton in the generator (under-voltage protection for example)
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 3);

  Constants.state state(start = State0) "Generator connection state";
  Real genState(start = Integer(State0)) "Generator continuous connection state";

  Modelica.Blocks.Math.IntegerToReal converter "Converter for generator state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (running) then
    Timeline.logEvent1(TimelineKeys.GeneratorDisconnected);
    state = Constants.state.Open;
  elsewhen running and not
                          (pre(running)) then
    Timeline.logEvent1(TimelineKeys.GeneratorConnected);
    state = Constants.state.Closed;
  end when;

  converter.y = genState;
  converter.u = Integer(state);

  annotation(preferredView = "text");
end SwitchOffGenerator;
