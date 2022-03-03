within Dynawo.NonElectrical.Blocks.NonLinear;

model SectionControl
import Modelica;
parameter Real Ki "Integrator constant";
parameter Real U0 "Input value at init (avoids potentially unnecessary control at startup)";
parameter Real Y0 "Output value at init (avoids potentially unnecessary correction at startup)";
  Modelica.Blocks.Interfaces.RealInput u(start=U0) annotation(
    Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = [0, 1; 1.0199, 1; 1.02, 1.02; 1.0499, 1.02; 1.05, 1.05; 1.0799, 1.05; 1.08, 1.08; 1.09, 1.08])  annotation(
    Placement(visible = true, transformation(origin = {58, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start=Y0) annotation(
    Placement(visible = true, transformation(extent = {{138, -16}, {158, 4}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback discreteError annotation(
    Placement(visible = true, transformation(origin = {24, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Ki, y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {-11, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-60, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-49, -6}, {-23, -6}}, color = {0, 0, 127}));
  connect(u, add1.u1) annotation(
    Line(points = {{-120, 0}, {-72, 0}}, color = {0, 0, 127}));
  connect(discreteError.y, add1.u2) annotation(
    Line(points = {{16, -36}, {-80, -36}, {-80, -12}, {-72, -12}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], y) annotation(
    Line(points = {{69, -6}, {148, -6}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], discreteError.u1) annotation(
    Line(points = {{69, -6}, {80, -6}, {80, -36}, {32, -36}}, color = {0, 0, 127}));
  connect(integrator.y, discreteError.u2) annotation(
    Line(points = {{0, -6}, {24, -6}, {24, -28}}, color = {0, 0, 127}));
  connect(integrator.y, combiTable1D.u[1]) annotation(
    Line(points = {{0, -6}, {46, -6}}, color = {0, 0, 127}));
  annotation(
    Diagram);
end SectionControl;
