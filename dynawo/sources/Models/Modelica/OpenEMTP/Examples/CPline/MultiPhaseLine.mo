within OpenEMTP.Examples.CPline;
model MultiPhaseLine
  Modelica.Electrical.Analog.Sources.CosineVoltage cosineVoltage1(V = 4.160e3 * sqrt(2 / 3), freqHz = 60) annotation(
    Placement(visible = true, transformation(origin = {-60, 8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM tlm(Ti = [1], Zc = {270.719142291674}, d = 100, m = 1, r = {0.0127300000000000}, tau = {0.000344896187279593}) annotation(
    Placement(visible = true, transformation(origin = {8, 8}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground2 annotation(
    Placement(visible = true, transformation(origin = {90, -15}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin(k = 1, m = 1) annotation(
    Placement(visible = true, transformation(origin = {-28, 8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin1(k = 1, m = 1) annotation(
    Placement(visible = true, transformation(origin = {36, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground3 annotation(
    Placement(visible = true, transformation(origin = {-80, -7}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL rl(L = 0.0446, R = 24) annotation(
    Placement(visible = true, transformation(origin = {68, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(plugToPin.pin_p, cosineVoltage1.p) annotation(
    Line(points = {{-30, 8}, {-50, 8}, {-50, 8}, {-50, 8}}, color = {0, 0, 255}));
  connect(plugToPin1.plug_p, tlm.Plug_m) annotation(
    Line(points = {{34, 8}, {22, 8}, {22, 8}, {22, 8}}, color = {0, 0, 255}));
  connect(plugToPin.plug_p, tlm.Plug_k) annotation(
    Line(points = {{-26, 8}, {-6, 8}, {-6, 8}, {-6, 8}}, color = {0, 0, 255}));
  connect(plugToPin1.pin_p, rl.p) annotation(
    Line(points = {{38, 8}, {58, 8}, {58, 8}, {58, 8}}, color = {0, 0, 255}));
  connect(cosineVoltage1.n, ground3.p) annotation(
    Line(points = {{-70, 8}, {-80, 8}, {-80, 2}, {-80, 2}}, color = {0, 0, 255}));
  connect(rl.n, ground2.p) annotation(
    Line(points = {{78, 8}, {90, 8}, {90, -6}, {90, -6}}, color = {0, 0, 255}));
  annotation(
    uses(Modelica(version = "3.2.3")));
end MultiPhaseLine;
