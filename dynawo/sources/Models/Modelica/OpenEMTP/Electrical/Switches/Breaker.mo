within OpenEMTP.Electrical.Switches;
model Breaker "Three phase Ideal Breaker"

  parameter SI.Time Tclosing[3]={0,0,0}       "Closing Time {t1,t2,t3}";
  parameter SI.Time Topening[3]={0.1,0.1,0.1} "Opening Time {t1,t2,t3}";
  OpenEMTP.Electrical.Switches.IdealSwitch SW_a(Tclosing = Tclosing[1], Topening = Topening[1])  annotation (
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch SW_b(Tclosing = Tclosing[2], Topening = Topening[2])  annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch SW_c(Tclosing = Tclosing[3], Topening = Topening[3])  annotation (
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_a(k = 1)  annotation (
    Placement(visible = true, transformation(origin = {-56, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_b(k = 2) annotation (
    Placement(visible = true, transformation(origin = {-56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_c(k = 3) annotation (
    Placement(visible = true, transformation(origin = {-56, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_n plugToPin_A(k = 1)  annotation (
    Placement(visible = true, transformation(origin = {44, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_n plugToPin_B(k = 2)  annotation (
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_n plugToPin_C(k = 3)  annotation (
    Placement(visible = true, transformation(origin = {44, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation (
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.NegativePlug m annotation (
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(plugToPin_a.plug_p, k) annotation (
    Line(points = {{-58, 60}, {-100, 60}, {-100, 0}, {-100, 0}}, color = {238, 46, 47}));
  connect(plugToPin_b.plug_p, k) annotation (
    Line(points = {{-58, 0}, {-98, 0}, {-98, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(plugToPin_c.plug_p, k) annotation (
    Line(points = {{-58, -80}, {-100, -80}, {-100, 0}}, color = {0, 140, 72}));
  connect(plugToPin_a.pin_p, SW_a.pin_p) annotation (
    Line(points = {{-54, 60}, {-12, 60}, {-12, 60}, {-10, 60}}, color = {238, 46, 47}));
  connect(plugToPin_b.pin_p, SW_b.pin_p) annotation (
    Line(points = {{-54, 0}, {-12, 0}, {-12, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(SW_c.pin_p, plugToPin_c.pin_p) annotation (
    Line(points = {{-10, -80}, {-56, -80}, {-56, -80}, {-54, -80}}, color = {0, 140, 72}));
  connect(plugToPin_A.plug_n, m) annotation (
    Line(points = {{46, 60}, {100, 60}, {100, 0}, {100, 0}}, color = {238, 46, 47}, thickness = 0.5));
  connect(m, plugToPin_B.plug_n) annotation (
    Line(points = {{100, 0}, {46, 0}, {46, 0}, {46, 0}}, color = {0, 0, 255}, thickness = 0.5));
  connect(m, plugToPin_C.plug_n) annotation (
    Line(points = {{100, 0}, {100, 0}, {100, -80}, {46, -80}, {46, -80}}, color = {0, 140, 72}, thickness = 0.5));
  connect(plugToPin_A.pin_n, SW_a.pin_n) annotation (
    Line(points = {{42, 60}, {10, 60}, {10, 60}, {12, 60}}, color = {238, 46, 47}, thickness = 0.5));
  connect(plugToPin_B.pin_n, SW_b.pin_n) annotation (
    Line(points = {{42, 0}, {12, 0}, {12, 0}, {12, 0}}, color = {0, 0, 255}, thickness = 0.5));
  connect(plugToPin_C.pin_n, SW_c.pin_n) annotation (
    Line(points = {{42, -80}, {38, -80}, {38, -80}, {12, -80}, {12, -80}}, color = {0, 140, 72}, thickness = 0.5));

annotation (Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2018-08-16 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"), uses(Modelica(version="3.2.3")),defaultComponentName = "Breaker",
    Icon(graphics={  Text(origin = {4, 18}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"),  Line(origin = {54.3211, 0}, points = {{-14, 0}, {30, 0}, {36, 0}}, color = {0, 0, 255}), Rectangle(origin = {1, -5}, lineColor = {0, 0, 255}, extent = {{-41, 45}, {39, -35}}), Line(origin = {-65, -1}, points = {{25, 1}, {-25, 1}, {-25, -1}}, color = {0, 0, 255}), Text(origin = {-31, 7}, extent = {{-21, 14}, {33, -24}}, textString = "+")}, coordinateSystem(initialScale = 0.1)));
end Breaker;
