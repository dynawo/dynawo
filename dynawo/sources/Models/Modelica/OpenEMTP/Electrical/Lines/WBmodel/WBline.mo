within OpenEMTP.Electrical.Lines.WBmodel;
model WBline
  parameter Integer m( final min=1) = 3  "Number of phases" annotation(HideResult=true);
  parameter Real G0[:,:] "G0 is a constant matrixi_fitting Yc" annotation(HideResult=true);
  parameter Real G[:,:,:]
                         "Zeros of fitting Yc" annotation(HideResult=true);
  parameter Real q[:] "poles of fitting Yc" annotation(HideResult=true);
  parameter Real tau[:]
                       "propagation time" annotation(HideResult=true);
  parameter Complex Pm_H[:,:] "poles of fitting H";
  parameter Complex Rm_H[:,:,:,:] "zeros of fitting H";
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pk(m = m) annotation (
    Placement(visible = true, transformation(origin = {-178, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-150, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pm(m = m) annotation (
    Placement(visible = true, transformation(origin = {176, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {172, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sensors.CurrentSensor ik(m = m) annotation (
    Placement(visible = true, transformation(origin = {-156, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sensors.CurrentSensor im(m = m) annotation (
    Placement(visible = true, transformation(origin = {150, 40}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Star star1(m = m) annotation (
    Placement(visible = true, transformation(origin = {0, -58}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation (
    Placement(visible = true, transformation(origin = {0, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HistoryTerm historyTerm1(final Pm_H = Pm_H, final Rm_H = Rm_H, final m = m, final tau = tau)  annotation (
    Placement(visible = true, transformation(origin = {2, 64}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  AdmittanceConvolution admittanceConvolution_k(final G = G, final G0 = G0, final m = m, final q = q)  annotation (
    Placement(visible = true, transformation(origin = {-61, -1}, extent = {{-33, -33}, {33, 33}}, rotation = -90)));
  AdmittanceConvolution admittanceConvolution_m(final G = G, final G0 = G0, final m = m, final q = q)  annotation (
    Placement(visible = true, transformation(origin = {63, -1}, extent = {{33, -33}, {-33, 33}}, rotation = 90)));
equation
  connect(historyTerm1.im, im.i) annotation (
    Line(points={{27.2,82},{150,82},{150,51}},      color = {0, 0, 127}, thickness = 0.5));
  connect(historyTerm1.ik, ik.i) annotation (
    Line(points={{-22.9,82},{-156,82},{-156,51}},      color = {0, 0, 127}, thickness = 0.5));
  connect(im.plug_n, admittanceConvolution_m.plug_p) annotation (
    Line(points={{140,40},{64,40},{64,32},{63,32}},          color = {0, 0, 255}));
  connect(ik.plug_n, admittanceConvolution_k.plug_p) annotation (
    Line(points={{-146,40},{-60,40},{-60,32},{-61,32}},          color = {0, 0, 255}));
  connect(admittanceConvolution_m.plug_n, star1.plug_p) annotation (
    Line(points={{63,-34},{62,-34},{62,-48},{0,-48},{0,-48}},            color = {0, 0, 255}));
  connect(admittanceConvolution_k.plug_n, star1.plug_p) annotation (
    Line(points={{-61,-34},{-60,-34},{-60,-48},{0,-48},{0,-48}},            color = {0, 0, 255}));
  connect(star1.pin_n, ground1.p) annotation (
    Line(points = {{0, -68}, {0, -68}, {0, -74}, {0, -74}}, color = {0, 0, 255}));
  connect(Pm, im.plug_p) annotation (
    Line(points = {{176, 40}, {160, 40}}, color = {0, 0, 255}));
  connect(ik.plug_p, Pk) annotation (
    Line(points = {{-166, 40}, {-171, 40}, {-171, 40}, {-176, 40}, {-176, 40}, {-178, 40}}, color = {0, 0, 255}));
  connect(historyTerm1.i_ki, admittanceConvolution_k.i_i) annotation (Line(points={{-9.4,
          44.2},{-9.4,0},{-32.29,0},{-32.29,-1}}, color={0,0,127}));
  connect(historyTerm1.i_mi, admittanceConvolution_m.i_i)
    annotation (Line(points={{12.2,44.2},{12.2,-1},{34.29,-1}}, color={0,0,127}));
  annotation (
            Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-07-15 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),uses(Modelica(version = "3.2.3")),defaultComponentName = "WBline",
    Icon(graphics={Rectangle(lineColor = {0, 0, 255}, extent = {{-120, 40}, {140, -40}}), Text(origin = {-68, 64}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Line(origin = {-129.853, -0.321101}, points = {{-9, 0}, {9, 0}, {11, 0}}, color = {0, 0, 255}), Line(origin = {147.101, 0.321101}, points = {{-6, 0}, {14, 0}}, color = {0, 0, 255}), Text(origin = {-106, 3}, lineColor = {0, 0, 255}, extent = {{-24, 21}, {24, -21}}, textString = "+"), Text(origin = {10, -58}, extent = {{-46, 20}, {46, -20}}, textString = "m=%m"), Text(origin = {6, 6}, extent = {{-44, 26}, {44, -26}}, textString = "WB")}, coordinateSystem(extent = {{-200, -100}, {200, 100}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    version = "",
    __OpenModelica_commandLineOptions = "");
end WBline;
