within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffTapChangerPhaseShifter "Switch-off model for a tap-changer or a phase-shifter"
  /* The only possible/expected switch-off signal for a tap-changer is:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.Automaton;

  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  parameter Automaton Type;

equation
  when not
          (running) then
    if (Type == Automaton.TapChanger) then
      Timeline.logEvent1(TimelineKeys.TapChangerSwitchOff);
    elseif (Type == Automaton.PhaseShifter) then
      Timeline.logEvent1(TimelineKeys.PhaseShifterSwitchOff);
    end if;
  elsewhen running and not
                          (pre(running)) then
    if (Type == Automaton.TapChanger) then
      Timeline.logEvent1(TimelineKeys.TapChangerSwitchOn);
    elseif (Type == Automaton.PhaseShifter) then
      Timeline.logEvent1(TimelineKeys.PhaseShifterSwitchOn);
    end if;
  end when;

  annotation(preferredView = "text");
end SwitchOffTapChangerPhaseShifter;
