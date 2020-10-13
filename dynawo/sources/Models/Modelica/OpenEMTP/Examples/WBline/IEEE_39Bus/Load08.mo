within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load08
  OpenEMTP.Electrical.Load_Models.PQ_Load Load08(P=(522/3)*{1,1,1}, Q=(176/3)*{1,1,1}, V = 23.5, f = 60)
    annotation (Placement(visible = true, transformation(extent = {{24, -36}, {44, -16}}, rotation = 0)));
  Electrical.Transformers.YgD01 LoadTransfo08(
    S=650,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        visible = true,transformation( extent={{-45, 84}, {-35, 104}},rotation=0), iconTransformation(extent = {{-10, 90}, {9, 110}}, rotation = 0)));
equation
  connect(LoadTransfo08.m, Load08.positivePlug)
    annotation (Line(points={{6,0}, {41, 0}, {41, -16}}, color={0,0,255}));
  connect(p, LoadTransfo08.k)
    annotation (Line(points={{-40, 94}, {-40, 0.25}, {-14, 0.25}, {-14, 0}}, color={0,0,255}));
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
          extent={{-134,-112},{90,-190}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Load08;
