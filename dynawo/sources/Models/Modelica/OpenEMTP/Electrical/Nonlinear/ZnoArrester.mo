within OpenEMTP.Electrical.Nonlinear;

model ZnoArrester
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  parameter Real Vref=516000;
  //Exponential segments before flashover
  parameter Real T[:, 3] = [0.163113059479073E+02, 0.240279296219978E+02, 0.667857269772541E+00; 0.134112947529269E+02, 0.266219333383985E+02, 0.107838745800672E+01; 0.383838137212802E+02, 0.200870413085749E+02, 0.117458089341624E+01; 0.115443146532003E+01, 0.352906710089203E+02, 0.125919561101624E+01; 0.407093229412981E+03, 0.111310570543275E+02, 0.127478619617635E+01; 0.256681175704043E+04, 0.536270125014350E+01, 0.137605475880033E+01] "multiplier p, Exponent q, Vmin_pu";
  Real P(unit="W")"power";
  Real e(unit="J")"energy";
protected
  final parameter Real[:] p_vec = T[:, 1];
  final parameter Real[:] q_vec = T[:, 2];
  final parameter Real[:] V_vec = T[:, 3]*Vref;
equation
  i=OpenEMTP.NonElectrical.Functions.ExponentialInterpolate(V_vec, p_vec,q_vec,Vref,v);
  P=v*i;
  der(e)=P;
annotation(Documentation(info= "<html><head></head><body><p>The enonlinear inductance reprsented by a polynominal:</p><p>i=a*flux+b*flux^c</p><p>the magnetizing current and the core
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
</body></html>"),
    defaultComponentName = "Zno", Icon(graphics = {Rectangle(origin = {9, 0}, lineColor = {0, 0, 255}, extent = {{-69, 16}, {51, -16}}), Text(origin = {0, 1}, extent = {{-48, 17}, {48, -17}}, textString = "ZnO"), Line(origin = {-29.8, 27.8}, points = {{-10.1963, 12.1963}, {-10.1963, 2.19635}, {9.80365, -11.8037}, {9.80365, -11.8037}}, color = {0, 0, 255}), Line(origin = {28.81, -24.81}, points = {{-8.80662, 8.80662}, {11.1934, -5.19338}, {11.1934, -9.19338}, {11.1934, -15.1934}}, color = {0, 0, 255}), Line(origin = {-75, 0}, points = {{15, 0}, {-15, 0}}, color = {0, 0, 255}), Line(origin = {75.2181, -0.26351}, points = {{15, 0}, {-15, 0}}, color = {0, 0, 255}), Text(origin = {-2, 12},lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><p>The enonlinear inductance reprsented by a polynominal:</p><p>i=a*flux+b*flux^c</p><p>the magnetizing current and the core
linkage flux, respectively. In addition, constant coefficients a
and b respectively impact the linear and saturated regions of
the core magnetization characteristic. The curvature of the
characteristic in saturation region is mainly deduced based on
constant exponent n.</p><!--StartFragment-->&nbsp;<br><!--EndFragment-->
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-09-25 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"));
end ZnoArrester;
