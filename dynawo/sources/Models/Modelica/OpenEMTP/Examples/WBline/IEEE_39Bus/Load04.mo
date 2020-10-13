within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load04
  OpenEMTP.Electrical.Load_Models.PQ_Load Load04(P=(500/3)*{1,1,1}, Q=(184/3)*{1,1,1}, V = 23.75, f = 60)
    annotation (Placement(visible = true, transformation(extent = {{-62, -18}, {-42, 2}}, rotation = 0)));
  Electrical.Transformers.YgD01 LoadTransfo04(
    S=700,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(transformation(extent={{-24,16},{-4,36}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        visible = true,transformation( extent={{90, 21}, {110, 31}},rotation=0), iconTransformation(extent = {{-10, 89}, {12, 106}}, rotation = 0)));
equation
  connect(LoadTransfo04.m, Load04.positivePlug)
    annotation (Line(points={{-4,26}, {-45, 26}, {-45, 2}}, color={0,0,255}));
  connect(p, LoadTransfo04.k)
    annotation (Line(points={{100, 26}, {-24, 26}}, color={0,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(initialScale = 0.1), graphics={
        Line(points={{0,88},{0,20},{0,20}}, color={0,0,255}),
        Line(points={{-80,20},{16,20},{80,20}}, color={0,0,255}),
Polygon(lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                      FillPattern.Solid, extent = {{-72, -48}, {-4, -112}}, textString = "P"), Polygon(lineColor = {28, 108, 200}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{6, -48}, {74, -112}}, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{-134, -112}, {90, -190}}, textString = "%name")}));
end Load04;
