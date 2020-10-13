within OpenEMTP.Electrical.RLC_Branches.MultiPhase;
model L_Coupled "Ideal linear electrical multiphase coupled inductors"
  parameter SI.Inductance L[m,m] "Inductance";
  parameter SI.Current i0[m]= zeros(m)   "I0 for L " annotation (Dialog(group="Initial condition"));
  extends Modelica.Electrical.MultiPhase.Interfaces.OnePort;
initial equation
  i=i0;
equation
  v = L*der(i);
annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "L_Coupled", Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(points = {{60, 0}, {90, 0}}, color = {0, 0, 255}), Line(origin = {0.321101, -0.321101},points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(points = {{30, 0}, {31, 6}, {38, 14}, {52, 14}, {59, 6}, {60, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(points = {{-30, 0}, {-29, 6}, {-22, 14}, {-8, 14}, {-1, 6}, {0, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Text(extent = {{-150, -40}, {150, -80}}, textString = "L=%L"), Line(points = {{0, 0}, {1, 6}, {8, 14}, {22, 14}, {29, 6}, {30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(points = {{-90, 0}, {-60, 0}}, color = {0, 0, 255})}));
end L_Coupled;
