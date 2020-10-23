within OpenEMTP.Examples.CPline;

model SinglePhaseLine2
  Electrical.RLC_Branches.Ground G2 annotation(
    Placement(visible = true, transformation(origin = {80, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.RL RL1(L = 0.0446, R = 24) annotation(
    Placement(visible = true, transformation(origin = {48, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.CPmodel.SP_TLM sp_tlm(Zc = 270.719142291674, d = 100, r = 0.0127300000000000, tau = 0.000344896187279593) annotation(
    Placement(visible = true, transformation(origin = {-8, 80}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  Electrical.RLC_Branches.Ground G annotation(
    Placement(visible = true, transformation(origin = {-92, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Sources.CosineVoltage AC(Vm = 4.16 / sqrt(3)) annotation(
    Placement(visible = true, transformation(origin = {-66, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(RL1.n, G2.p) annotation(
    Line(points = {{58, 80}, {80, 80}, {80, 68}, {80, 68}}, color = {0, 0, 255}));
  connect(RL1.p, sp_tlm.pin_m) annotation(
    Line(points = {{38, 80}, {6, 80}}, color = {0, 0, 255}));
  connect(AC.p, sp_tlm.pin_k) annotation(
    Line(points = {{-56, 80}, {-24, 80}, {-24, 80}, {-22, 80}}, color = {0, 0, 255}));
  connect(AC.n, G.p) annotation(
    Line(points = {{-76, 80}, {-92, 80}, {-92, 72}, {-92, 72}}, color = {0, 0, 255}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 0.02, Tolerance = 1e-06, Interval = 2e-05),
    Icon(graphics = {Polygon(origin = {-4, 0}, lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(origin = {0, -2}, lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, extent = {{-100, -100}, {100, 102}}, endAngle = 360)}, coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    __OpenModelica_commandLineOptions = "");
end SinglePhaseLine2;
