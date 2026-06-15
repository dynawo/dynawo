within Dynawo.Electrical.Controls.Machines.Protections;
model OVA "Over-Voltage Automaton"
  /* When the monitored voltage goes above a threshold (UMax)
     and does not go back below this threshold within a given time lag
     a tripping order is sent to the generator */
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.VoltageModulePu UMaxPu "Voltage threshold above which the automaton is activated in pu (base UNom)";
  parameter Types.Time tLagAction "Time-lag due to the actual trip action in s";

  Modelica.Blocks.Interfaces.RealInput UMonitoredPu "Monitored voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanOutput switchOffSignal(start = false) "Switch off message for the generator";

protected
  Types.Time tThresholdReached(start = Constants.inf) "Time when the threshold was reached";

equation
  // Voltage comparison with the maximum accepted value
  when UMonitoredPu >= UMaxPu and not
                                     (pre(switchOffSignal)) then
    tThresholdReached = time;
  elsewhen UMonitoredPu < UMaxPu and pre(tThresholdReached) <> Constants.inf and not
                                                                                    (pre(switchOffSignal)) then
    tThresholdReached = Constants.inf;
  end when;

  when UMonitoredPu >= UMaxPu and not
                                     (pre(switchOffSignal)) and tLagAction > 0 then
    Timeline.logEvent1(TimelineKeys.OVAArming);
  elsewhen UMonitoredPu < UMaxPu and pre(tThresholdReached) <> Constants.inf and not
                                                                                    (pre(switchOffSignal)) and tLagAction > 0 then
    Timeline.logEvent1(TimelineKeys.OVADisarming);
  end when;

  // Delay before tripping the generator
  when time - tThresholdReached >= tLagAction then
    switchOffSignal = true;
    Timeline.logEvent1(TimelineKeys.OVATripped);
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>This model will send a tripping order to a generator if the voltage stays above a threshold during a certain amount of time.</body></html>"));
end OVA;
