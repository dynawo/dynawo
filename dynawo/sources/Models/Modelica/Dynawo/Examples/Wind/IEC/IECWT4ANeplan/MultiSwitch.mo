within Dynawo.Examples.Wind.IEC.IECWT4ANeplan;

model MultiSwitch
  import Modelica;
  import Dynawo;
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 3)  annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-94, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u2 annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-84, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u3 annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-74, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerStep integerStep(offset = 1, startTime = 0.5)  annotation(
    Placement(visible = true, transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(u1, multiSwitch.u[1]) annotation(
    Line(points = {{-120, 20}, {-60, 20}, {-60, 10}, {-10, 10}}, color = {0, 0, 127}));
  connect(u2, multiSwitch.u[2]) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, 10}, {-10, 10}}, color = {0, 0, 127}));
  connect(u3, multiSwitch.u[3]) annotation(
    Line(points = {{-120, -20}, {-60, -20}, {-60, 10}, {-10, 10}}, color = {0, 0, 127}));
  connect(integerStep.y, multiSwitch.f) annotation(
    Line(points = {{-18, 50}, {0, 50}, {0, 22}}, color = {255, 127, 0}));
end MultiSwitch;
