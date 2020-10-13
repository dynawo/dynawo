within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_06
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC06(V = 21e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = {60, 60, 60}, phase = {-0.44855, -2.54294, 1.64585}, startTime = 0.5e-6 * {1, 1, 1}) annotation (
    Placement(visible = true, transformation(origin = {-32, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Connectors.Bus B35 annotation (
    Placement(visible = true, transformation(origin = {-32, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Electrical.Transformers.YgD01 YgD6(D = 0.3, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.143, f = 60, v1 = 353.625, v2 = 20) annotation (
    Placement(visible = true, transformation(origin = {-32, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.RLC_Branches.MultiPhase.Ground G9 annotation (
    Placement(visible = true, transformation(origin = {-12, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation (
    Placement(visible = true, transformation(extent = {{-112, -30}, {-92, -10}}, rotation = 0), iconTransformation(extent = {{-10, -132}, {10, -112}}, rotation = 0)));
equation
  connect(YgD6.k, k) annotation (
    Line(points = {{-32, 4}, {-32, 4}, {-32, -20}, {-102, -20}, {-102, -20}}, color = {0, 0, 255}));
  connect(G9.positivePlug1, AC06.plug_n) annotation (
    Line(points = {{-12, 86}, {-14, 86}, {-14, 88}, {-32, 88}, {-32, 80}}, color = {0, 0, 255}));
  connect(AC06.plug_p, B35.positivePlug2) annotation (
    Line(points = {{-32, 60}, {-32, 46}}, color = {0, 0, 255}));
  connect(B35.positivePlug1, YgD6.m) annotation (
    Line(points = {{-32, 42}, {-32, 24}}, color = {0, 0, 255}));
  annotation (
    Icon(graphics={  Text(origin = {-22, 0}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-78, 82}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-20, -2}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360), Line(points = {{0, -102}, {0, -114}}, color = {0, 0, 255})}));
end PowerPlant_06;
