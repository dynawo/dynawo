within Dynawo.NonElectrical.Blocks.NonLinear;

model SectionControl
import Modelica;
parameter Real gain_gain;
parameter Real pi_gain;
parameter Real pi_t;
  Modelica.Blocks.Interfaces.RealInput u(start=0) annotation(
    Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = [0, 1; 1.019, 1; 1.02, 1.02; 1.049, 1.02; 1.05, 1.05; 1.079, 1.05; 1.08, 1.08; 1.09, 1.08])  annotation(
    Placement(visible = true, transformation(origin = {58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start=1) annotation(
    Placement(visible = true, transformation(extent = {{138, -10}, {158, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback discreteError annotation(
    Placement(visible = true, transformation(origin = {24, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 1, y_start = 1)  annotation(
    Placement(visible = true, transformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Ki, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-27, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-60, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-27, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {11, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(combiTable1D.y[1], firstOrder.u) annotation(
    Line(points = {{70, 0}, {92, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, y) annotation(
    Line(points = {{116, 0}, {148, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, discreteError.u1) annotation(
    Line(points = {{116, 0}, {120, 0}, {120, -36}, {32, -36}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{-16, -6}, {0, -6}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-49, -6}, {-41, -6}, {-41, -6}, {-39, -6}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{-16, 24}, {-6, 24}, {-6, 6}, {0, 6}, {0, 6}}, color = {0, 0, 127}));
  connect(u, add1.u1) annotation(
    Line(points = {{-120, 0}, {-72, 0}}, color = {0, 0, 127}));
  connect(add1.y, gain1.u) annotation(
    Line(points = {{-48, -6}, {-46, -6}, {-46, 24}, {-38, 24}}, color = {0, 0, 127}));
  connect(discreteError.y, add1.u2) annotation(
    Line(points = {{16, -36}, {-80, -36}, {-80, -12}, {-72, -12}}, color = {0, 0, 127}));
  connect(add.y, combiTable1D.u[1]) annotation(
    Line(points = {{22, 0}, {46, 0}}, color = {0, 0, 127}));
  connect(add.y, discreteError.u2) annotation(
    Line(points = {{22, 0}, {24, 0}, {24, -28}}, color = {0, 0, 127}));
  annotation(
    Diagram);
end SectionControl;
