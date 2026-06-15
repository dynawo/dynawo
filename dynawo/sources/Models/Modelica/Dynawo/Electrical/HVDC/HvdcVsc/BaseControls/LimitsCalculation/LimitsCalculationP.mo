within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.LimitsCalculation;
model LimitsCalculationP "Reactive and active currents limits calculation model for the active power control of the HVDC VSC model"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.LimitsCalculation.BaseLimitsCalculation;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput iqMod2Pu(start = 0) "Additional reactive current at terminal 2 in case of fault or overvoltage in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-30,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {111, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqRef2Pu(start = Iq0Pu) "Reactive current reference at terminal 2 in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {30,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMaxPu) "Maximum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 85}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu(start = -IpMaxPu) "Minimum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 69}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  if iqModPu == 0 and iqMod2Pu == 0 then
    ipMaxPu = IpMaxPu;
  else
    ipMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, max(iqRefPu ^ 2, iqRef2Pu ^ 2))));
  end if;

  ipMinPu = -ipMaxPu;

  annotation(preferredView = "text");
end LimitsCalculationP;
