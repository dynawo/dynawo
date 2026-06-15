within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffDCLine "Switch-off signal for a DC line"
  /* The two possible/expected switch-off signals for each terminal of the DC line are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  extends SwitchOffLogicSide1(NbSwitchOffSignalsSide1 = 2);
  extends SwitchOffLogicSide2(NbSwitchOffSignalsSide2 = 2);

  Modelica.Blocks.Interfaces.BooleanOutput running(start = true) "Indicates if the component is running or not";

  Constants.state state(start = State0) "DC Line connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not
          (runningSide1) or not
                               (runningSide2) then
    Timeline.logEvent1(TimelineKeys.DCLineOpen);
    state = Constants.state.Open;
  elsewhen runningSide1 and runningSide2 and (not
                                                 (pre(runningSide1)) or not
                                                                           (pre(runningSide2))) then
    Timeline.logEvent1(TimelineKeys.DCLineClosed);
    state = Constants.state.Closed;
  end when;

  running = runningSide1 and runningSide2;

  annotation(preferredView = "text");
end SwitchOffDCLine;
