within OpenEMTP.Examples.WBline.IEEE_39Bus;
model Load18
  OpenEMTP.Electrical.Load_Models.PQ_Load Load18(P=(158/3)*{1,1,1}, Q=(30/3)*{1,1,1}, V = 25.25, f = 60)
    annotation (Placement(visible = true, transformation(extent = {{66, -6}, {86, 14}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.YgD01 LoadTransfo18(
    S=400,
    f=60,
    v1=345,
    v2=25,
    R=0.002,
    X=0.100,
    D=0.5,
    MD=[0.001,1; 0.01,1.075; 0.025,1.15; 0.05,1.2; 0.1,1.23; 0.5,1.37; 1,1.55; 2,1.86],
    Rmg=500) annotation (Placement(visible = true, transformation(extent = {{32, 36}, {52, 56}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (Placement(
        visible = true,transformation( extent={{-10, 93}, {10, 103}},rotation=0), iconTransformation(extent = {{-8, 90}, {10, 106}}, rotation = 0)));
equation
  connect(p, LoadTransfo18.k) annotation (
    Line(points = {{0, 98}, {0, 98}, {0, 46}, {32, 46}, {32, 46}}, color = {0, 0, 255}));
  connect(LoadTransfo18.m, Load18.positivePlug) annotation (
    Line(points = {{52, 46}, {83, 46}, {83, 14}}, color = {0, 0, 255}));
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
end Load18;
