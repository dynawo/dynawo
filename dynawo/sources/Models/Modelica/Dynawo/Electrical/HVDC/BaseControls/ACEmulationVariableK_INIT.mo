within Dynawo.Electrical.HVDC.BaseControls;
model ACEmulationVariableK_INIT "Initialisation model for AC Emulation for HVDC with a variable KACEmulation"
  extends AdditionalIcons.Init;

  parameter Types.PerUnit KACEmulation0 "Start value of inverse of the emulated AC reactance (base SnRef or SNom) (receptor or generator convention). If in generator convention, KACEmulation should be < 0.";
  parameter Types.ActivePowerPu PRefSet0Pu "Raw reference active power in pu (base SnRef or SNom) (receptor or generator convention)";

  Types.Angle DeltaThetaFiltered0 "Start value of filtered angle difference in rad";
  Dynawo.Connectors.ActivePowerPuConnector PRef0Pu "Start value of active power reference in pu (base SnRef or SNom) (receptor or generator convention)";
  Dynawo.Connectors.AngleConnector Theta10 "Start value of angle of the voltage at terminal 1 in rad";
  Dynawo.Connectors.AngleConnector Theta20 "Start value of angle of the voltage at terminal 2 in rad";

equation
  DeltaThetaFiltered0 = (PRef0Pu - PRefSet0Pu) / KACEmulation0;

  annotation(preferredView = "text");
end ACEmulationVariableK_INIT;
