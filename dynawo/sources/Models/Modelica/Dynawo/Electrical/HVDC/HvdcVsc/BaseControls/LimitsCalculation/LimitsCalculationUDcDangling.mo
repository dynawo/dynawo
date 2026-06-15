within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.LimitsCalculation;
model LimitsCalculationUDcDangling "Reactive and active currents limits calculation model for the DC voltage control of the HVDC VSC model with terminal2 connected to a switched-off bus"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.LimitsCalculation.BaseLimitsCalculation;

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = InPu) "Maximum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 85}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu(start = -InPu) "Minimum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 69}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  if iqModPu == 0 then
    ipMaxPu = InPu;
  else
    ipMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, iqRefPu ^ 2)));
  end if;

  ipMinPu = -ipMaxPu;

  annotation(preferredView = "text");
end LimitsCalculationUDcDangling;
