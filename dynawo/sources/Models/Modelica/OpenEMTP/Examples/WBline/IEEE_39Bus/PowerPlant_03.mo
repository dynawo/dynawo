within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_03
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage cosineVoltage4(
    V=19.6e3*sqrt(2/3)*{1,1,1},
    freqHz={60,60,60},
    phase={-0.4939281783144,-2.5883232807076,1.6004669240788}, startTime = 0.5e-6 * {1, 1, 1}) annotation (Placement(
        visible=true, transformation(
        origin={14,-10},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Connectors.Bus B32 annotation (Placement(visible=true, transformation(
        origin={-18,-10},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Electrical.Transformers.YgD01 YgD3(
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    R=0.003,
    Rmg=500,
    S=1000,
    X=0.20,
    f=60,
    v1=369.15,
    v2=20) annotation (Placement(visible=true, transformation(
        origin={-46,-10},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Electrical.RLC_Branches.MultiPhase.Ground G5 annotation (Placement(visible=true,
        transformation(
        origin={44,-28},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k
    annotation (Placement(visible = true, transformation(extent = {{-10, 90}, {10, 110}}, rotation = 0), iconTransformation(extent = {{-10, 82}, {10, 102}}, rotation = 0)));
equation
  connect(k, YgD3.k)
    annotation (Line(points={{0,100}, {-74, 100}, {-74, -10}, {-56, -10}}, color={0,0,255}));
  connect(cosineVoltage4.plug_n,G5. positivePlug1) annotation (
    Line(points={{24,-10},{44,-10},{44,-18}},                       color = {0, 0, 255}));
  connect(YgD3.m, B32.positivePlug1) annotation (
    Line(points = {{-36, -10}, {-20, -10}}, color = {0, 0, 255}));
  connect(B32.positivePlug2, cosineVoltage4.plug_p) annotation (
    Line(points = {{-16, -10}, {4, -10}}, color = {0, 0, 255}));

annotation (
    Icon(graphics={  Text(origin = {-20, 14}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-82, -112}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 12}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
end PowerPlant_03;
