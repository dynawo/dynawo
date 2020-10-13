within OpenEMTP.Electrical.RLC_Branches.MultiPhase;
model RL_Coupled "Ideal linear electrical multiphase couples RL"
  parameter SI.Resistance R[m,m] "Resistance";
  parameter SI.Inductance L[m,m] "Inductance";
  extends Modelica.Electrical.MultiPhase.Interfaces.OnePort;
  parameter SI.Current i0[m]= zeros(m)   "I0 for L " annotation (Dialog(group="Initial condition"));
initial equation
i=i0;
equation
  v = R*i+L*der(i);
annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "RL_Coupled", Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-4, 8},lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Line(origin = {0.7156, -3.1515e-05},points = {{78, 0}, {90, 0}}, color = {0, 0, 255}), Line(origin = {18.6422, -0.321101}, points = {{30, 0}, {31, 6}, {38, 14}, {52, 14}, {59, 6}, {60, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {18, 0}, points = {{-30, 0}, {-29, 6}, {-22, 14}, {-8, 14}, {-1, 6}, {0, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {18, 0}, points = {{0, 0}, {1, 6}, {8, 14}, {22, 14}, {29, 6}, {30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-15.8894, -0.182201}, points = {{-90, 0}, {-60, 0}}, color = {0, 0, 255}), Line(origin = {33.5466, 24.6356}, points = {{-45, 0}, {45, 0}}, color = {0, 0, 255}), Line(origin = {33.911, 19.534}, points = {{-45, 0}, {45, 0}}, color = {0, 0, 255}), Rectangle(origin = {-48, 0}, lineColor = {0, 0, 255}, extent = {{28, 8}, {-28, -8}}), Line(origin = {-16, 0}, points = {{4, 0}, {-4, 0}})}));
end RL_Coupled;
