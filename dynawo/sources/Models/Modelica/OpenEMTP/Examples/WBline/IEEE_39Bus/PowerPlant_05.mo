within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_05
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC05(
    V=20.2e3*sqrt(2/3)*{1,1,1},
    freqHz={60,60,60},
    phase={-0.49043751981041,-2.5848326222036,1.6039575825828}, startTime = 0.5e-6 * {1, 1, 1}) annotation (Placement(
        visible=true, transformation(
        origin={40, 0},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  OpenEMTP.Connectors.Bus B34 annotation (Placement(visible=true, transformation(
        origin={8, 0},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  OpenEMTP.Electrical.Transformers.YgD01 YgD1(
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    R=0.005,
    Rmg=500,
    S=600,
    X=0.11,
    f=60,
    v1=302.7,
    v2=20) annotation (Placement(visible=true, transformation(
        origin={-16, 0},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G4 annotation (Placement(visible=true,
        transformation(
        origin={72, -18},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k
    annotation (Placement(visible = true, transformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0), iconTransformation(extent = {{-10, 82}, {10, 102}}, rotation = 0)));
equation
  connect(YgD1.k, k) annotation (
    Line(points = {{-26, 0}, {-98, 0}, {-98, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(AC05.plug_n, G4.positivePlug1) annotation (
    Line(points = {{50, 0}, {72, 0}, {72, -8}}, color = {0, 0, 255}));
  connect(YgD1.m, B34.positivePlug1) annotation (
    Line(points = {{-6, 0}, {6, 0}}, color = {0, 0, 255}));
  connect(B34.positivePlug2, AC05.plug_p) annotation (
    Line(points = {{10, 0}, {30, 0}}, color = {0, 0, 255}));

annotation (
    Icon(graphics={  Text(origin = {-20, 16}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-78, -108}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 14}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360), Line(origin = {0, 79}, points = {{0, 3}, {0, -3}, {0, -3}})}, coordinateSystem(initialScale = 0.1)));
end PowerPlant_05;
