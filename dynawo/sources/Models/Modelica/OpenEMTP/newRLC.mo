within OpenEMTP;

model newRLC
  OpenEMTP.Electrical.RLC_Branches.R r(R = 5)  annotation(
    Placement(visible = true, transformation(origin = {-32, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.L l(L = 150E-3)  annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.C c(C = 5e-6)  annotation(
    Placement(visible = true, transformation(origin = {28, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.CosineVoltage ac(Phase = 0, Vm = 10, f = 60)  annotation(
    Placement(visible = true, transformation(origin = {-34, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground g annotation(
    Placement(visible = true, transformation(origin = {40, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ac.p, r.p) annotation(
    Line(points = {{-44, -46}, {-44, 10}, {-42, 10}}, color = {0, 0, 255}));
  connect(c.n, g.p) annotation(
    Line(points = {{38, 10}, {40, 10}, {40, -46}}, color = {0, 0, 255}));
  connect(ac.n, g.p) annotation(
    Line(points = {{-24, -46}, {40, -46}}, color = {0, 0, 255}));
  connect(l.n, c.p) annotation(
    Line(points = {{10, 10}, {16, 10}, {16, 10}, {18, 10}}, color = {0, 0, 255}));
  connect(l.p, r.n) annotation(
    Line(points = {{-10, 10}, {-22, 10}, {-22, 10}, {-22, 10}}, color = {0, 0, 255}));
end newRLC;
