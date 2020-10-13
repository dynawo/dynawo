within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load27
  Electrical.Load_Models.PQ_Load Load27(P=(281/3)*{1,1,1}, Q=(75.5/3)*{1,1,1}, V = 24.75, f = 60)
    annotation (Placement(transformation(extent={{4,-26},{24,-6}})));
  Electrical.Transformers.YgD01 LoadTransfo27(
    S=300,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(transformation(extent={{-8,22},{12,42}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        transformation(rotation=0, extent={{-5,86},{5,106}}), iconTransformation(extent={
            {-11,90},{8,110}})));
equation
  connect(LoadTransfo27.m, Load27.positivePlug)
    annotation (Line(points={{12,32},{20.8,32},{20.8,-6}}, color={0,0,255}));
  connect(p, LoadTransfo27.k)
    annotation (Line(points={{0,96},{-20,96},{-20,32},{-8,32}}, color={0,0,255}));
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
          extent={{-136,-114},{88,-192}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Load27;
