within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load21
  Electrical.Load_Models.PQ_Load Load21(P=(274/3)*{1,1,1}, Q=(115/3)*{1,1,1}, V = 25, f = 60)
    annotation (Placement(transformation(extent={{14,-12},{34,8}})));
  Electrical.Transformers.YgD01 LoadTransfo21(
    S=800,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(transformation(extent={{-18,16},{2,36}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        transformation(rotation=0, extent={{-10,90},{10,110}}), iconTransformation(extent=
           {{-10,90},{10,110}})));
equation
  connect(LoadTransfo21.m, Load21.positivePlug)
    annotation (Line(points={{2,26},{30.8,26},{30.8,8}}, color={0,0,255}));
  connect(p, LoadTransfo21.k)
    annotation (Line(points={{0,100},{-60,100},{-60,26},{-18,26}}, color={0,0,255}));
  annotation (Icon(graphics={
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
          extent={{-134,-112},{90,-190}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Load21;
