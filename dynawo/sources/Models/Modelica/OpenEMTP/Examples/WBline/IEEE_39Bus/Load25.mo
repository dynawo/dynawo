within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load25
  Electrical.Load_Models.PQ_Load Load25(P = 224 / 3 * {1, 1, 1}, Q = 47.2 / 3 * {1, 1, 1}, V = 25.75, f = 60) annotation (
    Placement(transformation(extent = {{50, 8}, {70, 28}})));
  Electrical.Transformers.YgD01 LoadTransfo25(S = 400, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation (
    Placement(transformation(extent = {{32, 40}, {52, 60}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (
    Placement(visible = true, transformation(extent = {{-12, 40}, {8, 60}}, rotation = 0), iconTransformation(extent = {{-10, 86}, {10, 106}}, rotation = 0)));
equation
  connect(p, LoadTransfo25.k) annotation (
    Line(points = {{-2, 50}, {32, 50}}, color = {0, 0, 255}));
  connect(LoadTransfo25.m, Load25.positivePlug) annotation (
    Line(points = {{52, 50}, {66.8, 50}, {66.8, 28}}, color = {0, 0, 255}));
  annotation (
    Icon(graphics={  Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(origin = {-82, -134}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name")}));
end Load25;
