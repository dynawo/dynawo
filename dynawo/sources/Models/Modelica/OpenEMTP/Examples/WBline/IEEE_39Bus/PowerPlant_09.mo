within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_09
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC09(
    V=20.6e3*sqrt(2/3)*{1,1,1},
    freqHz={60,60,60},
    phase={-0.410152,-2.50455,1.68424}, startTime = 0.5e-6 * {1, 1, 1}) annotation (Placement(visible=true,
        transformation(
        origin={-10,-12},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Connectors.Bus B38 annotation (Placement(visible=true, transformation(
        origin={-42,-12},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Electrical.Transformers.YgD01 YgD02(
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    R=0.008,
    Rmg=500,
    S=1000,
    X=0.156,
    f=60,
    v1=353.625,
    v2=20) annotation (Placement(visible=true, transformation(
        origin={-70,-12},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Electrical.RLC_Branches.MultiPhase.Ground G annotation (Placement(visible=true,
        transformation(
        origin={22,-30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k
    annotation (Placement(visible = true, transformation(extent = {{-110, -22}, {-90, -2}}, rotation = 0), iconTransformation(extent = {{-112, -28}, {-92, -8}}, rotation = 0)));
equation
  connect(k, YgD02.k) annotation (Line(points={{-100, -12}, {-80, -12}},
        color={0,0,255}));
  connect(AC09.plug_n, G.positivePlug1)
    annotation (Line(points={{0,-12},{22,-12},{22,-20}}, color={0,0,255}));
  connect(YgD02.m, B38.positivePlug1) annotation (
    Line(points = {{-60, -12}, {-44, -12}}, color = {0, 0, 255}));
  connect(B38.positivePlug2, AC09.plug_p) annotation (
    Line(points = {{-40, -12}, {-20, -12}}, color = {0, 0, 255}));

annotation (
    Icon(graphics={  Line(origin = {0, -20}, points = {{-80, 0}, {-80, 0}, {-88, 0}, {-96, 0}}, color = {28, 108, 200}), Text(origin = {-22, 2}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-78, 80}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-20, 0}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}));
end PowerPlant_09;
