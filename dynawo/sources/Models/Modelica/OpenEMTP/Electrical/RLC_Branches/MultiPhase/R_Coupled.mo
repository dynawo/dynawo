within OpenEMTP.Electrical.RLC_Branches.MultiPhase;
model R_Coupled "Ideal linear electrical multiphase coupled resistors"
  parameter SI.Resistance R[m,m] "Resistance";
  extends Modelica.Electrical.MultiPhase.Interfaces.OnePort;
equation
  v = R*i;
annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "R_Coupled", Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-4, 16}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(extent = {{-150, -40}, {150, -80}}, textString = "R=%R"), Line(points = {{70, 0}, {90, 0}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 30}, {70, -30}}), Line(points = {{-90, 0}, {-70, 0}}, color = {0, 0, 255}), Line(origin = {-3, 49.4026}, points = {{-67, -0.321101}, {67, -0.321101}, {67, -0.321101}}, color = {0, 0, 255}), Line(origin = {-2.3945, 41.054}, points = {{-67, -0.321101}, {67, -0.321101}, {67, -0.321101}}, color = {0, 0, 255})}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end R_Coupled;
