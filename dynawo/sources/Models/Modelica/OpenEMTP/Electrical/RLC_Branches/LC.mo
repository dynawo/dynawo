within OpenEMTP.Electrical.RLC_Branches;
model LC "Ideal linear electrical LC in series"
  parameter SI.Inductance L(start=1) "Inductance";
  parameter SI.Capacitance C(start=1) "Capacitance";
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  parameter SI.Current i0= 0 "I0 for L" annotation (Dialog(group="Initial condition"));
  parameter SI.Voltage v0= 0 "V0 for C" annotation (Dialog(group="Initial condition"));
protected
  Real v1;
  Real v2;
initial equation
  v2=v0;
  i=i0;
equation
  v1=L*der(i);
  i=C*der(v2);
  v =v1+v2;
annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "LC", Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(points = {{60, 0}, {90, 0}}, color = {0, 0, 255}), Line(origin = {-13.8073, -0.642202}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-14.1284, -0.321101}, points = {{-30, 0}, {-29, 6}, {-22, 14}, {-8, 14}, {-1, 6}, {0, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Text(extent = {{-150, -40}, {150, -80}}, textString = "%L, %C"), Line(origin = {-14.1284, -0.321101}, points = {{0, 0}, {1, 6}, {8, 14}, {22, 14}, {29, 6}, {30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(points = {{-90, 0}, {-74, 0}}, color = {0, 0, 255}), Line(origin = {53.6239, 1.2844}, points = {{-6, 28}, {-6, -28}}, color = {0, 0, 255}), Line(origin = {53.6239, 1.2844}, points = {{6, 28}, {6, -28}}, color = {0, 0, 255}), Line(origin = {106.081, -0.0679608},points = {{-90, 0}, {-60, 0}}, color = {0, 0, 255})}));
end LC;
