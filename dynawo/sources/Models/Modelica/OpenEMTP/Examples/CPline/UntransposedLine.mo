within OpenEMTP.Examples.CPline;

model UntransposedLine
  extends Modelica.Icons.Example;
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage cosineVoltage(V = 4.160e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM TLM(Ti = [0.502659687516342, 0.778867301097029, -0.249833119452532; 0.644850930369252, -0.176951289724402, 0.792006771920747; 0.533578236163045, -0.600564731133732, -0.550352955472635], Zc = {764.184393459587, 306.035536630964, 375.610320375084}, d = 10.0000003200000, r = {0.624132018960508, 0.367412074618122, 0.365147402870877}, tau = {4.20638695731765e-05, 3.69866780459919e-05, 3.62922192121727e-05}) annotation(
    Placement(visible = true, transformation(origin = {6, 0}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
    Placement(visible = true, transformation(origin = {-86, -19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Star star2 annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Bus bus annotation(
    Placement(visible = true, transformation(origin = {-22, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL rl(L = 0.044646315377074, R = 24.481839080459770) annotation(
    Placement(visible = true, transformation(origin = {72, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL rl1(L = 0.061206039626025, R = 30.765511111111110) annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL rl2(L = 0.061206039626025, R = 30.765511111111110) annotation(
    Placement(visible = true, transformation(origin = {72, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_a plug_a annotation(
    Placement(visible = true, transformation(origin = {40, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_b plug_b annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_c plug_c annotation(
    Placement(visible = true, transformation(origin = {40, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.Ground G annotation(
    Placement(visible = true, transformation(origin = {112, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(rl.n, G.p) annotation(
    Line(points = {{82, 18}, {112, 18}, {112, -32}, {112, -32}}, color = {0, 0, 255}));
  connect(rl1.n, G.p) annotation(
    Line(points = {{82, 0}, {112, 0}, {112, -32}, {112, -32}}, color = {0, 0, 255}));
  connect(rl2.n, G.p) annotation(
    Line(points = {{82, -22}, {112, -22}, {112, -32}, {112, -32}}, color = {0, 0, 255}));
  connect(cosineVoltage.plug_n, star2.plug_p) annotation(
    Line(points = {{-50, 0}, {-58, 0}}, color = {0, 0, 255}));
  connect(bus.positivePlug2, cosineVoltage.plug_p) annotation(
    Line(points = {{-24, 0}, {-30, 0}}, color = {0, 0, 255}));
  connect(TLM.Plug_k, bus.positivePlug1) annotation(
    Line(points = {{-9, 0}, {-20, 0}}, color = {0, 0, 255}));
  connect(star2.pin_n, ground1.p) annotation(
    Line(points = {{-78, 0}, {-86, 0}, {-86, -10}}, color = {0, 0, 255}));
  connect(plug_a.plug_p, TLM.Plug_m) annotation(
    Line(points = {{38, 18}, {20, 18}, {20, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(plug_b.plug_p, TLM.Plug_m) annotation(
    Line(points = {{38, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(plug_c.plug_p, TLM.Plug_m) annotation(
    Line(points = {{38, -22}, {20, -22}, {20, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(plug_a.pin_p, rl.p) annotation(
    Line(points = {{42, 18}, {62, 18}, {62, 18}, {62, 18}}, color = {0, 0, 255}));
  connect(plug_b.pin_p, rl1.p) annotation(
    Line(points = {{42, 0}, {62, 0}, {62, 0}, {62, 0}}, color = {0, 0, 255}));
  connect(plug_c.pin_p, rl2.p) annotation(
    Line(points = {{42, -22}, {62, -22}, {62, -22}, {62, -22}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.005, Tolerance = 1e-06, Interval = 5.00501e-06),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end UntransposedLine;
