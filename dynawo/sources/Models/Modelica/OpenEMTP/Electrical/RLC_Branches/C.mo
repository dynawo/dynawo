within OpenEMTP.Electrical.RLC_Branches;
model C "Ideal linear electrical capacitor"
  parameter SI.Capacitance C= 1e-6 "Capacitance";
  Modelica.SIunits.ReactivePower Q "Reactive power";
  extends OpenEMTP.Interfaces.OnePort(v(start=0));

equation
  i = C*der(v);
  Q=v*i;
annotation(Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-01-06 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    defaultComponentName = "C", Icon(coordinateSystem(initialScale = 0.1), graphics={  Line(points = {{6, 28}, {6, -28}}, color = {0, 0, 255}), Line(points = {{-90, 0}, {-6, 0}}, color = {0, 0, 255}), Line(points = {{6, 0}, {90, 0}}, color = {0, 0, 255}), Text(extent = {{-150, -40}, {150, -80}}, textString = "C=%C"), Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(points = {{-6, 28}, {-6, -28}}, color = {0, 0, 255})}));
end C;
