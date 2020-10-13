within OpenEMTP.Examples.Machine;

model TestSMEMTP_PU
  Electrical.Switches.IdealSwitch sw(Tclosing = 1, Topening = 1.1) annotation(
    Placement(visible = true, transformation(origin = {20, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant Pm(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-117, 45}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Electrical.RLC_Branches.Ground g annotation(
    Placement(visible = true, transformation(origin = {98, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Plug_b plug_b annotation(
    Placement(visible = true, transformation(origin = {-24, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Plug_a plug_a annotation(
    Placement(visible = true, transformation(origin = {-24, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.R Rb(R = 100) annotation(
    Placement(visible = true, transformation(origin = {38, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.R Ra(R = 100) annotation(
    Placement(visible = true, transformation(origin = {38, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.Plug_c plug_c annotation(
    Placement(visible = true, transformation(origin = {-24, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.R Rc(R = 100) annotation(
    Placement(visible = true, transformation(origin = {38, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vf(k = 0.00046) annotation(
    Placement(visible = true, transformation(origin = {-118, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Machines.SMEMTP_PU smemtp_pu annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Rb.p, plug_b.pin_p) annotation(
    Line(points = {{28, 20}, {-22, 20}, {-22, 20}, {-22, 20}}, color = {0, 0, 255}));
  connect(Rc.p, plug_c.pin_p) annotation(
    Line(points = {{28, -40}, {-22, -40}, {-22, -40}, {-22, -40}}, color = {0, 0, 255}));
  connect(sw.pin_n, Rb.p) annotation(
    Line(points = {{20, 39}, {20, 20}, {28, 20}}, color = {0, 0, 255}));
  connect(Rb.n, g.p) annotation(
    Line(points = {{48, 20}, {98, 20}, {98, 2}, {98, 2}}, color = {0, 0, 255}));
  connect(sw.pin_p, Ra.p) annotation(
    Line(points = {{20, 61}, {20, 80}, {28, 80}}, color = {0, 0, 255}));
  connect(Ra.p, plug_a.pin_p) annotation(
    Line(points = {{28, 80}, {-22, 80}, {-22, 80}, {-22, 80}}, color = {0, 0, 255}));
  connect(Ra.n, g.p) annotation(
    Line(points = {{48, 80}, {98, 80}, {98, 2}, {98, 2}}, color = {0, 0, 255}));
  connect(Rc.n, g.p) annotation(
    Line(points = {{48, -40}, {76, -40}, {76, 2}, {98, 2}, {98, 2}}, color = {0, 0, 255}));
  connect(smemtp_pu.Pk, plug_a.plug_p) annotation(
    Line(points = {{-60, 20}, {-50, 20}, {-50, 80}, {-26, 80}}, color = {0, 0, 255}));
  connect(plug_b.plug_p, smemtp_pu.Pk) annotation(
    Line(points = {{-26, 20}, {-60, 20}}, color = {0, 0, 255}));
  connect(plug_c.plug_p, smemtp_pu.Pk) annotation(
    Line(points = {{-26, -40}, {-50, -40}, {-50, 20}, {-60, 20}}, color = {0, 0, 255}));
  connect(Pm.y, smemtp_pu.Pm) annotation(
    Line(points = {{-109, 45}, {-90, 45}, {-90, 28}, {-82, 28}}, color = {0, 0, 127}));
  connect(Vf.y, smemtp_pu.Vfd) annotation(
    Line(points = {{-107, 0}, {-90, 0}, {-90, 14}, {-82, 14}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.0002));
end TestSMEMTP_PU;
