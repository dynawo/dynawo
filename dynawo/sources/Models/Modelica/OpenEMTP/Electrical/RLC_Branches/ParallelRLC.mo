within OpenEMTP.Electrical.RLC_Branches;
model ParallelRLC "Ideal linear electrical RLC in parallel"
  parameter SI.Resistance  R = 1 "Resistance";
  parameter SI.Inductance  L = 1 "Inductance";
  parameter SI.Capacitance C= 1 "Capacitance";
  parameter SI.Current i0= 0 "I0 for L" annotation (Dialog(group="Initial condition"));
  parameter SI.Voltage v0= 0 "V0 for C" annotation (Dialog(group="Initial condition"));
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
protected
  Real i1,i2,i3;
initial equation
  v=v0;
  i2=i0;
equation
  v=R*i1;
  v=L*der(i2);
  i3=C*der(v);
  i =i1+i2+i3;
annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-31 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "RLC", Icon(graphics = {Text(origin = {-10, 28}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(origin = {-0.24227, -2.81028e-05}, points = {{58, 0}, {90, 0}}, color = {0, 0, 255}), Line(origin = {14.4556, -0.392558}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {14.1345, -0.0714579}, points = {{-30, 0}, {-29, 6}, {-22, 14}, {-8, 14}, {-1, 6}, {0, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Text(origin = {-2, -42}, extent = {{-150, -40}, {150, -80}}, textString = "%R, %L, %C"), Line(origin = {14.1345, -0.0714579}, points = {{0, 0}, {1, 6}, {8, 14}, {22, 14}, {29, 6}, {30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-0.315005, -47.6706}, points = {{-6, 28}, {-6, -28}}, color = {0, 0, 255}), Line(origin = {0.327191, -47.3495}, points = {{6, 28}, {6, -28}}, color = {0, 0, 255}), Line(origin = {134.69, -0.0499019}, points = {{-90, 0}, {-76, 0}}, color = {0, 0, 255}), Rectangle(origin = {22, 30}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 30}, {28, 10}}), Line(origin = {32.6777, -0.0499019}, points = {{-122, 0}, {-78, 0}}, color = {0, 0, 255}), Line(origin = {-48, -25}, points = {{-42, 25}, {-42, -25}, {42, -25}, {42, -25}}, color = {0, 0, 255}), Line(origin = {48, -30}, points = {{-42, -20}, {42, -20}, {42, 20}, {42, 20}}, color = {0, 0, 255}), Line(origin = {-90, 30}, points = {{0, -20}, {0, 20}}, color = {0, 0, 255}), Line(origin = {89.7354, 29.8465}, points = {{0, -20}, {0, 20}}, color = {0, 0, 255}), Line(origin = {-69.5, 50}, points = {{-20.5, 0}, {21.5, 0}, {19.5, 0}}, color = {0, 0, 255}), Line(origin = {70, 50}, points = {{-20, 0}, {20, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.1)),
    Diagram);
end ParallelRLC;
