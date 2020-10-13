within OpenEMTP.Electrical.RLC_Branches;
model RL "Ideal linear electrical RL in series"
  parameter SI.Resistance R=1 "Resistance";
  parameter SI.Inductance L=1 "Inductance";
  extends OpenEMTP.Interfaces.OnePort(i(start=0, fixed=true));

equation
  v = R*i+L*der(i);
annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "RL", Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(points = {{70, 0}, {90, 0}}, color = {0, 0, 255}), Rectangle(origin = {-10, 11}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-66, 0}, {-8, -24}}), Line(points = {{-90, 0}, {-76, 0}}, color = {0, 0, 255}), Line(origin = {39.8165, 0}, points = {{-30, 0}, {-29, 6}, {-22, 14}, {-8, 14}, {-1, 6}, {0, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {69.0367, -0.1542}, points = {{-86, 0}, {-60, 0}}, color = {0, 0, 255}), Line(origin = {39.8165, 0}, points = {{0, 0}, {1, 6}, {8, 14}, {22, 14}, {29, 6}, {30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Text(extent = {{-150, -40}, {150, -80}}, textString = "%R, %L")}));
end RL;
