within OpenEMTP.Electrical.RLC_Branches.MultiPhase;
model R "Ideal linear electrical multiphase resistor"
  parameter SI.Resistance R[m]=fill(1, m) "Resistance";
  extends OpenEMTP.Interfaces.MultiPhase.OnePort;
equation
  v = R.*i;
annotation(Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-01-06 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    defaultComponentName = "R", Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(extent = {{-150, -40}, {150, -80}}, textString = "R=%R"), Line(points = {{70, 0}, {90, 0}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 30}, {70, -30}}), Line(points = {{-90, 0}, {-70, 0}}, color = {0, 0, 255})}));
end R;
