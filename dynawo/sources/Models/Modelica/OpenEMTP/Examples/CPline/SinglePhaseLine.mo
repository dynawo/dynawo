within OpenEMTP.Examples.CPline;
model SinglePhaseLine
  OpenEMTP.Electrical.RLC_Branches.RL RL1(L = 0.0446, R = 24) annotation (
    Placement(visible = true, transformation(origin = {48, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.SP_TLM sp_tlm(Zc = 270.719142291674, d = 100, r = 0.0127300000000000, tau = 0.000344896187279593) annotation (
    Placement(visible = true, transformation(origin = {-8, 80}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.SP_TLM sp_tlm1(Zc = 270.719142291674, d = 100, r = 0.0127300000000000, tau = 0.000344896187279593) annotation (
    Placement(visible = true, transformation(origin = {-4, 0}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.SP_TLM sp_tlm2(Zc = 270.719142291674, d = 100, r = 0.0127300000000000, tau = 0.000344896187279593) annotation (
    Placement(visible = true, transformation(origin = {-4, -26}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  Electrical.RLC_Branches.Ground G annotation (
    Placement(visible = true, transformation(origin = {-92, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.Ground G1 annotation (
    Placement(visible = true, transformation(origin = {-94, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.CosineVoltage AC(Vm = 4.16 / sqrt(3))  annotation (
    Placement(visible = true, transformation(origin = {-66, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.CosineVoltage AC1(Vm = 4.16 / sqrt(3)) annotation (
    Placement(visible = true, transformation(origin = {-64, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground G2 annotation (
    Placement(visible = true, transformation(origin = {80, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.CosineVoltage cosineVoltage(Vm = 4.16 / sqrt(3)) annotation(
    Placement(visible = true, transformation(origin = {-66, -88}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-92, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.SP_TLM sp_tlm3(Zc = 270.719142291674, d = 100, r = 0.0127300000000000, tau = 0.000344896187279593) annotation(
    Placement(visible = true, transformation(origin = {-8, -88}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch sw annotation(
    Placement(visible = true, transformation(origin = {36, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground ground1 annotation(
    Placement(visible = true, transformation(origin = {66, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(RL1.n, G2.p) annotation (
    Line(points = {{58, 80}, {80, 80}, {80, 68}, {80, 68}}, color = {0, 0, 255}));
  connect(AC1.n, G1.p) annotation (
    Line(points = {{-74, 0}, {-94, 0}, {-94, -4}, {-94, -4}}, color = {0, 0, 255}));
  connect(sp_tlm1.pin_k, AC1.p) annotation (
    Line(points = {{-18, 0}, {-54, 0}, {-54, 0}, {-54, 0}}, color = {0, 0, 255}));
  connect(AC.n, G.p) annotation (
    Line(points = {{-76, 80}, {-92, 80}, {-92, 72}, {-92, 72}}, color = {0, 0, 255}));
  connect(AC.p, sp_tlm.pin_k) annotation (
    Line(points = {{-56, 80}, {-24, 80}, {-24, 80}, {-22, 80}}, color = {0, 0, 255}));
  connect(RL1.p, sp_tlm.pin_m) annotation (
    Line(points = {{38, 80}, {6, 80}}, color = {0, 0, 255}));
  connect(sp_tlm1.pin_k, sp_tlm2.pin_k) annotation (
    Line(points = {{-18, 0}, {-20, 0}, {-20, -26}, {-18, -26}}, color = {0, 0, 255}));
  connect(cosineVoltage.n, ground.p) annotation(
    Line(points = {{-76, -88}, {-92, -88}, {-92, -96}, {-92, -96}}, color = {0, 0, 255}));
  connect(sp_tlm3.pin_k, cosineVoltage.p) annotation(
    Line(points = {{-22, -88}, {-56, -88}, {-56, -88}, {-56, -88}}, color = {0, 0, 255}));
  connect(sp_tlm3.pin_m, sw.pin_p) annotation(
    Line(points = {{6, -88}, {25, -88}}, color = {0, 0, 255}));
  connect(sw.pin_n, ground1.p) annotation(
    Line(points = {{48, -88}, {66, -88}, {66, -110}, {66, -110}}, color = {0, 0, 255}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 0.02, Tolerance = 1e-06, Interval = 2e-05),
    Icon(graphics = {Polygon(origin = {-4, 0}, lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(origin = {0, -2}, lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, extent = {{-100, -100}, {100, 102}}, endAngle = 360)}, coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    __OpenModelica_commandLineOptions = "");
end SinglePhaseLine;
