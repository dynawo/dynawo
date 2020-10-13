within OpenEMTP.Examples.Machine;
model ParkTransformation
  Modelica.Blocks.Sources.Clock clock1 annotation (
    Placement(visible = true, transformation(extent={{-96,-92},{-76,-72}},    rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k=120*Modelica.Constants.pi)
    annotation (Placement(transformation(extent={{-60,-92},{-40,-72}})));
  Modelica.Blocks.Sources.Cosine cosine(
    amplitude=1,
    freqHz=60,
    phase=0) annotation (Placement(transformation(extent={{-98,52},{-78,72}})));
  Modelica.Blocks.Sources.Cosine cosine1(
    amplitude=1,
    freqHz=60,
    phase=-2.0943951023932)
    annotation (Placement(transformation(extent={{-98,14},{-78,34}})));
  Modelica.Blocks.Sources.Cosine cosine2(
    amplitude=1,
    freqHz=60,
    phase=2.0943951023932)
    annotation (Placement(transformation(extent={{-98,-26},{-78,-6}})));
  NonElectrical.Blocks.Multiplex3 Mux3
    annotation (Placement(transformation(extent={{-54,14},{-34,34}})));
  NonElectrical.Blocks.ParkTransform ParkTransform(PowerInvariant = true, Type = 2)
    annotation (Placement(transformation(extent={{-8,8},{12,28}})));
equation
  connect(gain.u, clock1.y)
    annotation (Line(points={{-62,-82},{-75,-82}}, color={0,0,127}));
  connect(Mux3.u2, cosine1.y)
    annotation (Line(points={{-56,24},{-77,24}}, color={0,0,127}));
  connect(Mux3.u1, cosine.y)
    annotation (Line(points={{-56,32},{-70,32},{-70,62},{-77,62}}, color={0,0,127}));
  connect(Mux3.u3, cosine2.y)
    annotation (Line(points={{-56,16},{-70,16},{-70,-16},{-77,-16}}, color={0,0,127}));
  connect(ParkTransform.u, Mux3.y)
    annotation (Line(points={{-10,24},{-33,24}}, color={0,0,127}));
  connect(ParkTransform.theta, gain.y)
    annotation (Line(points={{-10,12},{-18,12},{-18,-82},{-39,-82}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=0.5,
      Interval=0.0002,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end ParkTransformation;
