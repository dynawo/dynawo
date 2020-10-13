within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Earth
  Electrical.RLC_Branches.MultiPhase.Ground G3
    annotation (Placement(transformation(extent={{8,-44},{28,-24}})));
  Electrical.RLC_Branches.MultiPhase.R R(R=100E6*{1,1,1})
    annotation (Placement(transformation(extent={{-6,-26},{14,-6}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug plug_p annotation (Placement(
        transformation(rotation=0, extent={{-5,86},{5,106}}), iconTransformation(extent={
            {-9,90},{10,110}})));
equation
  connect(R.plug_n,G3. positivePlug1)
    annotation (Line(points={{14,-16},{18,-16},{18,-24}},       color={0,0,255}));
  connect(plug_p, R.plug_p)
    annotation (Line(points={{0,96},{-28,96},{-28,-16},{-6,-16}}, color={0,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-60,50},{60,50}}, color={0,0,255}),
        Line(points={{-40,30},{40,30}}, color={0,0,255}),
        Line(points={{-20,10},{20,10}}, color={0,0,255}),
        Line(points={{0,90},{0,50}}, color={0,0,255})}));
end Earth;
