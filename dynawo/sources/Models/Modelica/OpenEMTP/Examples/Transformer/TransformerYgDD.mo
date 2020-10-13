within OpenEMTP.Examples.Transformer;

model TransformerYgDD
  extends Modelica.Icons.Example;
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.L L1(L = {240e-3, 410e-3, 310e-3}) annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage cosineVoltage(V = 369.15e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation(
    Placement(visible = true, transformation(origin = {-34, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.Transformers.YgDD YgDD(MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = {0.0021, 0.0020, 0.0040}, Rmg = 500, S = {350, 350, 350}, X = {0.1510, 0.1509, 0.2770}, f = 60, v = {735, 13.8, 13.8}) annotation(
    Placement(visible = true, transformation(origin = {-4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.R R1(R = {250, 150, 350}) annotation(
    Placement(visible = true, transformation(origin = {28, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground G1 annotation(
    Placement(visible = true, transformation(origin = {-60, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground G2 annotation(
    Placement(visible = true, transformation(origin = {80, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(R1.plug_n, G2.positivePlug1) annotation(
    Line(points = {{38, -12}, {80, -12}, {80, -14}, {80, -14}}, color = {0, 0, 255}));
  connect(L1.plug_n, G2.positivePlug1) annotation(
    Line(points = {{40, 10}, {80, 10}, {80, -14}, {80, -14}}, color = {0, 0, 255}));
  connect(cosineVoltage.plug_n, G1.positivePlug1) annotation(
    Line(points = {{-44, 0}, {-60, 0}, {-60, -6}, {-60, -6}}, color = {0, 0, 255}));
  connect(R1.plug_p, YgDD.p) annotation(
    Line(points = {{18, -12}, {16, -12}, {16, -4}, {6, -4}, {6, -4}}, color = {0, 0, 255}));
  connect(YgDD.k, cosineVoltage.plug_p) annotation(
    Line(points = {{-14, 0}, {-24, 0}, {-24, 0}, {-24, 0}}, color = {0, 0, 255}));
  connect(L1.plug_p, YgDD.m) annotation(
    Line(points = {{20, 10}, {14, 10}, {14, 4}, {6, 4}, {6, 2}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.032, Tolerance = 1e-06, Interval = 1e-06),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end TransformerYgDD;
