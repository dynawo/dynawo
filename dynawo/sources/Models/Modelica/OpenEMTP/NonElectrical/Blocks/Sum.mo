within OpenEMTP.NonElectrical.Blocks;

block Sum
  parameter Real k[5]=fill(1, 5) "Input gains";
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
    Placement(visible = true, transformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u2 annotation(
    Placement(visible = true, transformation(origin = {-80, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u3 annotation(
    Placement(visible = true, transformation(origin = {-80, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u4 annotation(
    Placement(visible = true, transformation(origin = {-80, -38}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u5 annotation(
    Placement(visible = true, transformation(origin = {-80, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, -104}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
y=k[1]*u1+k[2]*u2+k[3]*u3+k[4]*u4+k[5]*u5;

annotation(
    Icon(graphics = {Rectangle(origin = {2, 0}, lineColor = {0, 0, 255}, extent = {{-42, 150}, {38, -150}}), Text(origin = {-13, 14}, extent = {{-15, 30}, {45, -56}}, textString = "Sum")}, coordinateSystem(extent = {{-100, -150}, {100, 150}})),
    Diagram(coordinateSystem(extent = {{-100, -150}, {100, 150}})));
end Sum;
