within Dynawo.Electrical.Controls.Transformers;
model PhaseShifterI "Phase-shifter monitoring the current so that it remains under iMax"
  extends BaseClasses.BaseTapChangerPhaseShifterMax(valueMax = iMax, valueStop = iStop, valueToMonitor0 = I0, factorValueToDisplay = factorValue, unitValueToDisplay = "A", Type = BaseClasses.TapChangerPhaseShifterParams.Automaton.PhaseShifter);

  parameter Types.CurrentModule iMax "Maximum allowed current";
  parameter Types.CurrentModule iStop "Current below which the phase-shifter will stop action";
  parameter Types.CurrentModule I0 "Initial current module";
  parameter Types.VoltageModule UNom = 0 "Nominal voltage in kV";
  final parameter Real factorValue = if UNom <> 0 then 1000 * SystemBase.SnRef/(sqrt(3) * UNom) else 1 "Multiplying factor for log messages of valueToMonitor (Pu to unit)";


  Dynawo.Connectors.ImPin iMonitored(value(start = I0)) "Monitored current";

equation
  connect(iMonitored, valueToMonitor);

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The phase shifter I ensures that the current on a line remains lower than a predefined threshold called valueMax. When the current monitored goes above IMax, the phase-shifter will act to modify its tap to bring back the current in an acceptable range.<div><div>The time interval before the first time change is specified with a first timer and a second timer indicates the time interval between further changes. The automaton can be locked by an external controller: in this case, it stops acting.&nbsp;</div><div><br></div><div>The detailed phase-shifter I behavior is explained in the following state diagram:
<figure>
    <img width=\"450\" src=\"modelica://Dynawo/Electrical/Controls/Transformers/Images/PhaseShifterI.png\">
</figure>

</div></div></body></html>"));
end PhaseShifterI;
