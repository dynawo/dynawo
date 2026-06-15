within Dynawo.Electrical.Controls.Current;
model PhaseShifterBlockingI "Phase Shifter blocking model"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.CurrentModule IMax "Maximum current on the monitored component";
  parameter Types.Time tLagBeforeActing "Time lag before taking action";

  input Types.CurrentModule IMonitored "Monitored current";

  output Boolean locked "Is phase shifter locked?";

protected
  discrete Types.Time tThresholdReached(start = Constants.inf) "Time when I > IMax was first reached";

equation
  when IMonitored > IMax and not
                                (pre(locked)) then
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBlockingIArming);
  elsewhen IMonitored <= IMax and pre(tThresholdReached) <> Constants.inf and not
                                                                                 (pre(locked)) then
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBlockingIDisarming);
  end when;

  when time - tThresholdReached >= tLagBeforeActing then
    locked = true;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBlockingIActing);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The automaton will block a Phase Shifter when the current stays higher than a predefined threshold during a certain amount of time on a monitored and controlled component (line, transformer, etc.)</body></html>"));
end PhaseShifterBlockingI;
