within Dynawo.Electrical.Controls.PEIR.BaseControls.GFL;

model CurrentLimitsCalculation "Simple current limits calculation block"

  parameter Types.PerUnit IMaxPu "Maximum inverter current amplitude in pu (base UNom, SNom)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";

  Modelica.Blocks.Interfaces.RealInput idConvRefUnlPu "Unlimited active current reference in pu" annotation(
    Placement(visible = true, transformation(origin = {-114, 60}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefUnlPu "Unlimited reactive current reference in pu" annotation(
    Placement(visible = true, transformation(origin = {-114, -60}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ipMinPu "Minimum active current in pu" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "Maximum active current in pu" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "Maximum reactive current in pu" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "Minimum reactive current in pu" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  if PQFlag then
    ipMaxPu = IMaxPu;
    iqMaxPu = noEvent(if IMaxPu ^ 2 > idConvRefUnlPu ^ 2 then sqrt(IMaxPu ^ 2 - idConvRefUnlPu ^ 2) else 0);
  else
    ipMaxPu = noEvent(if IMaxPu ^ 2 > iqConvRefUnlPu ^ 2 then sqrt(IMaxPu ^ 2 - iqConvRefUnlPu ^ 2) else 0);
    iqMaxPu = IMaxPu;
  end if;

  ipMinPu = -ipMaxPu;
  iqMinPu = -iqMaxPu;

end CurrentLimitsCalculation;
