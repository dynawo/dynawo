within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load23
  Electrical.Load_Models.PQ_Load Load23(P=(247.5/3)*{1,1,1}, Q=(84.6/3)*{1,1,1}, V = 25.25, f = 60)
    annotation (Placement(transformation(extent={{20,-24},{40,-4}})));
  Electrical.Transformers.YgD01 LoadTransfo23(
    S=400,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(transformation(extent={{-12,4},{8,24}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        transformation(rotation=0, extent={{-3,95},{7,105}}), iconTransformation(extent={
            {-8,90},{7,105}})));
equation
  connect(LoadTransfo23.m, Load23.positivePlug)
    annotation (Line(points={{8,14},{36.8,14},{36.8,-4}}, color={0,0,255}));
  connect(p, LoadTransfo23.k)
    annotation (Line(points={{2,100},{-32,100},{-32,14},{-12,14}}, color={0,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Line(points={{0,88},{0,20},{0,20}}, color={0,0,255}),
        Line(points={{-80,20},{16,20},{80,20}}, color={0,0,255}),
        Polygon(
          points={{-60,-30},{-20,-30},{-40,-50},{-60,-30}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,-48},{-4,-112}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Polygon(
          points={{18,-30},{58,-30},{38,-50},{18,-30}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{6,-48},{74,-112}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Q"),
        Line(points={{-40,20},{-40,-26},{-40,-30},{-42,-30},{-40,-30}}, color={0,0,255}),
        Line(points={{40,20},{40,-30}}, color={0,0,255}),
        Text(
          extent={{-136,-112},{88,-190}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Load23;
