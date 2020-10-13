within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load26
  Electrical.Load_Models.PQ_Load Load26(P=(139/3)*{1,1,1}, Q=(17/3)*{1,1,1}, V = 25.5, f = 60)
    annotation (Placement(transformation(extent={{38,-30},{58,-10}})));
  Electrical.Transformers.YgD01 LoadTransfo26(
    S=200,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(transformation(extent={{6,-6},{26,14}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        visible = true,transformation( extent={{-52, -6}, {-32, 14}},rotation=0), iconTransformation(extent = {{-10, 86}, {10, 106}}, rotation = 0)));
equation
  connect(LoadTransfo26.m, Load26.positivePlug)
    annotation (Line(points={{26,4},{54.8,4},{54.8,-10}}, color={0,0,255}));
  connect(p, LoadTransfo26.k)
    annotation (Line(points={{-42, 4}, {6, 4}}, color={0,0,255}));
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
          extent={{-124,-94},{100,-172}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Load26;
