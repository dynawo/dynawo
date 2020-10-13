within OpenEMTP.NonElectrical.Blocks;

model VdqToVt
  Modelica.Blocks.Interfaces.RealInput Ud annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Uq annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Ut annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
 Ut = sqrt(Ud ^ 2 + Uq ^ 2);
annotation(
    Icon(graphics = {Rectangle(origin = {0, -1}, lineColor = {0, 0, 255}, extent = {{-100, 81}, {100, -81}}), Text(origin = {-4, 4}, extent = {{-56, 32}, {56, -32}}, textString = "Udq to Ut"), Text(origin = {-88, 61}, extent = {{-14, 9}, {22, -11}}, textString = "Ud"), Text(origin = {-90, -57}, extent = {{-14, 9}, {22, -11}}, textString = "Uq"), Text(origin = {76, 3}, extent = {{-14, 9}, {22, -11}}, textString = "Ut")}));
end VdqToVt;
