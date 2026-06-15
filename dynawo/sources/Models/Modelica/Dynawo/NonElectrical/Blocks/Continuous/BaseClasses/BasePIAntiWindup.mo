within Dynawo.NonElectrical.Blocks.Continuous.BaseClasses;
block BasePIAntiWindup "Base block for anti-windup proportional integral controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit Ki "Integral gain";
  parameter Types.PerUnit Kp "Proportional gain";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(
    Placement(visible = true, transformation(extent = {{-180, -20}, {-140, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(
    Placement(visible = true, transformation(extent = {{140, -10}, {160, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Ki, y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  parameter Types.PerUnit Y0 "Initial output of controller";

equation
  connect(u, add1.u1) annotation(
    Line(points = {{-160, 0}, {-120, 0}, {-120, -14}, {-102, -14}}, color = {0, 0, 127}));
  connect(feedback1.y, add1.u2) annotation(
    Line(points = {{31, -60}, {-120, -60}, {-120, -26}, {-102, -26}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-79, -20}, {-63, -20}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{-39, -20}, {-20, -20}, {-20, -6}, {-3, -6}}, color = {0, 0, 127}));
  connect(u, gain.u) annotation(
    Line(points = {{-160, 0}, {-120, 0}, {-120, 20}, {-62, 20}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{-39, 20}, {-20, 20}, {-20, 6}, {-3, 6}}, color = {0, 0, 127}));
  connect(add.y, feedback1.u2) annotation(
    Line(points = {{21, 0}, {40, 0}, {40, -52}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end BasePIAntiWindup;
