within Dynawo.Examples.GridForming;

model TP_GFL
  parameter Types.Time tOmegaEvtStart = 11;
  parameter Types.Time tOmegaEvtEnd = 11.0001;
  parameter Types.Time tMagnitudeEvtstart = 20;
  parameter Types.Time tMagnitudeEvtEnd = 20 + 3;
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = 3.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005) annotation(
    Placement(transformation(origin = {44, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-110, 6}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL(BFilterPu = 1e-5, Kfd = 0.8, Kfq = 0, Ki = 10, Kic = 15, Kid = 2.25, Kiq = 2.25, Kp = 2, Kpc = 0.477465, Kpd = 0.12, Kpq = 0.12, XFilterPu = 0.15, XTransformerPu = 0.06, OmegaMaxPu = 0.9, OmegaMinPu = 1.1, P0Pu = -7, Q0Pu = 0.4019, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9984, UPhase0 = 0.0374, tPFilt = 0.02, tQFilt = 0.02) annotation(
    Placement(transformation(origin = {-10, -2}, extent = {{-18, -18}, {18, 18}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {-110, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PrefPu(height = 0.1, offset = 0.2, startTime = 8)  annotation(
    Placement(transformation(origin = {-110, 38}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Loads.LoadZIP loadZIP(Ip = 0, Iq = 0, Pp = 0, Pq = 0, Zp = 1, Zq = 0, i0Pu = Complex(1, 0), s0Pu = Complex(-3.5, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(transformation(origin = {34, -22}, extent = {{-10, -10}, {10, 10}})));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  loadZIP.deltaQ = 0;
  loadZIP.deltaP = 0;
// Variation in P in loadPQ (5% in base SNom for inertialGrid1)
  der(loadZIP.QRefPu) = 0;
  der(loadZIP.PRefPu) = 0;
  loadZIP.switchOffSignal1.value = if (time > 7) then true else false;
  loadZIP.switchOffSignal2.value = if (time > 7) then true else false; 
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{54, -2}, {82, -2}}, color = {0, 0, 255}));
  connect(GFL.terminal, line.terminal1) annotation(
    Line(points = {{10, -2}, {34, -2}}, color = {0, 0, 255}));
  connect(QRefPu.y, GFL.QFilterRefPu) annotation(
    Line(points = {{-99, -26}, {-50, -26}, {-50, -9}, {-30, -9}}, color = {0, 0, 127}));
  connect(PrefPu.y, GFL.PFilterRefPu) annotation(
    Line(points = {{-98, 38}, {-50, 38}, {-50, 12}, {-30, 12}}, color = {0, 0, 127}));
  connect(loadZIP.terminal, line.terminal1) annotation(
    Line(points = {{34, -22}, {34, -2}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, GFL.omegaRefPu) annotation(
    Line(points = {{-98, 6}, {-30, 6}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 16, Tolerance = 1e-06, Interval = 0.0016),
    Diagram,
  Documentation(info = "<html><head></head><body>Modèle GFL + SMIB&nbsp;<div><br><div>A t=2s : ajout d'un échelon sur la référence Idref de 0.1Pu</div></div><div>A t=5s : ajout d'un échelon sur la référence Iqref de 0.1Pu</div><div>A t=7s : connexion d'une charge de 1/2Pn et Q=0&nbsp;</div><div>A t=8s : ajout d'un échelon sur la consigne de puissance active de l'onduleur de 0.1Pu</div><div>A t=11s : ajout d'un échelon d'angle de -5° à la source infinie</div></body></html>"));
end TP_GFL;