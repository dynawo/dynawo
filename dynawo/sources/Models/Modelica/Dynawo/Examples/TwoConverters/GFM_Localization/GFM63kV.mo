within Dynawo.Examples.TwoConverters.GFM_Localization;

model GFM63kV
  parameter Types.Time tOmegaEvtStart = 20;
  parameter Types.Time tOmegaEvtEnd = 21;
  parameter Types.Time tMagnitudeEvtstart = 6;
  parameter Types.Time tMagnitudeEvtEnd = 6.01;
  extends Modelica.Icons.Example;
  Electrical.Buses.Bus Bus annotation(
    Placement(transformation(origin = {-38, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line(RPu = 0.001875, XPu = 0.01875, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {-14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875) annotation(
    Placement(transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.0025, XPu = 0.025) annotation(
    Placement(transformation(origin = {-38, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Types.VoltageModulePu U2Pu;
  Types.Angle UPhase2;
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL1(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5*(7/10), Q0Pu = -0.21*(7/10), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(7/10), U0Pu = 1.0847, UPhase0 = -0.18, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL2(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5*(7/20), Q0Pu = -0.21*(7/20), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(7/20), U0Pu = 1.1072, UPhase0 = 0.098, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {94, 16}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL3(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5*(7/20), Q0Pu = -0.21*(7/20), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(7/20), U0Pu = 1.1072, UPhase0 = 0.098, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {94, -10}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Electrical.Lines.Line transfo1(BPu = 0, GPu = 0, RPu = 0.0003125*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {20, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo2(BPu = 0, GPu = 0, RPu = 0.0003125*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {20, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {-38, -46}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaSetPu = 1, P0Pu = 0, Q0Pu = 0, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 50, U0Pu = 0.9984, UPhase0 = 0.0374, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0.5, kVSM = 155.955, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {91, 51}, extent = {{-9, 9}, {9, -9}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0) annotation(
    Placement(transformation(origin = {124, 70}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {124, 58}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {124, 46}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {124, 34}, extent = {{4, -4}, {-4, 4}})));
  Electrical.Lines.Line transfo11(BPu = 0, GPu = 0, RPu = 0.0005625*2, XPu = 0.03125*2) annotation(
    Placement(transformation(origin = {44, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo21(BPu = 0, GPu = 0, RPu = 0.0005625*2, XPu = 0.03125*2) annotation(
    Placement(transformation(origin = {44, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo111(BPu = 0, GPu = 0, RPu = 0.0009375*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {70, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo1111(BPu = 0, GPu = 0, RPu = 0.0009375*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
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
    Line(points = {{-52, 0}, {-38, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, Bus.terminal) annotation(
    Line(points = {{-38, -10}, {-38, 0}}, color = {0, 0, 255}));
  connect(Bus.terminal, line.terminal2) annotation(
    Line(points = {{-38, 0}, {-24, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, GFL1.terminal) annotation(
    Line(points = {{-72, 0}, {-78, 0}}, color = {0, 0, 255}));
  connect(transfo1.terminal2, line.terminal1) annotation(
    Line(points = {{10, 16}, {4, 16}, {4, 0}, {-4, 0}}, color = {0, 0, 255}));
  connect(transfo2.terminal2, line.terminal1) annotation(
    Line(points = {{10, -10}, {4, -10}, {4, 0}, {-4, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-38, -30}, {-38, -46}}, color = {0, 0, 255}));
  connect(PRefPu.y, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{119.6, 70}, {107.6, 70}, {107.6, 58}, {99.6, 58}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{119.6, 58}, {109.6, 58}, {109.6, 54}, {99.6, 54}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{119.6, 46}, {109.6, 46}, {109.6, 48}, {99.6, 48}}, color = {0, 0, 127}));
  connect(DynGFMVSM.UFilterRefPu, URefPu.y) annotation(
    Line(points = {{100.9, 43.8}, {108.9, 43.8}, {108.9, 33.8}, {120.9, 33.8}}, color = {0, 0, 127}));
  connect(transfo11.terminal2, transfo1.terminal1) annotation(
    Line(points = {{34, 16}, {30, 16}}, color = {0, 0, 255}));
  connect(transfo2.terminal1, transfo21.terminal2) annotation(
    Line(points = {{30, -10}, {34, -10}}, color = {0, 0, 255}));
  connect(transfo11.terminal1, transfo111.terminal2) annotation(
    Line(points = {{54, 16}, {60, 16}}, color = {0, 0, 255}));
  connect(transfo111.terminal1, GFL2.terminal) annotation(
    Line(points = {{80, 16}, {88, 16}}, color = {0, 0, 255}));
  connect(transfo1111.terminal2, transfo21.terminal1) annotation(
    Line(points = {{60, -10}, {54, -10}}, color = {0, 0, 255}));
  connect(transfo1111.terminal1, GFL3.terminal) annotation(
    Line(points = {{80, -10}, {88, -10}}, color = {0, 0, 255}));
  connect(DynGFMVSM.terminal, transfo111.terminal1) annotation(
    Line(points = {{82, 52}, {76, 52}, {76, 24}, {80, 24}, {80, 16}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-06, Interval = 0.001),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end GFM63kV;