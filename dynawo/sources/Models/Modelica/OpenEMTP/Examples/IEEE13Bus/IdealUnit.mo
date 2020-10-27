within OpenEMTP.Examples.IEEE13Bus;
model IdealUnit "Ideal Single Phase Transformer"
  parameter Real n(start=1) "Turns ratio secondary:primary voltage";
  Modelica.Electrical.Analog.Interfaces.Pin Pin_i annotation (
    Placement(visible = true, transformation(origin = {-100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin Pin_j annotation (
    Placement(visible = true, transformation(origin = {-96, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin Pin_k annotation (
    Placement(visible = true, transformation(origin = {100, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin Pin_m annotation (
    Placement(visible = true, transformation(origin = {100, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
Pin_k.v-Pin_m.v-n*Pin_i.v+n*Pin_j.v=0;
Pin_i.i=-n*Pin_k.i;
Pin_i.i=Pin_j.i;
Pin_k.i=Pin_m.i;

   annotation (
    defaultComponentName = "transformer",
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Text(extent = {{-150, -110}, {150, -150}}, textString = "n=%n"), Text(lineColor = {0, 0, 255}, extent = {{-100, 20}, {-60, -20}}, textString = "1"), Text(lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "2"), Text(lineColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Line(points = {{-40, 60}, {-40, 100}, {-90, 100}}, color = {0, 0, 255}), Line(points = {{40, 60}, {40, 100}, {90, 100}}, color = {0, 0, 255}), Line(points = {{-40, -60}, {-40, -100}, {-90, -100}}, color = {0, 0, 255}), Line(points = {{40, -60}, {40, -100}, {90, -100}}, color = {0, 0, 255}), Line(origin = {-33, 45}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, 15}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, -15}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, -45}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, 45}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, 15}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, -15}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, -45}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier)}),
    uses(Modelica(version = "3.2.3")));
end IdealUnit;
