within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_07
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC07(V = 21.200000000000003e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = {60, 60, 60}, phase = {-0.4014257279587, -2.4958208303519, 1.6929693744345}, startTime = 0.5e-6 * {1, 1, 1}) annotation (
    Placement(visible = true, transformation(origin = {-10, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Bus B36 annotation (
    Placement(visible = true, transformation(origin = {-42, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Transformers.YgD01 YgD1(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.005, Rmg = 500, S = 1000, X = 0.27, f = 60, v1 = 345, v2 = 20) annotation (
    Placement(visible = true, transformation(origin = {-70, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation (
    Placement(visible = true, transformation(origin = {-99, 6}, extent = {{-9, -8}, {9, 8}}, rotation = 0), iconTransformation(origin = {1, 93.5}, extent = {{-11, -11.5}, {11, 11.5}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground G annotation (
    Placement(transformation(extent = {{2, -16}, {22, 4}})));
equation
  connect(YgD1.m, B36.positivePlug1) annotation (
    Line(points = {{-60, 6}, {-44, 6}}, color = {0, 0, 255}));
  connect(B36.positivePlug2, AC07.plug_p) annotation (
    Line(points = {{-40, 6}, {-20, 6}}, color = {0, 0, 255}));
  connect(k, YgD1.k) annotation (
    Line(points = {{-99, 6}, {-80, 6}}, color = {0, 0, 255}));
  connect(AC07.plug_n, G.positivePlug1) annotation (
    Line(points = {{0, 6}, {12, 6}, {12, 4}}, color = {0, 0, 255}));
  annotation (
    Diagram(coordinateSystem(extent = {{-100, -110}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -110}, {100, 100}}, initialScale = 0.1), graphics={  Ellipse(origin = {-20, -10}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360), Text(origin = {-22, -8}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-140, -134}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Line(points = {{0, 82}, {0, 52}}, color = {0, 0, 255})}));
end PowerPlant_07;
