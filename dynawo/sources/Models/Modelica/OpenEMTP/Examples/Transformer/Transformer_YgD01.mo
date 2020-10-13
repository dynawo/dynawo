within OpenEMTP.Examples.Transformer;
model Transformer_YgD01
  extends Modelica.Icons.Example;
  Modelica.Electrical.MultiPhase.Basic.Resistor resistor(R = {250, 150, 350}) annotation (
    Placement(visible = true, transformation(origin = {32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.YgD01 ygD01(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.2, f = 60, v1 = 369.15, v2 = 20) annotation (
    Placement(visible = true, transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC(V = 369.15e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation (
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Inductor inductor(L = {240e-3, 410e-3, 310e-3}) annotation (
    Placement(visible = true, transformation(origin = {58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground1 annotation (
    Placement(visible = true, transformation(origin = {-52, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground G1 annotation (
    Placement(visible = true, transformation(origin = {82, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(inductor.plug_n, G1.positivePlug1) annotation (
    Line(points = {{68, 0}, {82, 0}, {82, -14}, {82, -14}}, color = {0, 0, 255}));
  connect(AC.plug_n, ground1.positivePlug1) annotation (
    Line(points = {{-40, 0}, {-52, 0}, {-52, -12}, {-52, -12}}, color = {0, 0, 255}));
  connect(resistor.plug_n, inductor.plug_p) annotation (
    Line(points = {{42, 0}, {48, 0}}));
  connect(AC.plug_p, ygD01.k) annotation (
    Line(points = {{-20, 0}, {-6, 0}}, color = {0, 0, 255}));
  connect(ygD01.m, resistor.plug_p) annotation (
    Line(points = {{14, 0}, {22, 0}}, color = {0, 0, 255}));
  annotation (
    uses(Modelica(version = "3.2.3")),
    experiment(StopTime = 0.032, Interval = 1e-06, Tolerance = 1e-05, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end Transformer_YgD01;
