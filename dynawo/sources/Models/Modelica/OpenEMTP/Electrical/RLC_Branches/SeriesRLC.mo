within OpenEMTP.Electrical.RLC_Branches;
model SeriesRLC "Ideal linear electrical RLC in series"
  parameter SI.Resistance  R = 1 "Resistance";
  parameter SI.Inductance  L = 1 "Inductance";
  parameter SI.Capacitance C= 1 "Capacitance";
  parameter SI.Current i0= 0 "I0 for L" annotation (Dialog(group="Initial condition"));
  parameter SI.Voltage v0= 0 "V0 for C" annotation (Dialog(group="Initial condition"));
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
protected
  Real v1,v2,v3;
initial equation
  v3=v0;
  i=i0;
equation
  v1=R*i;
  v2=L*der(i);
  i=C*der(v3);
  v =v1+v2+v3;
annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "RLC", Icon(graphics = {Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(origin = {-0.24227, -2.81028e-05},points = {{80, 0}, {90, 0}}, color = {0, 0, 255}), Line(origin = {22.156, -0.321101}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {21.8349, -9.24145e-08}, points = {{-30, 0}, {-29, 6}, {-22, 14}, {-8, 14}, {-1, 6}, {0, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Text(extent = {{-150, -40}, {150, -80}}, textString = "%R, %L, %C"), Line(origin = {21.8349, -9.24145e-08}, points = {{0, 0}, {1, 6}, {8, 14}, {22, 14}, {29, 6}, {30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(points = {{-90, 0}, {-74, 0}}, color = {0, 0, 255}), Line(origin = {73.6239, 1.2844}, points = {{-6, 28}, {-6, -28}}, color = {0, 0, 255}), Line(origin = {74.2661, 1.6055}, points = {{6, 28}, {6, -28}}, color = {0, 0, 255}), Line(origin = {142.391, 0.0215556}, points = {{-90, 0}, {-76, 0}}, color = {0, 0, 255}), Rectangle(origin = {-10, -22},lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 30}, {-40, 14}}), Line(origin = {40.3781, 0.0215556}, points = {{-90, 0}, {-78, 0}}, color = {0, 0, 255})}),
    Diagram);
end SeriesRLC;
