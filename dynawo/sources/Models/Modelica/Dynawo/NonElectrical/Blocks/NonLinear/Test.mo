within Dynawo.NonElectrical.Blocks.NonLinear;

model Test
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI pi annotation(
    Placement(visible = true, transformation(origin = {-16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = [0, 0; 0.99, 1; 1.99, 1; 2, 2; 2.99, 2; 3, 3])  annotation(
    Placement(visible = true, transformation(origin = {58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain annotation(
    Placement(visible = true, transformation(origin = {-27, -37}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(extent = {{100, -10}, {120, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
equation
  connect(u, feedback.u1) annotation(
    Line(points = {{-120, 0}, {-66, 0}}, color = {0, 0, 127}));
  connect(pi.u, feedback.y) annotation(
    Line(points = {{-28, 0}, {-48, 0}}, color = {0, 0, 127}));
  connect(combiTable1D.u, pi.y) annotation(
    Line(points = {{46, 0}, {-4, 0}}, color = {0, 0, 127}));
  connect(feedback.u2, gain.y) annotation(
    Line(points = {{-58, -8}, {-58, -37}, {-37, -37}}, color = {0, 0, 127}));
  connect(gain.u, pi.y) annotation(
    Line(points = {{-16, -36}, {20, -36}, {20, 0}, {-4, 0}}, color = {0, 0, 127}));
  connect(combiTable1D.y, y) annotation(
    Line(points = {{70, 0}, {110, 0}}, color = {0, 0, 127}));

annotation(
    Diagram);
end Test;
