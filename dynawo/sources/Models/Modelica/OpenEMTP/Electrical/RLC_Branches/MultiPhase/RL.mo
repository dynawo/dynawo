within OpenEMTP.Electrical.RLC_Branches.MultiPhase;
model RL "Ideal linear electrical multiphase series RL"
  parameter SI.Resistance R[m]=fill(1,m) "Resistance";
  parameter SI.Inductance L[m]=fill(1,m) "Inductance";
  parameter SI.Current i0[m]= zeros(m)   "I0 for L " annotation (Dialog(group="Initial condition"));
  extends Modelica.Electrical.MultiPhase.Interfaces.OnePort;
initial equation
  i=i0;
equation
  v=R.*i+L.*der(i);
annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "RL", Icon(graphics = {Line(origin = {18, 0}, points = {{0, 0}, {1, 6}, {8, 14}, {22, 14}, {29, 6}, {30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {18, 0}, points = {{-30, 0}, {-29, 6}, {-22, 14}, {-8, 14}, {-1, 6}, {0, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-16, 0}, points = {{4, 0}, {-4, 0}}), Text(origin = {-4, 8}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(origin = {18.6422, -0.321101}, points = {{30, 0}, {31, 6}, {38, 14}, {52, 14}, {59, 6}, {60, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Rectangle(origin = {-48, 0}, lineColor = {0, 0, 255}, extent = {{28, 8}, {-28, -8}}), Line(origin = {-85.21, -1.21}, points = {{9.20711, 1.20711}, {-6.79289, 1.20711}, {-8.79289, -0.792893}}, color = {0, 0, 255}), Line(origin = {84, 0}, points = {{-6, 0}, {6, 0}}, color = {0, 0, 255})}));
end RL;
