within OpenEMTP.Electrical.RLC_Branches.MultiPhase;
model C "Ideal linear electrical multiphase capacitor"
  parameter SI.Capacitance C[m]=fill(1, m)
                                          "Capacitance";
  parameter SI.Voltage v0[m]= zeros(m) "V0 for C" annotation (Dialog(group="Initial condition"));
  extends OpenEMTP.Interfaces.MultiPhase.OnePort;
initial equation
  v=v0;
equation
  i = C.*der(v);
annotation (
        Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "C", Icon(coordinateSystem(initialScale = 0.1), graphics={  Line(points = {{6, 28}, {6, -28}}, color = {0, 0, 255}), Line(points = {{-90, 0}, {-6, 0}}, color = {0, 0, 255}), Line(points = {{6, 0}, {90, 0}}, color = {0, 0, 255}), Text(extent = {{-150, -40}, {150, -80}}, textString = "C=%C"), Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(points = {{-6, 28}, {-6, -28}}, color = {0, 0, 255})}));
end C;
