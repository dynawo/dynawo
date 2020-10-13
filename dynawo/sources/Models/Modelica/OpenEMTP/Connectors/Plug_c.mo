within OpenEMTP.Connectors;
model Plug_c
  OpenEMTP.Interfaces.MultiPhase.PositivePlug plug_p annotation (
    Placement(visible = true, transformation(origin = {-46, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-22, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {12, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {20, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  pin_p.v = plug_p.pin[3].v;
  for j in 1:3 loop
    plug_p.pin[j].i = if j == 3 then -pin_p.i else 0;
  end for;

  annotation (defaultComponentName="Plug_c", Icon(coordinateSystem(preserveAspectRatio=false, initialScale = 0.1), graphics={Line(points = {{-20, 20}, {40, 20}, {40, -20}, {-20, -20}}), Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 140, 72}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {40, -20}}), Ellipse(fillColor = {0, 140, 72}, fillPattern = FillPattern.Solid, extent = {{-40, 20}, {0, -20}}, endAngle = 360), Line(points = {{-20, 20}, {40, 20}, {40, -20}, {-20, -20}}), Text(lineColor = {0, 0, 255}, extent = {{-150, 40}, {150, 80}}, textString = "%name")}),
      Documentation(info="<html>
<p>
Connects pin <em>k</em> of plug_p to pin_p, leaving the other pins of plug_p unconnected.
</p>
</html>"));
end Plug_c;
