within OpenEMTP.Electrical.Lines.CPmodel;
model TLM2 "Constant Parameter (CP) line/cable model (multiphase)"
  parameter Integer m(min = 1) = 3 "Number of phases" annotation(HideResult=true);
  parameter Real Zc[m] "Characteristic impedance{Zc1,Zc2,...,Zcm} in mode" annotation (Dialog(tab="General"),HideResult=true);
  parameter Real r[m]( each unit = "ohm/km") "{r1,r2,...,rm} in mode" annotation(HideResult=true);
  parameter SI.Length d( displayUnit="km") "length of line" annotation(HideResult=true);
  parameter SI.Time tau[m] " tau ={tau1,tau2,...,taum} in mode" annotation(HideResult=true);
  parameter Real Ti[m,m];
  //Final Paramters
  final parameter Real R[m]=r*d/1000 annotation(HideResult=false);
  final parameter Real h[m]=(Zc.-R./4)./(Zc.+R./4) annotation(HideResult=false);
  final parameter Real Zmod[m]=(Zc.+R./4) annotation(HideResult=false);
  parameter Real RN[m,m];
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Plug_k(m = m)  annotation (
    Placement(visible = true, transformation(origin = {-136, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-150, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Plug_m(m = m)  annotation (
    Placement(visible = true, transformation(origin = {136, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {148, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sensors.VoltageSensor vM1(m = m)  annotation (
    Placement(visible = true, transformation(origin = {-100, 20}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Sensors.VoltageSensor vM2(m = m)  annotation (
    Placement(visible = true, transformation(origin = {100, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.Lines.Interfaces.Norton k_end(final RN = RN, final m = m)  annotation (
    Placement(visible = true, transformation(origin = {-58, 22}, extent = {{-18, -18}, {18, 18}}, rotation = -90)));
  OpenEMTP.Electrical.Lines.Interfaces.HistoryTerm historyTerm(final Ti = Ti, final Zmod = Zmod, final h = h, final m = m, final tau = tau)  annotation (
    Placement(visible = true, transformation(origin = {2, 23}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.Interfaces.Norton m_end(final RN = RN, final m = m) annotation (
    Placement(visible = true, transformation(origin = {66, 22}, extent = {{-18, 18}, {18, -18}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.Ground ground annotation (
    Placement(visible = true, transformation(origin = {0, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Star star(m = m)  annotation (
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(historyTerm.sIh, k_end.iN) annotation (
    Line(points = {{-18, 36}, {-27.5, 36}, {-27.5, 22}, {-42, 22}}, color = {0, 0, 127}, thickness = 0.5));
  connect(k_end.plug_p, Plug_k) annotation (
    Line(points = {{-58, 40}, {-136, 40}}, color = {0, 0, 255}));
  connect(k_end.plug_n, star.plug_p) annotation (
    Line(points = {{-58, 4}, {-58, -20}, {0, -20}}, color = {0, 0, 255}));
  connect(m_end.plug_n, star.plug_p) annotation (
    Line(points = {{66, 4}, {66, -20}, {0, -20}}, color = {0, 0, 255}));
  connect(vM1.plug_p, Plug_k) annotation (
    Line(points = {{-100, 30}, {-100, 30}, {-100, 40}, {-136, 40}, {-136, 40}}, color = {0, 0, 255}));
  connect(Plug_m, m_end.plug_p) annotation (
    Line(points = {{136, 40}, {66, 40}, {66, 40}, {66, 40}}, color = {0, 0, 255}));
  connect(vM2.plug_p, Plug_m) annotation (
    Line(points = {{100, 30}, {100, 30}, {100, 40}, {136, 40}, {136, 40}}, color = {0, 0, 255}));
  connect(vM2.plug_n, star.plug_p) annotation (
    Line(points = {{100, 10}, {100, -20}, {0, -20}}, color = {0, 0, 255}));
  connect(vM1.plug_n, star.plug_p) annotation (
    Line(points = {{-100, 10}, {-100, -20}, {0, -20}}, color = {0, 0, 255}));
  connect(historyTerm.rIh, m_end.iN) annotation (
    Line(points = {{22, 36}, {30.5, 36}, {30.5, 22}, {50, 22}}, color = {0, 0, 127}, thickness = 0.5));
  connect(historyTerm.sV, vM1.v) annotation (
    Line(points = {{-18, 10}, {-20, 10}, {-20, -4}, {-80, -4}, {-80, 20}, {-88, 20}}, color = {0, 0, 127}, thickness = 0.5));
  connect(historyTerm.rV, vM2.v) annotation (
    Line(points = {{22, 10}, {20, 10}, {20, -4}, {80, -4}, {80, 20}, {90, 20}}, color = {0, 0, 127}, thickness = 0.5));
  connect(star.pin_n, ground.p) annotation (
    Line(points = {{0, -40}, {0, -40}, {0, -52}, {0, -52}}, color = {0, 0, 255}));
  annotation (
            Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "TLM", Icon(graphics = {Rectangle(origin = {-1, 0}, lineColor = {0, 0, 255}, extent = {{-119, 40}, {121, -40}}), Text(origin = {0, -67}, extent = {{-36, 15}, {36, -15}}, textString = "m=%m"), Text(origin = {-59, 84}, lineColor = {0, 0, 255}, extent = {{-61, 20}, {179, -32}}, textString = "%name"), Text(origin = {-105, 3}, extent = {{11, -13}, {-11, 13}}, textString = "+"), Line(origin = {-134.17, 1.17}, points = {{14.1708, -1.17082}, {-9.82918, -1.17082}, {-13.8292, 0.82918}}, color = {0, 0, 255}), Line(origin = {128, 0}, points = {{-8, 0}, {8, 0}}, color = {0, 0, 255})}, coordinateSystem(extent = {{-150, -110}, {150, 110}}, initialScale = 0.1)),
    uses(Modelica(version = "3.2.2")),
  Diagram(coordinateSystem(extent = {{-150, -110}, {150, 110}})),
  version = "",
  __OpenModelica_commandLineOptions = "",
  Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"));
end TLM2;
