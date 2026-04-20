within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls;

model VirtualPower
  Modelica.Blocks.Interfaces.RealInput idConvRefPu "value of id before saturated" annotation(
    Placement(visible = true, transformation(origin = {-88, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu "value of iq before saturated" annotation(
    Placement(visible = true, transformation(origin = {-122, 16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu"d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {-109, 90}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -86}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {74, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  
  Modelica.Blocks.Interfaces.RealOutput PvirtPu "Active virtual power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
equation
  PvirtPu = udFilterPu * idConvRefPu + uqFilterPu * iqConvRefPu;
end VirtualPower;