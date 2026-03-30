within Dynawo.Examples.TwoConverters.GFM_Localization;

model GFM400kV
  parameter Types.Time tOmegaEvtStart = 20;
  parameter Types.Time tOmegaEvtEnd = 21;
  parameter Types.Time tMagnitudeEvtstart = 6;
  parameter Types.Time tMagnitudeEvtEnd = 6.01;
  extends Modelica.Icons.Example;
  Electrical.Buses.Bus Bus annotation(
    Placement(transformation(origin = {-28, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875) annotation(
    Placement(transformation(origin = {-56, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.0022, XPu = 0.022) annotation(
    Placement(transformation(origin = {-28, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Types.VoltageModulePu U2Pu;
  Types.Angle UPhase2 annotation(
    Placement(visible = false, transformation(origin = {nan, nan}, extent = {{nan, nan}, {nan, nan}})));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL1(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5*(1/4), Q0Pu = -0.21*(1/4), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 700, U0Pu = 1.0847, UPhase0 = -0.18, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL2(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5*(1/8), Q0Pu = -0.21*(1/8), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 350, U0Pu = 1.1072, UPhase0 = 0.098, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {70, 16}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Electrical.PEIR.Converters.General.Average.GridFollowing.GFL GFL3(BFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5*(1/8), Q0Pu = -0.21*(1/8), RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 350, U0Pu = 1.1072, UPhase0 = 0.098, XFilterPu = 0.1, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(transformation(origin = {70, -10}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Electrical.Lines.Line transfo1(BPu = 0, GPu = 0, RPu = 0.00225, XPu = 0.1) annotation(
    Placement(transformation(origin = {22, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo2(BPu = 0, GPu = 0, RPu = 0.00225, XPu = 0.1) annotation(
    Placement(transformation(origin = {22, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {-28, -46}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line transfo11(BPu = 0, GPu = 0, RPu = 0.00128, XPu = 0.12) annotation(
    Placement(transformation(origin = {48, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line transfo21(BPu = 0, GPu = 0, RPu = 0.00128, XPu = 0.12) annotation(
    Placement(transformation(origin = {48, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.001875, XPu = 0.01875) annotation(
    Placement(transformation(origin = {-4, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaSetPu = 1, P0Pu = 0, Q0Pu = 0, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 50, U0Pu = 0.9984, UPhase0 = 0.0374, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0.5, kVSM = 155.955, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {55, 51}, extent = {{-9, 9}, {9, -9}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0) annotation(
    Placement(transformation(origin = {88, 70}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {88, 58}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {88, 46}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {88, 34}, extent = {{4, -4}, {-4, 4}})));
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
    Line(points = {{-46, 0}, {-28, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, Bus.terminal) annotation(
    Line(points = {{-28, -10}, {-28, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, GFL1.terminal) annotation(
    Line(points = {{-66, 0}, {-69, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-28, -30}, {-28, -46}}, color = {0, 0, 255}));
  connect(transfo11.terminal2, transfo1.terminal1) annotation(
    Line(points = {{38, 16}, {32, 16}}, color = {0, 0, 255}));
  connect(transfo2.terminal1, transfo21.terminal2) annotation(
    Line(points = {{32, -10}, {38, -10}}, color = {0, 0, 255}));
  connect(line.terminal1, Bus.terminal) annotation(
    Line(points = {{-14, 0}, {-28, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, transfo1.terminal2) annotation(
    Line(points = {{6, 0}, {12, 0}, {12, 16}}, color = {0, 0, 255}));
  connect(transfo2.terminal2, line.terminal2) annotation(
    Line(points = {{12, -10}, {12, 0}, {6, 0}}, color = {0, 0, 255}));
  connect(transfo11.terminal1, GFL2.terminal) annotation(
    Line(points = {{58, 16}, {63, 16}}, color = {0, 0, 255}));
  connect(transfo21.terminal1, GFL3.terminal) annotation(
    Line(points = {{58, -10}, {63, -10}}, color = {0, 0, 255}));
  connect(PRefPu.y, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{83.6, 70}, {71.6, 70}, {71.6, 58}, {63.6, 58}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{83.6, 58}, {73.6, 58}, {73.6, 54}, {63.6, 54}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{83.6, 46}, {73.6, 46}, {73.6, 48}, {63.6, 48}}, color = {0, 0, 127}));
  connect(DynGFMVSM.UFilterRefPu, URefPu.y) annotation(
    Line(points = {{64.9, 43.8}, {72.9, 43.8}, {72.9, 33.8}, {84.9, 33.8}}, color = {0, 0, 127}));
  connect(DynGFMVSM.terminal, transfo1.terminal2) annotation(
    Line(points = {{46, 52}, {12, 52}, {12, 16}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.002),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end GFM400kV;