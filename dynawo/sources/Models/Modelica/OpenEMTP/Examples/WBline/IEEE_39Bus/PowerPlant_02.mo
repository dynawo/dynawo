within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_02
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC02(
    V=19.6e3*sqrt(2/3)*{1,1,1},
    freqHz={60,60,60},
    phase={-0.5235987755983,-2.6179938779915,1.5707963267949}, startTime = 0.5e-6 * {1, 1, 1}) annotation (Placement(
        visible=true, transformation(
        origin={-2,-4},
        extent={{-10,-10},{10,10}},
        rotation=-90)));
  Connectors.Bus B31 annotation (Placement(visible=true, transformation(
        origin={-2,20},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Electrical.Transformers.YgD01 YgD4(
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    R=0.003,
    Rmg=500,
    S=1000,
    X=0.25,
    f=60,
    v1=369.15,
    v2=20) annotation (Placement(visible=true, transformation(
        origin={-2,54},
        extent={{-10,-10},{10,10}},
        rotation=-90)));
  Electrical.RLC_Branches.MultiPhase.Ground G6 annotation (Placement(visible=true,
        transformation(
        origin={-2,-38},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k
    annotation (Placement(visible = true, transformation(origin = {38, 85}, extent = {{-13, -16}, {13, 16}}, rotation = 0), iconTransformation(origin = {1, 90}, extent = {{-12, -13}, {12, 13}}, rotation = 0)));
  OpenEMTP.Electrical.Load_Models.PQ_Load load31(P = 9.2 / 3 * {1, 1, 1}, Q = 4.6 / 3 * {1, 1, 1}, V = 20)  annotation (
    Placement(visible = true, transformation(origin = {-47, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(k, YgD4.k)
    annotation (Line(points={{38, 85}, {-2, 85}, {-2, 64}}, color={0,0,255}));
  connect(load31.positivePlug, B31.positivePlug2) annotation (
    Line(points = {{-40, 4}, {-40, 4}, {-40, 18}, {-2, 18}, {-2, 18}}, color = {0, 0, 255}));
  connect(YgD4.m, B31.positivePlug1) annotation (
    Line(points = {{-2, 44}, {-2, 22}}, color = {0, 0, 255}));
  connect(AC02.plug_n, G6.positivePlug1)
    annotation (Line(points={{-2,-14},{-2,-28}}, color={0,0,255}));
  connect(B31.positivePlug2, AC02.plug_p) annotation (
    Line(points = {{-2, 18}, {-2, 6}}, color = {0, 0, 255}));
  annotation (Diagram, Icon(
        graphics={  Text(origin = {-20, 12}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-72, -108}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 10}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
end PowerPlant_02;
