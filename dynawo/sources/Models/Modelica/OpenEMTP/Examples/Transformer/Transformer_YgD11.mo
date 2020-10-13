within OpenEMTP.Examples.Transformer;
model Transformer_YgD11
  extends Modelica.Icons.Example;
  Modelica.Electrical.MultiPhase.Basic.Resistor resistor(R = {250, 150, 350}) annotation (
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.YgD11 ygD11(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.2, f = 60, v1 = 369.15, v2 = 20) annotation (
    Placement(visible = true, transformation(origin = {6, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC(V = 369.15e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation (
    Placement(visible = true, transformation(origin = {-28, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Inductor inductor(L = {240e-3, 410e-3, 310e-3}) annotation (
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground1 annotation (
    Placement(visible = true, transformation(origin = {-56, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground G annotation (
    Placement(visible = true, transformation(origin = {80, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(inductor.plug_n, G.positivePlug1) annotation (
    Line(points = {{70, 0}, {80, 0}, {80, -16}, {80, -16}}, color = {0, 0, 255}));
  connect(AC.plug_n, ground1.positivePlug1) annotation (
    Line(points = {{-38, 0}, {-56, 0}, {-56, -8}, {-56, -8}}, color = {0, 0, 255}));
  connect(resistor.plug_n, inductor.plug_p) annotation (
    Line(points = {{44, 0}, {50, 0}}));
  connect(ygD11.k, AC.plug_p) annotation (
    Line(points = {{-4, 0}, {-18, 0}}, color = {0, 0, 255}));
  connect(ygD11.m, resistor.plug_p) annotation (
    Line(points = {{16, 0}, {24, 0}}));
  annotation (
    uses(Modelica(version = "3.2.3")),
    experiment(StopTime = 0.032, Interval = 1e-06, Tolerance = 1e-05, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end Transformer_YgD11;
