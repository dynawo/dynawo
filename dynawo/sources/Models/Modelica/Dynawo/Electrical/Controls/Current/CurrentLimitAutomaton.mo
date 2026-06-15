within Dynawo.Electrical.Controls.Current;
model CurrentLimitAutomaton "Current Limit Automaton (CLA) monitoring one component"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Constraint;
  import Dynawo.NonElectrical.Logs.ConstraintKeys;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.CurrentModule IMax "Maximum current on the monitored component (unit depending on IMonitored unit)";
  parameter Integer OrderToEmit "Order to emit by the CLA (it should be a value corresponding to a state: [1:OPEN, 2:CLOSED, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";
  parameter Boolean Running "True if the CLA is activated";
  parameter Types.Time tLagBeforeActing "Time lag before taking action in s";

  //Inputs
  Modelica.Blocks.Interfaces.BooleanInput AutomatonExists = true "Pin to indicate to deactivate internal automaton natively present in C++ object";
  Dynawo.Connectors.ImPin IMonitored "Monitored current (unit depending on IMax unit)";

  //Output
  Dynawo.Connectors.IntPin order "Order emitted by the CLA (it should be a value corresponding to a state: [1:OPEN, 2:CLOSED, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";

protected
  discrete Types.Time tThresholdReached(start = Constants.inf) "Time when IMonitored > IMax was first reached in s";
  discrete Types.Time tOrder(start = Constants.inf) "Last time the automaton emitted an order in s";

equation
  when IMonitored.value > IMax and Running and pre(order.value) <> OrderToEmit then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax, IMonitored.value, String(tLagBeforeActing, significantDigits = 2));
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonArming);
  elsewhen IMonitored.value < IMax and pre(tThresholdReached) <> Constants.inf and pre(order.value) <> OrderToEmit then
    Constraint.logConstraintEndData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax, IMonitored.value, String(tLagBeforeActing, significantDigits = 2));
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonDisarming);
  end when;

  when tThresholdReached <> Constants.inf and tOrder == Constants.inf and der(IMonitored.value) < 0 then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax, pre(IMonitored.value), String(tLagBeforeActing, significantDigits = 2));
  end when;

  when time - tThresholdReached >= tLagBeforeActing then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadOpenCLA, "OverloadOpen", IMax, IMonitored.value, String(tLagBeforeActing, significantDigits = 2));
    order.value = OrderToEmit;
    tOrder = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonActing);
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The automaton will open one or several components when the current stays higher than a predefined threshold during a certain amount of time on a monitored component (line, transformer, etc.).</body></html>"));
end CurrentLimitAutomaton;
