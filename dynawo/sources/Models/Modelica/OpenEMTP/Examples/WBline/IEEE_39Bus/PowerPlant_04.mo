within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_04
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC04(
    V=20e3*sqrt(2/3)*{1,1,1},
    freqHz={60,60,60},
    phase={-0.47472955654246,-2.5691246589357,1.6196655458507}, startTime = 0.5e-6 * {1, 1, 1}) annotation (Placement(
        visible=true, transformation(
        origin={-2,30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Connectors.Bus B33 annotation (Placement(visible=true, transformation(
        origin={-34,30},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Electrical.Transformers.YgD01 YgD2(
    D=0.3,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    R=0.007,
    Rmg=500,
    S=1000,
    X=0.142,
    f=60,
    v1=369.15,
    v2=20) annotation (Placement(visible=true, transformation(
        origin={-62,30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Electrical.RLC_Branches.MultiPhase.Ground G2 annotation (Placement(visible=true,
        transformation(
        origin={28,12},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k
    annotation (Placement(visible = true, transformation(extent = {{-110, 20}, {-90, 40}}, rotation = 0), iconTransformation(extent = {{-110, -26}, {-90, -6}}, rotation = 0)));
equation
  connect(k, YgD2.k)
    annotation (Line(points={{-100, 30}, {-72, 30}}, color={0,0,255}));
  connect(AC04.plug_n, G2.positivePlug1)
    annotation (Line(points={{8,30},{28,30},{28,22}}, color={0,0,255}));
  connect(YgD2.m, B33.positivePlug1) annotation (
    Line(points = {{-52, 30}, {-36, 30}}, color = {0, 0, 255}));
  connect(B33.positivePlug2, AC04.plug_p) annotation (
    Line(points = {{-32, 30}, {-12, 30}}, color = {0, 0, 255}));

annotation (
    Icon(graphics={  Line(origin = {0, -16}, points = {{-80, 0}, {-80, 0}, {-88, 0}, {-96, 0}}, color = {28, 108, 200}), Text(origin = {-22, 4}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-78, 86}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-20, 2}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}));
end PowerPlant_04;
