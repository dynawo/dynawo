within Dynawo.Examples.GridCodeSimulations;
record BaseParameters

  // Parameters to declare
  parameter Types.ApparentPowerModule SNom = 35 "Nominal apparent power in MVA";
  parameter Types.PerUnit XaPu = 0.05 * Electrical.SystemBase.SnRef / SNom "Reactance a of the DTR in pu (base SnRef, UNom)";
  parameter Types.PerUnit XbPu = 0.3 * Electrical.SystemBase.SnRef / SNom "Reactance b of the DTR in pu (base SnRef, UNom)";

  // Parameters that shouldn't be modified
  parameter Types.ActivePowerPu P0Pu = -1  * SNom / Electrical.SystemBase.SnRef "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.ReactivePowerPu Q0Pu = 0 * SNom / Electrical.SystemBase.SnRef "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.VoltageModulePu U0Pu = 1 "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.VoltageModulePu UInfPu = sqrt((P0Pu*XccPu)^2 + (Q0Pu*XccPu + U0Pu^2)^2)/U0Pu "Value of voltage magnitude at infinite in pu (base UNom)";
  parameter Types.Angle UPhase0 = Modelica.Math.atan2(-P0Pu*XccPu, Q0Pu*XccPu + U0Pu^2) "Start value of voltage phase angle at regulated bus in rad";
  parameter Types.PerUnit XccPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>In this file, you should declare :&nbsp;<div>- SNom of the plant being simulated (this won't change much as everything is in pu)</div><div>- XaPu and XbPu, stability impedances defined in the french grid code and provided in every connection project's requirement document.</div></body></html>"));
end BaseParameters;
