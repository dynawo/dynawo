within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_01
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage cosineVoltage5(V = 244.95e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = {60, 60, 60}, phase = {-0.205949, -2.30034, 1.88845}, startTime = 0.5e-6 * {1, 1, 1}) annotation (
    Placement(visible = true, transformation(origin = {-12, -54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Connectors.Bus BusSM annotation (
    Placement(visible = true, transformation(origin = {-12, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G7 annotation (
    Placement(visible = true, transformation(origin = {-12, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug positivePlug2 annotation (
    Placement(visible = true, transformation(extent = {{90, -10}, {110, 10}}, rotation = 0), iconTransformation(extent = {{-10, 88}, {10, 108}}, rotation = 0)));
equation
  connect(cosineVoltage5.plug_n, G7.positivePlug1) annotation (
    Line(points = {{-12, -64}, {-12, -76}}, color = {0, 0, 255}));
  connect(BusSM.positivePlug2, cosineVoltage5.plug_p) annotation (
    Line(points = {{-12, -28}, {-12, -44}}, color = {0, 0, 255}));
  connect(positivePlug2, BusSM.positivePlug2) annotation (
    Line(points = {{100, 0}, {100, -4}, {-12, -4}, {-12, -28}}, color = {0, 0, 255}));
  annotation (
    Icon(graphics = {Text(origin = {-20, 4}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-136, -120}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 2}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360), Line(points = {{0, 88}, {0, 66}, {0, 64}}, color = {0, 0, 255})}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end PowerPlant_01;
