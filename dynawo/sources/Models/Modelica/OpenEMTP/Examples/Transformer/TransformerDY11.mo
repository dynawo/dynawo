within OpenEMTP.Examples.Transformer;
model TransformerDY11
  extends Modelica.Icons.Example;
  Modelica.Electrical.MultiPhase.Basic.Resistor resistor(R = {250, 150, 350}) annotation (
    Placement(visible = true, transformation(origin = {38, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC(V = 369.15e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation (
    Placement(visible = true, transformation(origin = {-24, 98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Inductor inductor(L = {240e-3, 410e-3, 310e-3}) annotation (
    Placement(visible = true, transformation(origin = {66, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.DY11 dy11(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.2, f = 60, v1 = 369.15, v2 = 20) annotation (
    Placement(visible = true, transformation(origin = {6, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Inductor inductor1(L = {240e-3, 410e-3, 310e-3}) annotation (
    Placement(visible = true, transformation(origin = {66, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Resistor resistor1(R = {250, 150, 350}) annotation (
    Placement(visible = true, transformation(origin = {40, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.DY01 dy01(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.2, f = 60, v1 = 369.15, v2 = 20) annotation (
    Placement(visible = true, transformation(origin = {8, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage cosineVoltage(V = 369.15e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation (
    Placement(visible = true, transformation(origin = {-22, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground1 annotation (
    Placement(visible = true, transformation(origin = {-58, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground2 annotation (
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground3 annotation (
    Placement(visible = true, transformation(origin = {100, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground4 annotation (
    Placement(visible = true, transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(inductor1.plug_n, ground4.positivePlug1) annotation (
    Line(points = {{76, -34}, {100, -34}, {100, -50}, {100, -50}}, color = {0, 0, 255}));
  connect(inductor.plug_n, ground3.positivePlug1) annotation (
    Line(points = {{76, 98}, {100, 98}, {100, 82}, {100, 82}}, color = {0, 0, 255}));
  connect(resistor.plug_n, inductor.plug_p) annotation (
    Line(points = {{48, 98}, {56, 98}}));
  connect(cosineVoltage.plug_n, ground2.positivePlug1) annotation (
    Line(points = {{-32, -34}, {-60, -34}, {-60, -50}, {-60, -50}, {-60, -50}}, color = {0, 0, 255}));
  connect(AC.plug_n, ground1.positivePlug1) annotation (
    Line(points = {{-34, 98}, {-58, 98}, {-58, 80}, {-58, 80}}, color = {0, 0, 255}));
  connect(dy11.k, AC.plug_p) annotation (
    Line(points = {{-4, 98}, {-14, 98}}, color = {0, 0, 255}));
  connect(dy11.m, resistor.plug_p) annotation (
    Line(points = {{16, 98}, {28, 98}}, color = {0, 0, 255}));
  connect(resistor1.plug_n, inductor1.plug_p) annotation (
    Line(points = {{50, -34}, {56, -34}}));
  connect(dy01.k, cosineVoltage.plug_p) annotation (
    Line(points = {{-2, -34}, {-12, -34}, {-12, -34}, {-12, -34}}, color = {0, 0, 255}));
  connect(dy01.m, resistor1.plug_p) annotation (
    Line(points = {{18, -34}, {30, -34}, {30, -34}, {30, -34}}, color = {0, 0, 255}));
  annotation (
    uses(Modelica(version = "3.2.3")),
    experiment(StopTime = 0.032, Interval = 1e-06, Tolerance = 1e-05, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end TransformerDY11;
