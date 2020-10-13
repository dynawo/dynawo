within OpenEMTP.Connectors;

model SP_Bus
  OpenEMTP.Interfaces.Pin pin annotation(
    Placement(visible = true, transformation(origin = {-92, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Interfaces.Pin pin1 annotation(
    Placement(visible = true, transformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(pin, pin1) annotation(
    Line(points = {{-92, 2}, {88, 2}, {88, 0}, {92, 0}}, color = {0, 0, 255}));
  annotation (
    uses(Modelica(version = "3.2.3")),
    defaultComponentName = "Bus",
    Icon(graphics={  Rectangle(pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-10, 100}, {10, -100}}), Text(origin = {128, -100}, rotation = 90, lineColor = {0, 0, 255}, extent = {{-150, 40}, {150, 80}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));

end SP_Bus;
