within OpenEMTP.Electrical.Lines.Interfaces;
model Norton "calculation of Norton Equivalent for CP model"
  extends Modelica.Electrical.MultiPhase.Interfaces.TwoPlug;
  parameter Real RN[m,m]=RN "RN" annotation(HideResult=true);
  Modelica.Blocks.Interfaces.RealInput iN[m] annotation (
    Placement(visible = true, transformation(origin = {-80, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  v = RN*(i+iN);
  plug_p.pin.i + plug_n.pin.i = zeros(m);

annotation (
    Icon(graphics = {Polygon(origin = {0, 60}, points = {{-40, 0}, {0, 20}, {40, 0}, {0, -20}, {-40, 0}}), Line(origin = {0, 60}, points = {{20, 0}, {-20, 0}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 10), Line(origin = {-60, 29.76}, points = {{20, 30}, {-20, 30}, {-20, -30}}), Line(origin = {60, 29.76}, points = {{-20, 30}, {20, 30}, {20, -30}}), Line(origin = {-150.44, -0.48}, points = {{248, 0}, {54, 0}}), Rectangle(origin = {2, 0},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-60, 20}, {60, -20}}), Text(origin = {-1, 3}, extent = {{-25, -33}, {25, 33}}, textString = "Rn")}, coordinateSystem(initialScale = 0.1)));
end Norton;
