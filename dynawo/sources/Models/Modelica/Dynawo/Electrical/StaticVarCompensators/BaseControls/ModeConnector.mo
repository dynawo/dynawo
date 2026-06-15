within Dynawo.Electrical.StaticVarCompensators.BaseControls;
connector ModeConnector "Mode as connector"
  Mode value;

  annotation(
    preferredView = "text",
    defaultComponentName="u",
    Icon(graphics={
      Polygon(
        lineColor={0,0,127},
        fillColor={0,0,127},
        fillPattern=FillPattern.Solid,
        points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})},
      coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
        preserveAspectRatio=true,
        initialScale=0.2)),
    Diagram(
      coordinateSystem(initialScale = 0.2),
        graphics={Polygon(lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, points = {{0, 50}, {100, 0}, {0, -50}, {0, 50}}), Text(origin = {64, 0}, lineColor = {0, 0, 127}, extent = {{-10, 60}, {-10, 85}}, textString = "%name")}),
    Documentation(info="<html>
    <p>
    Connector with one input signal of type Real.
    </p>
    </html>"));
end ModeConnector;
