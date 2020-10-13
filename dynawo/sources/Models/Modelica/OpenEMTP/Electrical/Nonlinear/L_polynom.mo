within OpenEMTP.Electrical.Nonlinear;

model L_polynom
  parameter Real a=0.001;
  parameter Real b=0.01;
  parameter Real c=25;
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  Modelica.SIunits.MagneticFlux flux( start=0,fixed=true);
equation
  i=a*flux+b*flux^c;
  v = der(flux);
  annotation (        Documentation(info= "<html><head></head><body><p>The enonlinear inductance reprsented by a polynominal:</p><p>i=a*flux+b*flux^c</p><p>the magnetizing current and the core
linkage flux, respectively. In addition, constant coefficients a
and b respectively impact the linear and saturated regions of
the core magnetization characteristic. The curvature of the
characteristic in saturation region is mainly deduced based on
constant exponent n.</p><!--StartFragment-->&nbsp;<br><!--EndFragment-->
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-08-01 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "L_Nonlinear", Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(points = {{60, 0}, {90, 0}}, color = {0, 0, 255}), Line(origin = {0.321101, -0.321101}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(points = {{30, 0}, {31, 6}, {38, 14}, {52, 14}, {59, 6}, {60, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(points = {{-30, 0}, {-29, 6}, {-22, 14}, {-8, 14}, {-1, 6}, {0, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Text(extent = {{-150, -40}, {150, -80}}, textString = "L=%L"), Line(points = {{0, 0}, {1, 6}, {8, 14}, {22, 14}, {29, 6}, {30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(points = {{-90, 0}, {-60, 0}}, color = {0, 0, 255})}));
end L_polynom;
