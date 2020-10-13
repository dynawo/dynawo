within OpenEMTP.Examples.Transformer;
model TransformerYgYgD
  extends Modelica.Icons.Example;
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.L L1(L = {240e-3, 410e-3, 310e-3}) annotation (
    Placement(visible = true, transformation(origin = {38, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.YgYgD YgYgD(MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = {0.00222, 0.0058, 0.00584}, Rmg = 2500, S = {1400, 1400, 1400}, X = {0.193, 0.292, 0.1}, f = 60, v = {365.7, 300, 12.5}) annotation (
    Placement(visible = true, transformation(origin = {-2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage cosineVoltage(V = 369.15e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation (
    Placement(visible = true, transformation(origin = {-34, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground G1 annotation (
    Placement(visible = true, transformation(origin = {-60, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.R R1(R = {250, 150, 350}) annotation (
    Placement(visible = true, transformation(origin = {38, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground G2 annotation (
    Placement(visible = true, transformation(origin = {80, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(R1.plug_n, G2.positivePlug1) annotation (
    Line(points = {{48, 14}, {80, 14}, {80, -16}, {80, -16}}, color = {0, 0, 255}));
  connect(L1.plug_n, G2.positivePlug1) annotation (
    Line(points = {{48, -16}, {80, -16}, {80, -16}, {80, -16}}, color = {0, 0, 255}));
  connect(R1.plug_p, YgYgD.m) annotation (
    Line(points = {{28, 14}, {18, 14}, {18, 2}, {8, 2}, {8, 2}}, color = {0, 0, 255}));
  connect(cosineVoltage.plug_n, G1.positivePlug1) annotation (
    Line(points = {{-44, 0}, {-60, 0}, {-60, -4}, {-60, -4}}, color = {0, 0, 255}));
  connect(YgYgD.k, cosineVoltage.plug_p) annotation (
    Line(points = {{-12, 0}, {-24, 0}}, color = {0, 0, 255}));
  connect(YgYgD.p, L1.plug_p) annotation (
    Line(points = {{8, -4}, {16, -4}, {16, -16}, {28, -16}, {28, -16}, {28, -16}}, color = {0, 0, 255}));
  annotation (
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end TransformerYgYgD;
