within OpenEMTP.Electrical.Transformers;
model IdealUnit "Ideal transformer"
  extends Modelica.Electrical.Analog.Interfaces.TwoPort;
  parameter Real g "transformation ratio V2/V1";
equation
  v2 = g * v1;
  i1 = -g * i2;
  annotation (
    Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-01 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"), defaultComponentName = "IdealUnit",
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(extent = {{-150, -110}, {150, -150}}, textString = "n=%g"), Text(lineColor = {0, 0, 255}, extent = {{-100, 20}, {-60, -20}}, textString = "-gi_km"), Text(lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "g(v_i-v_j)"), Text(lineColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Line(points = {{-40, 18}, {-40, 100}, {-90, 100}}, color = {0, 0, 255}), Line(points = {{40, 18}, {40, 100}, {90, 100}}, color = {0, 0, 255}), Line(points = {{-40, -18}, {-40, -100}, {-90, -100}}, color = {0, 0, 255}), Line(points = {{40, -18}, {40, -100}, {90, -100}}, color = {0, 0, 255}), Text(origin = {-87, 82}, extent = {{-9, -6}, {9, 6}}, textString = "i"), Text(origin = {-85, -80}, extent = {{-9, -6}, {9, 6}}, textString = "j"), Text(origin = {81, -80}, extent = {{-9, -6}, {9, 6}}, textString = "m"), Text(origin = {79, 82}, extent = {{-9, -6}, {9, 6}}, textString = "k"), Ellipse(origin = {-40, 0}, lineColor = {0, 0, 255}, extent = {{-19, 18}, {19, -18}}, endAngle = 360), Line(origin = {-40, 1}, points = {{0, 13}, {0, -13}, {0, -13}}, color = {0, 0, 255}, arrow = {Arrow.None, Arrow.Filled}), Ellipse(origin = {40, 0}, lineColor = {0, 0, 255}, extent = {{-19, 18}, {19, -18}}, endAngle = 360), Text(origin = {40, 9}, lineColor = {0, 0, 255}, extent = {{-11, 11}, {11, -11}}, textString = "+"), Text(origin = {40, -9}, lineColor = {0, 0, 255}, extent = {{-11, 11}, {11, -11}}, textString = "-")}),
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-01 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"));
end IdealUnit;
