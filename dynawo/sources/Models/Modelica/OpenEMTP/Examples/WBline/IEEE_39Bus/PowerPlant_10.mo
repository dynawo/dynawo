within OpenEMTP.Examples.WBline.IEEE_39Bus;
model PowerPlant_10
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC10(
    V=20.8e3*sqrt(2/3)*{1,1,1},
    freqHz={60,60,60},
    phase={-0.60388392119004,-2.6982790235832,1.4905111812032}, startTime = 0.5e-6 * {1, 1, 1}) annotation (Placement(
        visible=true, transformation(
        origin={-46,-10},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  Electrical.Transformers.YgD01 YgD5(
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    R=0.003,
    Rmg=500,
    S=1000,
    X=0.18,
    f=60,
    v1=353.625,
    v2=20) annotation (Placement(visible=true, transformation(
        origin={4,-10},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  Connectors.Bus B30 annotation (Placement(visible=true, transformation(
        origin={-18,-10},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Electrical.RLC_Branches.MultiPhase.Ground G8 annotation (Placement(visible=true,
        transformation(
        origin={-66,-24},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k
    annotation (Placement(visible = true, transformation(extent = {{50, -110}, {70, -90}}, rotation = 0), iconTransformation(extent = {{-110, -28}, {-90, -8}}, rotation = 0)));
equation
  connect(AC10.plug_n, G8.positivePlug1)
    annotation (Line(points={{-56,-10},{-66,-10},{-66,-14}}, color={0,0,255}));
  connect(YgD5.m, B30.positivePlug1) annotation (
    Line(points = {{-6, -10}, {-16, -10}}, color = {0, 0, 255}));
  connect(AC10.plug_p, B30.positivePlug2) annotation (
    Line(points = {{-36, -10}, {-20, -10}}, color = {0, 0, 255}));
  connect(k, YgD5.k)
    annotation (Line(points={{60,-100},{38,-100},{38,-10},{14,-10}}, color={0,0,255}));
annotation (
    Icon(graphics={  Line(origin = {2.56881, -18.367}, points = {{-80, 0}, {-80, 0}, {-88, 0}, {-96, 0}}, color = {28, 108, 200}), Text(origin = {-20, 2}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-76, 84}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 0}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}));
end PowerPlant_10;
