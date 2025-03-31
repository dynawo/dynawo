within Dynawo.Examples.GridForming;

model ENTSOE5_GFL

  parameter Types.Time tOmegaEvtStart = 10;
  parameter Types.Time tOmegaEvtEnd = 10.0001;
  parameter Types.Time tMagnitudeEvtstart = 20;
  parameter Types.Time tMagnitudeEvtEnd = 20 + 3;
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.88, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005)  annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.25, offset = GFL.Control.outerLoop.PFilter0Pu, startTime = 5)  annotation(
    Placement(visible = true, transformation(origin = {-112, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Step step(height = 0.25, offset = GFL.Control.outerLoop.QFilter0Pu, startTime = 100) annotation(
    Placement(visible = true, transformation(origin = {-112, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL(BFilterPu = 1e-5, Kfd = 0.8, Kfq = 0, Ki = 10, Kic = 15, Kid = 2.25, Kiq = 2.25, Kp = 2, Kpc = 0.477465, Kpd = 0.12, Kpq = 0.12, XFilterPu = 0.15, XTransformerPu = 0.06, OmegaMaxPu = 0.9, OmegaMinPu = 1.1,P0Pu = -7.4663, Q0Pu = 0.4119, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9984, UPhase0 = 0.0374, tPFilt = 0.02, tQFilt = 0.02) annotation(
    Placement(visible = true, transformation(origin = {-10, -1.77636e-15}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{54, 0}, {82, 0}}, color = {0, 0, 255}));
 connect(GFL.terminal, line.terminal1) annotation(
    Line(points = {{10, -2}, {22, -2}, {22, 0}, {34, 0}}, color = {0, 0, 255}));
 connect(GFL.PFilterRefPu, PRefPu.y) annotation(
    Line(points = {{-30, 12}, {-60, 12}, {-60, 40}, {-100, 40}}, color = {0, 0, 127}));
 connect(omegaRefPu.y, GFL.omegaRefPu) annotation(
    Line(points = {{-100, 6}, {-65, 6}, {-65, 5}, {-30, 5}}, color = {0, 0, 127}));
 connect(GFL.QFilterRefPu, step.y) annotation(
    Line(points = {{-30, -9}, {-60, -9}, {-60, -38}, {-100, -38}}, color = {0, 0, 127}));
end ENTSOE5_GFL;
