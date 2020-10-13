within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_08
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC08(
    V=20.6e3*sqrt(2/3)*{1,1,1},
    freqHz={60,60,60},
    phase={-0.507891,-2.60229,1.5865}, startTime = 0.5e-6 * {1, 1, 1}) annotation (Placement(visible=true, transformation(
        origin={-30,30},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  OpenEMTP.Electrical.Transformers.YgD01 YgD01(
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    R=0.006,
    Rmg=500,
    S=1000,
    X=0.23,
    f=60,
    v1=353.625,
    v2=20) annotation (Placement(visible=true, transformation(
        origin={20,30},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  OpenEMTP.Connectors.Bus B37 annotation (Placement(visible=true, transformation(
        origin={-2,30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G1 annotation (Placement(visible=true,
        transformation(
        origin={-50,16},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k
    annotation (Placement(visible = true, transformation(extent = {{40, 20}, {60, 40}}, rotation = 0), iconTransformation(extent = {{-10, -102}, {10, -82}}, rotation = 0)));
equation
  connect(k, YgD01.k) annotation (
    Line(points = {{50, 30}, {30, 30}}, color = {0, 0, 255}));
  connect(YgD01.m, B37.positivePlug1) annotation (
    Line(points = {{10, 30}, {0, 30}}, color = {0, 0, 255}));
  connect(AC08.plug_p, B37.positivePlug2) annotation (
    Line(points = {{-20, 30}, {-4, 30}}, color = {0, 0, 255}));
  connect(AC08.plug_n, G1.positivePlug1) annotation (
    Line(points = {{-40, 30}, {-50, 30}, {-50, 26}}, color = {0, 0, 255}));

annotation (
    Icon(graphics={  Text(origin = {-20, 22}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-80, 96}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 20}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
    Diagram);
end PowerPlant_08;
