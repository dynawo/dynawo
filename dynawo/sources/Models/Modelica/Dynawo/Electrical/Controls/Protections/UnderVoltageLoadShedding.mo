within Dynawo.Electrical.Controls.Protections;

model UnderVoltageLoadShedding
  parameter Types.VoltageModulePu UMinPu;
  parameter Types.Time tLagAction;

  output Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the load";
  input Types.VoltageModulePu UMonitoredPu;
  Types.Time tThresholdReached(start = Modelica.Constants.inf);

equation
  when UMonitoredPu <= UMinPu and pre(switchOffSignal.value) == false then
    tThresholdReached = time;
  elsewhen UMonitoredPu > UMinPu and (pre(tThresholdReached) <> Modelica.Constants.inf and pre(switchOffSignal.value) == false) then
      tThresholdReached = Modelica.Constants.inf;
  end when;

  when time - tThresholdReached >= tLagAction then
    switchOffSignal.value = true;
  end when;

end UnderVoltageLoadShedding;
