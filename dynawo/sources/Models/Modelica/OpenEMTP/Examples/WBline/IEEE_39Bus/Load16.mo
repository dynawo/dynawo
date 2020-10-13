within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load16
  Electrical.Load_Models.PQ_Load Load16(P=(329/3)*{1,1,1}, Q=(32.3/3)*{1,1,1}, V = 25.25, f = 60)
    annotation (Placement(transformation(extent={{0,72},{20,92}})));
  Electrical.Transformers.YgD01 LoadTransfo16(
    S=500,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(transformation(extent={{-32,100},{-12,120}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        transformation(rotation=0, extent={{-10,186},{10,206}}), iconTransformation(
          extent={{-10,186},{10,206}})));
equation
  connect(LoadTransfo16.m, Load16.positivePlug)
    annotation (Line(points={{-12,110},{16.8,110},{16.8,92}}, color={0,0,255}));
  connect(p, LoadTransfo16.k)
    annotation (Line(points={{0,196},{-66,196},{-66,110},{-32,110}}, color={0,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,0},{100,200}})), Icon(
        coordinateSystem(extent={{-100,0},{100,200}}), graphics={
        Line(points={{0,188},{0,120},{0,120}}, color={0,0,255}),
        Line(points={{-80,120},{16,120},{80,120}}, color={0,0,255}),
        Polygon(
          points={{-60,70},{-20,70},{-40,50},{-60,70}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,52},{-4,-12}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Polygon(
          points={{18,70},{58,70},{38,50},{18,70}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{6,52},{74,-12}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Q"),
        Line(points={{-40,120},{-40,74},{-40,70},{-42,70},{-40,70}}, color={0,0,255}),
        Line(points={{40,120},{40,70}}, color={0,0,255}),
        Text(
          extent={{-134,-12},{90,-90}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Load16;
