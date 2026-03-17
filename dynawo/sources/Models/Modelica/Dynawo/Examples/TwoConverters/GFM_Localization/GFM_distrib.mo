within Dynawo.Examples.TwoConverters.GFM_Localization;

model GFM_distrib
  parameter Types.Time tOmegaEvtStart = 20;
  parameter Types.Time tOmegaEvtEnd = 21;
  parameter Types.Time tMagnitudeEvtstart = 3;
  parameter Types.Time tMagnitudeEvtEnd = 3.01;
  extends Modelica.Icons.Example;
  Electrical.Buses.Bus Bus annotation(
    Placement(transformation(origin = {-42, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line(RPu = 0.001875, XPu = 0.01875, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {-22, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875) annotation(
    Placement(transformation(origin = {-66, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.0046, XPu = 0.046) annotation(
    Placement(transformation(origin = {-42, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Types.VoltageModulePu U2Pu;
  Types.Angle UPhase2;
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL1(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5*(1/2), Q0Pu = -0.21*(1/2), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(1/2), U0Pu = 1.0847, UPhase0 = -0.18, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL2(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5*(1/4), Q0Pu = -0.21*(1/4), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(1/4), U0Pu = 1.1072, UPhase0 = 0.098, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {106, 16}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL3(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5*(1/4), Q0Pu = -0.21*(1/4), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(1/4), U0Pu = 1.1072, UPhase0 = 0.098, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {106, -10}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Electrical.Lines.Line transfo1(BPu = 0, GPu = 0, RPu = 0.0003125*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {2, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo2(BPu = 0, GPu = 0, RPu = 0.0003125*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {2, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {-42, -46}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaSetPu = 1, P0Pu = 0, Q0Pu = 0, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 5, U0Pu = 0.9984, UPhase0 = 0.0374, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0.5, kVSM = 155.955, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {111, 43}, extent = {{-9, 9}, {9, -9}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0) annotation(
    Placement(transformation(origin = {144, 62}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {144, 50}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {144, 38}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {144, 26}, extent = {{4, -4}, {-4, 4}})));
  Electrical.Lines.Line transfo11(BPu = 0, GPu = 0, RPu = 0.0005625*2, XPu = 0.03125*2) annotation(
    Placement(transformation(origin = {26, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo21(BPu = 0, GPu = 0, RPu = 0.0005625*2, XPu = 0.03125*2) annotation(
    Placement(transformation(origin = {26, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo111(BPu = 0, GPu = 0, RPu = 0.0009375*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {52, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo1111(BPu = 0, GPu = 0, RPu = 0.0009375*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {52, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo1112(BPu = 0, GPu = 0, RPu = 0.0005*2, XPu = 0.017*2) annotation(
    Placement(transformation(origin = {78, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo1113(BPu = 0, GPu = 0, RPu = 0.0005*2, XPu = 0.017*2) annotation(
    Placement(transformation(origin = {78, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
// No switch-off of the lines
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  transfo1.switchOffSignal1.value = false;
  transfo1.switchOffSignal2.value = false;
  transfo2.switchOffSignal1.value = false;
  transfo2.switchOffSignal2.value = false;
  transfo11.switchOffSignal1.value = false;
  transfo11.switchOffSignal2.value = false;
  transfo21.switchOffSignal1.value = false;
  transfo21.switchOffSignal2.value = false;
  transfo111.switchOffSignal1.value = false;
  transfo111.switchOffSignal2.value = false;
  transfo1111.switchOffSignal1.value = false;
  transfo1111.switchOffSignal2.value = false;
  transfo1112.switchOffSignal1.value = false;
  transfo1112.switchOffSignal2.value = false;
  transfo1113.switchOffSignal1.value = false;
  transfo1113.switchOffSignal2.value = false;
// No modifications in GFL set points
  der(GFL1.PFilterRefPu) = 0;
  der(GFL1.QFilterRefPu) = 0;
  der(GFL1.omegaRefPu) = 0;
  der(GFL2.PFilterRefPu) = 0;
  der(GFL2.QFilterRefPu) = 0;
  der(GFL2.omegaRefPu) = 0;
  der(GFL3.PFilterRefPu) = 0;
  der(GFL3.QFilterRefPu) = 0;
  der(GFL3.omegaRefPu) = 0;
  U1Pu = Modelica.ComplexMath.'abs'(GFL1.terminal.V);
  U2Pu = Modelica.ComplexMath.'abs'(GFL2.terminal.V);
  UPhase1 = Modelica.ComplexMath.arg(GFL1.terminal.V);
  UPhase2 = Modelica.ComplexMath.arg(GFL2.terminal.V);
  connect(line1.terminal2, Bus.terminal) annotation(
    Line(points = {{-56, 0}, {-42, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, Bus.terminal) annotation(
    Line(points = {{-42, -10}, {-42, 0}}, color = {0, 0, 255}));
  connect(Bus.terminal, line.terminal2) annotation(
    Line(points = {{-42, 0}, {-32, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, GFL1.terminal) annotation(
    Line(points = {{-76, 0}, {-78, 0}}, color = {0, 0, 255}));
  connect(transfo1.terminal2, line.terminal1) annotation(
    Line(points = {{-8, 16}, {-8, 0}, {-12, 0}}, color = {0, 0, 255}));
  connect(transfo2.terminal2, line.terminal1) annotation(
    Line(points = {{-8, -10}, {-8, 0}, {-12, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-42, -30}, {-42, -46}}, color = {0, 0, 255}));
  connect(PRefPu.y, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{139.6, 62}, {127.6, 62}, {127.6, 50}, {119.6, 50}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{139.6, 50}, {129.6, 50}, {129.6, 46}, {119.6, 46}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{139.6, 38}, {129.6, 38}, {129.6, 40}, {119.6, 40}}, color = {0, 0, 127}));
  connect(DynGFMVSM.UFilterRefPu, URefPu.y) annotation(
    Line(points = {{120.9, 35.8}, {128.9, 35.8}, {128.9, 25.8}, {140.9, 25.8}}, color = {0, 0, 127}));
  connect(transfo11.terminal2, transfo1.terminal1) annotation(
    Line(points = {{16, 16}, {12, 16}}, color = {0, 0, 255}));
  connect(transfo2.terminal1, transfo21.terminal2) annotation(
    Line(points = {{12, -10}, {16, -10}}, color = {0, 0, 255}));
  connect(transfo11.terminal1, transfo111.terminal2) annotation(
    Line(points = {{36, 16}, {42, 16}}, color = {0, 0, 255}));
  connect(transfo1111.terminal2, transfo21.terminal1) annotation(
    Line(points = {{42, -10}, {36, -10}}, color = {0, 0, 255}));
  connect(transfo1112.terminal2, transfo111.terminal1) annotation(
    Line(points = {{68, 16}, {62, 16}}, color = {0, 0, 255}));
  connect(transfo1113.terminal2, transfo1111.terminal1) annotation(
    Line(points = {{68, -10}, {62, -10}}, color = {0, 0, 255}));
  connect(transfo1113.terminal1, GFL3.terminal) annotation(
    Line(points = {{88, -10}, {100, -10}}, color = {0, 0, 255}));
  connect(GFL2.terminal, transfo1112.terminal1) annotation(
    Line(points = {{100, 16}, {88, 16}}, color = {0, 0, 255}));
  connect(DynGFMVSM.terminal, transfo111.terminal1) annotation(
    Line(points = {{102, 44}, {62, 44}, {62, 16}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-06, Interval = 0.001),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));

end GFM_distrib;