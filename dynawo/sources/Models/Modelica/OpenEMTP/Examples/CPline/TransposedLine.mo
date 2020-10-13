within OpenEMTP.Examples.CPline;
model TransposedLine
  extends Modelica.Icons.Example;
  Modelica.Electrical.MultiPhase.Basic.Star star2 annotation (
    Placement(visible = true, transformation(origin = {-72, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation (
    Placement(visible = true, transformation(origin = {-90, -55}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  OpenEMTP.Connectors.Bus bus annotation (
    Placement(visible = true, transformation(origin = {-26, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage cosineVoltage(V = 4.160e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation (
    Placement(visible = true, transformation(origin = {-44, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM TLM(Zc = {729.636907490314, 270.719142291674, 270.719142291674}, d = 100, r = {0.386400000000000, 0.0127300000000000, 0.0127300000000000}, tau = {0.000565541566995743, 0.000344896187279593, 0.000344896187279593}) annotation (
    Placement(visible = true, transformation(origin = {4, -36}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL RL(L = 0.0446, R = 24) annotation (
    Placement(visible = true, transformation(origin = {62, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin = {84, -59}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM tlm(Ti = [1], Zc = {270.719142291674}, d = 100, m = 1, r = {0.0127300000000000}, tau = {0.000344896187279593}) annotation (
    Placement(visible = true, transformation(origin = {-2, 50}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL rl(L = 0.0446, R = 24) annotation (
    Placement(visible = true, transformation(origin = {58, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground2 annotation (
    Placement(visible = true, transformation(origin = {80, 27}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.CosineVoltage cosineVoltage1(V = 4.160e3 * sqrt(2 / 3), freqHz = 60)  annotation (
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground3 annotation (
    Placement(visible = true, transformation(origin = {-90, 35}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin(k = 1, m = 1) annotation (
    Placement(visible = true, transformation(origin = {-38, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin1(k = 1, m = 1) annotation (
    Placement(visible = true, transformation(origin = {26, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin2(k = 1, m = 3) annotation (
    Placement(visible = true, transformation(origin = {32, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(plugToPin2.plug_p, TLM.Plug_m) annotation (
    Line(points = {{30, -36}, {18, -36}, {18, -36}, {18, -36}}, color = {0, 0, 255}));
  connect(plugToPin2.pin_p, RL.p) annotation (
    Line(points = {{34, -36}, {52, -36}, {52, -36}, {52, -36}}, color = {0, 0, 255}));
  connect(TLM.Plug_k, bus.positivePlug1) annotation (
    Line(points = {{-11, -36}, {-24, -36}}, color = {0, 0, 255}));
  connect(RL.n, ground.p) annotation (
    Line(points = {{72, -36}, {84, -36}, {84, -50}}, color = {0, 0, 255}));
  connect(bus.positivePlug2, cosineVoltage.plug_p) annotation (
    Line(points = {{-28, -36}, {-34, -36}}, color = {0, 0, 255}));
  connect(cosineVoltage.plug_n, star2.plug_p) annotation (
    Line(points = {{-54, -36}, {-62, -36}}, color = {0, 0, 255}));
  connect(star2.pin_n, ground1.p) annotation (
    Line(points = {{-82, -36}, {-90, -36}, {-90, -46}}, color = {0, 0, 255}));
  connect(rl.n, ground2.p) annotation (
    Line(points = {{68, 50}, {80, 50}, {80, 36}, {80, 36}}, color = {0, 0, 255}));
  connect(cosineVoltage1.n, ground3.p) annotation (
    Line(points = {{-80, 50}, {-90, 50}, {-90, 44}, {-90, 44}}, color = {0, 0, 255}));
  connect(plugToPin.pin_p, cosineVoltage1.p) annotation (
    Line(points = {{-40, 50}, {-60, 50}, {-60, 50}, {-60, 50}}, color = {0, 0, 255}));
  connect(plugToPin.plug_p, tlm.Plug_k) annotation (
    Line(points = {{-36, 50}, {-16, 50}, {-16, 50}, {-16, 50}}, color = {0, 0, 255}));
  connect(plugToPin1.plug_p, tlm.Plug_m) annotation (
    Line(points = {{24, 50}, {12, 50}, {12, 50}, {12, 50}}, color = {0, 0, 255}));
  connect(plugToPin1.pin_p, rl.p) annotation (
    Line(points = {{28, 50}, {48, 50}, {48, 50}, {48, 50}}, color = {0, 0, 255}));
  annotation (
    experiment(StartTime = 0, StopTime = 0.02, Tolerance = 1e-06, Interval = 2.002e-05),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end TransposedLine;
