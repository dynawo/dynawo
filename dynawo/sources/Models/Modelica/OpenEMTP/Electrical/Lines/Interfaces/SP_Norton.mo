within OpenEMTP.Electrical.Lines.Interfaces;
model SP_Norton "Norotn Equivalent of Single Phase Transmission Line CP Model"
  Modelica.Blocks.Interfaces.RealInput iN annotation (
    Placement(visible = true, transformation(origin = {-80, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  parameter Real Zmod annotation(HideResult=true);
  extends OpenEMTP.Interfaces.OnePort;
equation
  v = Zmod*(i+iN);
annotation (
    Icon(graphics = {Text(origin = {-1, 3}, extent = {{-25, -33}, {25, 33}}, textString = "Rn"), Line(origin = {-60, 29.76}, points = {{20, 30}, {-20, 30}, {-20, -30}}), Line(origin = {60, 29.76}, points = {{-20, 30}, {20, 30}, {20, -30}}), Rectangle(origin = {2, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-60, 20}, {60, -20}}), Line(origin = {-150.44, -0.48}, points = {{248, 0}, {54, 0}}), Line(origin = {0, 60}, points = {{20, 0}, {-20, 0}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 10), Polygon(origin = {0, 60}, points = {{-40, 0}, {0, 20}, {40, 0}, {0, -20}, {-40, 0}})}));
end SP_Norton;
