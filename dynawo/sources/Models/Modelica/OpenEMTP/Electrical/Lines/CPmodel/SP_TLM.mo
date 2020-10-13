within OpenEMTP.Electrical.Lines.CPmodel;
model SP_TLM "Single Phase Transmission Line CP Model"

  parameter Real Zc "Characteristic impedance" annotation (HideResult=true, Dialog(tab="General"));
  parameter Real r(  unit = "ohm/km") annotation(HideResult=true);
  parameter SI.Length d( displayUnit="km") "length of line" annotation(HideResult=true);
  parameter SI.Time tau "Delay" annotation(HideResult=true);
  //Final Paramters
  final parameter Real R = r * d/1000 annotation(HideResult=true);
  final parameter Real h=(Zc-R/4)/(Zc+R/4) annotation(HideResult=true);
  final parameter Real Zmod=(Zc+R/4) annotation(HideResult=true);
  OpenEMTP.Interfaces.PositivePin pin_k annotation (
    Placement(visible = true, transformation(origin = {-96, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-150, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Interfaces.PositivePin pin_m annotation (
    Placement(visible = true, transformation(origin = {96, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {144, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.Interfaces.SP_Norton sP_Norton_k(final Zmod = Zmod)  annotation (
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  OpenEMTP.Electrical.Lines.Interfaces.SP_Norton sP_Norton_m(final Zmod = Zmod)  annotation (
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-20, 20}, {20, -20}}, rotation = -90)));
  OpenEMTP.Electrical.Lines.Interfaces.SP_HistoryTerm sP_HistoryTerm(Zmod = Zmod, h = h, tau = tau)  annotation (
    Placement(visible = true, transformation(origin = {8.88178e-16, -2.66454e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor Vk annotation (
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor Vm annotation (
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground ground annotation (
    Placement(visible = true, transformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Vk.v, sP_HistoryTerm.sV) annotation (
    Line(points={{-91,0},{-94,0},{-94,-40},{-32,-40},{-32,-14.2},{-22,-14.2}},          color = {0, 0, 127}));
  connect(Vm.v, sP_HistoryTerm.rV) annotation (
    Line(points={{91,0},{96,0},{96,-40},{32,-40},{32,-14},{22,-14},{22,-14}},                color = {0, 0, 127}));
  connect(sP_HistoryTerm.sIh, sP_Norton_k.iN) annotation (
    Line(points = {{-22, 14}, {-32, 14}, {-32, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(sP_HistoryTerm.rIh, sP_Norton_m.iN) annotation (
    Line(points={{22,14.4},{30,14.4},{30,0},{42,0},{42,0}},        color = {0, 0, 127}));
  connect(sP_Norton_k.p, pin_k) annotation (
    Line(points = {{-60, 20}, {-96, 20}}, color = {0, 0, 255}));
  connect(sP_Norton_m.p, pin_m) annotation (
    Line(points = {{60, 20}, {94, 20}, {94, 22}, {96, 22}}, color = {0, 0, 255}));
  connect(sP_Norton_k.n, Vk.n) annotation (
    Line(points = {{-60, -20}, {-80, -20}, {-80, -10}}, color = {0, 0, 255}));
  connect(Vk.p, pin_k) annotation (
    Line(points = {{-80, 10}, {-80, 10}, {-80, 20}, {-96, 20}, {-96, 20}}, color = {0, 0, 255}));
  connect(sP_Norton_k.n, ground.p) annotation (
    Line(points = {{-60, -20}, {-60, -56}, {0, -56}}, color = {0, 0, 255}));
  connect(sP_Norton_m.n, ground.p) annotation (
    Line(points = {{60, -20}, {60, -20}, {60, -56}, {0, -56}, {0, -56}}, color = {0, 0, 255}));
  connect(Vm.n, sP_Norton_m.n) annotation (
    Line(points = {{80, -10}, {80, -10}, {80, -20}, {62, -20}, {62, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(Vm.p, pin_m) annotation (
    Line(points = {{80, 10}, {80, 10}, {80, 20}, {96, 20}, {96, 22}}, color = {0, 0, 255}));
annotation (   Documentation(info="<html>
<p><b><span style=\"font-size: 12pt;\"><a name=\"f3-2394832\">D</a><span style=\"color: #404040; background-color: #ffffff;\">escription</span></b></p>
<p><br><span style=\"font-family: Arial,Helvetica,sans-serif; color: #404040; background-color: #ffffff;\">The model is based on the Bergeron&apos;s traveling wave method used by the Electromagnetic Transient Program (EMTP). In this model, the lossless distributed LC line is characterized by two values (for a single-phase line): the surge impedance&nbsp;</span></span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">Zc <span style=\"font-family: Arial;\">and the wave propagation speed&nbsp;<i>tau</i>.&nbsp;<i>l</i>&nbsp;and&nbsp;<i>c</i>&nbsp;are the per-unit length inductance and capacitance.</span></p>
<p><br><img src=\"y:/ProfileS/DESktop/OpenEMTP/Images/Line.JPG\"/></p>
<p><i><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif; color: #404040; background-color: #ffffff;\">r</span></i></span><span style=\"font-family: Arial,Helvetica,sans-serif;\">,&nbsp;<span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">l</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">,&nbsp;</span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">c</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">&nbsp;are the per unit length parameters, and&nbsp;</span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">d</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">&nbsp;is the line length. For a lossless line,&nbsp;<i>r</i>&nbsp;= 0,&nbsp;<i>h</i>&nbsp;= 1, and&nbsp;<i>Z</i>&nbsp;=&nbsp;<i>Zc, R</i>&nbsp;= total resistance =&nbsp;<i>r</i>&nbsp;&times;&nbsp;<i>d.</span></i></p>
<p><b><span style=\"font-size: 12pt;\"><a name=\"f3-2394974\">R</a><span style=\"color: #404040; background-color: #ffffff;\">eferences</span></b></p>
<p><span style=\"font-family: Arial,Helvetica,sans-serif; color: #404040;\">  Dommel, H., &ldquo;Digital Computer Solution of Electromagnetic Transients in Single and Multiple Networks,&rdquo;<i>&nbsp;IEEE&reg;&nbsp;Transactions on Power Apparatus and Systems</i>, Vol. PAS-88, No. 4, April, 1969.</span></p>
</html>",        revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-24 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "TLM", Icon(graphics={  Line(origin = {128, 0}, points = {{-8, 0}, {8, 0}}, color = {0, 0, 255}), Text(origin = {-105, 1}, extent = {{11, -13}, {-11, 13}}, textString = "+"), Rectangle(origin = {-1, 0}, lineColor = {0, 0, 255}, extent = {{-119, 40}, {121, -40}}), Text(origin = {-59, 84}, lineColor = {0, 0, 255}, extent = {{-61, 20}, {179, -32}}, textString = "%name"), Line(origin = {-134.17, 1.17}, points = {{14.1708, -1.17082}, {-9.82918, -1.17082}, {-13.8292, 0.82918}}, color = {0, 0, 255}), Text(origin = {-9, 5}, extent = {{-43, 17}, {61, -25}}, textString = "single phase CP model")}, coordinateSystem(extent = {{-150, -110}, {150, 110}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -110}, {150, 110}})));
end SP_TLM;
