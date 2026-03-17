within Dynawo.Examples.TwoConverters.GFM_Localization;

model GFM400kV
  parameter Types.Time tOmegaEvtStart = 20;
  parameter Types.Time tOmegaEvtEnd = 21;
  parameter Types.Time tMagnitudeEvtstart = 6;
  parameter Types.Time tMagnitudeEvtEnd = 6.01;
  extends Modelica.Icons.Example;
  Electrical.Buses.Bus Bus annotation(
    Placement(transformation(origin = {-34, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875) annotation(
    Placement(transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.0015, XPu = 0.015) annotation(
    Placement(transformation(origin = {-34, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Types.VoltageModulePu U2Pu;
  Types.Angle UPhase2 annotation(
    Placement(visible = false, transformation(origin = {nan, nan}, extent = {{nan, nan}, {nan, nan}})));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL1(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5*(7/10), Q0Pu = -0.21*(7/10), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(7/10), U0Pu = 1.0847, UPhase0 = -0.18, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {-86, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL2(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5*(7/20), Q0Pu = -0.21*(7/20), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(7/20), U0Pu = 1.1072, UPhase0 = 0.098, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {90, 16}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL3(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5*(7/20), Q0Pu = -0.21*(7/20), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000*(7/20), U0Pu = 1.1072, UPhase0 = 0.098, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {90, -10}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Electrical.Lines.Line transfo1(BPu = 0, GPu = 0, RPu = 0.0003125*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {16, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo2(BPu = 0, GPu = 0, RPu = 0.0003125*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {16, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {-34, -46}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line transfo11(BPu = 0, GPu = 0, RPu = 0.0005625*2, XPu = 0.03125*2) annotation(
    Placement(transformation(origin = {40, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo21(BPu = 0, GPu = 0, RPu = 0.0005625*2, XPu = 0.03125*2) annotation(
    Placement(transformation(origin = {40, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line transfo111(BPu = 0, GPu = 0, RPu = 0.0009375*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {66, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line transfo1111(BPu = 0, GPu = 0, RPu = 0.0009375*2, XPu = 0.0225*2) annotation(
    Placement(transformation(origin = {66, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaSetPu = 1, P0Pu = 0, Q0Pu = 0, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 50, U0Pu = 0.9984, UPhase0 = 0.0374, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0.5, kVSM = 155.955, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {49, 51}, extent = {{-9, 9}, {9, -9}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0) annotation(
    Placement(transformation(origin = {82, 70}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {82, 58}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {82, 46}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {82, 34}, extent = {{4, -4}, {-4, 4}})));
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu =  0.001875, XPu =  0.01875) annotation(
    Placement(transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}})));
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
    Line(points = {{-52, 0}, {-34, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, Bus.terminal) annotation(
    Line(points = {{-34, -10}, {-34, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, GFL1.terminal) annotation(
    Line(points = {{-72, 0}, {-75, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-34, -30}, {-34, -46}}, color = {0, 0, 255}));
  connect(transfo11.terminal2, transfo1.terminal1) annotation(
    Line(points = {{30, 16}, {26, 16}}, color = {0, 0, 255}));
  connect(transfo2.terminal1, transfo21.terminal2) annotation(
    Line(points = {{26, -10}, {30, -10}}, color = {0, 0, 255}));
  connect(transfo11.terminal1, transfo111.terminal2) annotation(
    Line(points = {{50, 16}, {56, 16}}, color = {0, 0, 255}));
  connect(transfo111.terminal1, GFL2.terminal) annotation(
    Line(points = {{76, 16}, {84, 16}}, color = {0, 0, 255}));
  connect(transfo1111.terminal2, transfo21.terminal1) annotation(
    Line(points = {{56, -10}, {50, -10}}, color = {0, 0, 255}));
  connect(transfo1111.terminal1, GFL3.terminal) annotation(
    Line(points = {{76, -10}, {83, -10}}, color = {0, 0, 255}));
  connect(PRefPu.y, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{77.6, 70}, {65.6, 70}, {65.6, 58}, {57.6, 58}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{77.6, 58}, {67.6, 58}, {67.6, 54}, {57.6, 54}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{77.6, 46}, {67.6, 46}, {67.6, 48}, {57.6, 48}}, color = {0, 0, 127}));
  connect(DynGFMVSM.UFilterRefPu, URefPu.y) annotation(
    Line(points = {{58.9, 43.8}, {66.9, 43.8}, {66.9, 33.8}, {78.9, 33.8}}, color = {0, 0, 127}));
  connect(line.terminal1, Bus.terminal) annotation(
    Line(points = {{-20, 0}, {-34, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, transfo1.terminal2) annotation(
    Line(points = {{0, 0}, {6, 0}, {6, 16}}, color = {0, 0, 255}));
  connect(transfo2.terminal2, line.terminal2) annotation(
    Line(points = {{6, -10}, {6, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(DynGFMVSM.terminal, transfo1.terminal2) annotation(
    Line(points = {{40, 52}, {6, 52}, {6, 16}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-06, Interval = 0.001),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end GFM400kV;