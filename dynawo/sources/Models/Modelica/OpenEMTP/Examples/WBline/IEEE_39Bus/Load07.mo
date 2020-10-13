within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load07
  OpenEMTP.Electrical.Load_Models.PQ_Load Load07(P=(233.8/3)*{1,1,1}, Q=(84/3)*{1,1,1}, V = 23.75, f = 60)
    annotation (Placement(visible = true, transformation(extent = {{-28, -38}, {-8, -18}}, rotation = 0)));
  Electrical.Transformers.YgD01 LoadTransfo07(
    S=400,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(transformation(extent={{-58,-12},{-38,8}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        transformation(rotation=0, extent={{-8,95},{12,105}}), iconTransformation(extent=
            {{-10,89},{8,104}})));
equation
  connect(LoadTransfo07.m, Load07.positivePlug)
    annotation (Line(points={{-38,-2}, {-11, -2}, {-11, -18}}, color={0,0,255}));
  connect(p, LoadTransfo07.k)
    annotation (Line(points={{2,100}, {-80, 100}, {-80, -2}, {-58, -2}}, color={0,0,255}));
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
end Load07;
