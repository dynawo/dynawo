within Dynawo.Examples.GridForming;

model ENTSOE4

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
  Modelica.Blocks.Sources.Step PRefPu(height = 0.25, offset = dynGFL.Control.outerLoop.PFilter0Pu, startTime = 5)  annotation(
    Placement(visible = true, transformation(origin = {-112, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFL dynGFL(CFilterPu = 1e-5, Kfd = 0.8, Kfq = 0, Ki = 10, Kic = 15, Kid = 2.25, Kiq = 2.25, Kp = 2, Kpc = 0.477465, Kpd = 0.12, Kpq = 0.12, LFilterPu = 0.15, LTransformerPu = 0.06, OmegaMaxPu = 0.9, OmegaMinPu = 1.1,P0Pu = -7.4663, Q0Pu = 0.4119, RFilterPu = 0.015, RTransformerPu = 0.006,SNom = 1000, U0Pu = 0.9984, UPhase0 = 0.0374, tPFilt = 0.02, tQFilt = 0.02, tVSC = 0.0004)  annotation(
    Placement(visible = true, transformation(origin = {-36, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
 Modelica.Blocks.Sources.Step step(height = 0.25, offset = dynGFL.Control.outerLoop.QFilter0Pu, startTime = 100) annotation(
    Placement(visible = true, transformation(origin = {-112, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{54, 0}, {82, 0}}, color = {0, 0, 255}));
  connect(dynGFL.terminal, line.terminal1) annotation(
    Line(points = {{-21, 0}, {34, 0}}, color = {0, 0, 255}));
  connect(PRefPu.y, dynGFL.PFilterRefPu) annotation(
    Line(points = {{-100, 40}, {-60, 40}, {-60, 12}, {-52, 12}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, dynGFL.omegaRefPu) annotation(
    Line(points = {{-100, 6}, {-52, 6}}, color = {0, 0, 127}));
 connect(step.y, dynGFL.QFilterRefPu) annotation(
    Line(points = {{-100, -38}, {-60, -38}, {-60, -6}, {-52, -6}}, color = {0, 0, 127}));
end ENTSOE4;
