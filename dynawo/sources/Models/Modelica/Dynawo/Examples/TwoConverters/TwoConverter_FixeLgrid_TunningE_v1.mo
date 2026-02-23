within Dynawo.Examples.TwoConverters;

model TwoConverter_FixeLgrid_TunningE_v1
  extends Modelica.Icons.Example;

  parameter Types.Time tOmegaEvtStart = 20;
  parameter Types.Time tOmegaEvtEnd = 21;
  parameter Types.Time tMagnitudeEvtstart = 30;
  parameter Types.Time tMagnitudeEvtEnd = 30.01;

  Dynawo.Electrical.Buses.Bus Bus annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Dynawo.Electrical.Lines.DynLine line(XPu = 0.03375, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0005 + 0.001875, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04)
  //Dynawo.Electrical.Lines.DynLine line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875)
  // Dynawo.Electrical.Lines.DynLine line2(BPu = 0, GPu = 0, RPu = 0.0055, XPu = 0.055)
  Dynawo.Electrical.Lines.DynLine line(LPu = 0.0144, P01Pu = 5, P02Pu = -4.94531238, Q01Pu = 0.21, Q02Pu = 0.56713991, RPu = 0.00144, U01Pu = 1.04289359, U02Pu = 1.03733331, UPhase01 = 6.668423 * 3.14 / 180, UPhase02 = -2.278818 * 180 / 3.14) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.DynLine line1(LPu = 0.0144, P01Pu = -5, P02Pu = 5.05725313, Q01Pu = 0.21, Q02Pu = 0.60359717, RPu = 0.00144, U01Pu = 1.01925978, U02Pu = 1.03733331, UPhase01 = -11.490041 * 3.14 / 180, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFL GFL1(CFilterPu = 1 / 1e5, Kfd = 1, Kfq = 0, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.3819, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 300, tPQFilt = 1 / 111.055, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 / 2000, tVSC = 0) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFL GFL2(CFilterPu = 1 / 1e5, Kfd = 1, Kfq = 0, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.3819, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.1072, UPhase0 = 0.098, tPFilt = 1 / 300, tPQFilt = 1 / 111.055, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 / 2000, tVSC = 0) annotation(
    Placement(transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {2, -48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step2(height = 0.01, offset = 0.021, startTime = 1.5) annotation(
    Placement(transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 0.01, offset = 0.021, startTime = 1.5) annotation(
    Placement(transformation(origin = {130, 10}, extent = {{10, -10}, {-10, 10}})));
  Dynawo.Electrical.Lines.DynLine line22(LPu = 0.05, P01Pu = 0.11901040, P02Pu = -0.11194076, Q01Pu = 1.24143346, Q02Pu = -1.17073708, RPu = 0.005, U01Pu = 1.1, U02Pu = 1.03733331, UPhase01 = -0.04, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {2, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Step step1(height = -0.1, offset = -0.5, startTime = 2.5) annotation(
    Placement(transformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step3(height = 0.1, offset = 0.5, startTime = 2.5) annotation(
    Placement(transformation(origin = {130, -30}, extent = {{10, -10}, {-10, 10}})));
  Dynawo.Electrical.Lines.DynLine line221(LPu = 0.077775, P01Pu = 0.11901040, P02Pu = -0.11194076, Q01Pu = 1.24143346, Q02Pu = -1.17073708, RPu = 0.0077775, U01Pu = 1.1, U02Pu = 1.03733331, UPhase01 = -0.04, UPhase02 = -2.278818*3.14/180) annotation(
    Placement(transformation(origin = {-40, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.idealSwitch idealSwitch(Ron = 1e-5, Goff = 1e-5)  annotation(
    Placement(transformation(origin = {-20, -16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanTable booleanTable(startValue = true, table = {0, 4}) annotation(
    Placement(transformation(origin = {30, -36}, extent = {{-10, -10}, {10, 10}})));

equation
// No switch-off of the lines
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line22.switchOffSignal1.value = false;
  line22.switchOffSignal2.value = false;
  line221.switchOffSignal1.value = false;
  line221.switchOffSignal2.value = false;
//omega for dynamic Lines
  line.omegaPu.value = 1;
  line1.omegaPu.value = 1;
  line22.omegaPu.value = 1;
  line221.omegaPu.value = 1;
// No modifications in GFL set points
  //der(GFL1.PFilterRefPu) = 0;
//der(GFL1.QFilterRefPu) = 0;
  der(GFL1.omegaRefPu) = 0;
  //der(GFL2.PFilterRefPu) = 0;
//der(GFL2.QFilterRefPu) = 0;
  der(GFL2.omegaRefPu) = 0;
  U1Pu = Modelica.ComplexMath.'abs'(GFL1.terminal.V);
  UPhase1 = Modelica.ComplexMath.arg(GFL1.terminal.V);
  GFL1.switchOffSignal1.value = false;
  GFL1.switchOffSignal2.value = false;
  GFL1.switchOffSignal3.value = false;
  GFL2.switchOffSignal1.value = false;
  GFL2.switchOffSignal2.value = false;
  GFL2.switchOffSignal3.value = false;
  connect(line1.terminal2, Bus.terminal) annotation(
    Line(points = {{-22, 0}, {2, 0}}, color = {0, 0, 255}));
  connect(Bus.terminal, line.terminal2) annotation(
    Line(points = {{2, 0}, {24, 0}}, color = {0, 0, 255}));
  connect(GFL1.terminal, line1.terminal1) annotation(
    Line(points = {{-56, 0}, {-42, 0}}, color = {0, 0, 255}));
  connect(GFL2.terminal, line.terminal1) annotation(
    Line(points = {{63, 0}, {44, 0}}, color = {0, 0, 255}));
  connect(step2.y, GFL1.QFilterRefPu) annotation(
    Line(points = {{-99, -30}, {-90.5, -30}, {-90.5, -4}, {-78, -4}}, color = {0, 0, 127}));
  connect(GFL2.QFilterRefPu, step.y) annotation(
    Line(points = {{86, 4}, {99.5, 4}, {99.5, 10}, {119, 10}}, color = {0, 0, 127}));
  connect(line22.terminal2, Bus.terminal) annotation(
    Line(points = {{2, -12}, {2, 0}}, color = {0, 0, 255}));
  connect(line22.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{2, -32}, {2, -48}}, color = {0, 0, 255}));
  connect(step1.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{-99, 10}, {-86, 10}, {-86, 8}, {-78, 8}}, color = {0, 0, 127}));
  connect(GFL2.PFilterRefPu, step3.y) annotation(
    Line(points = {{86, -8}, {96, -8}, {96, -30}, {119, -30}}, color = {0, 0, 127}));
  connect(booleanTable.y, idealSwitch.control) annotation(
    Line(points = {{42, -36}, {54, -36}, {54, -4}, {-20, -4}}, color = {255, 0, 255}));
  connect(line221.terminal2, idealSwitch.terminal1) annotation(
    Line(points = {{-40, -12}, {-30, -12}}, color = {0, 0, 255}));
  connect(idealSwitch.terminal2, line22.terminal2) annotation(
    Line(points = {{-10, -12}, {2, -12}}, color = {0, 0, 255}));
  connect(line221.terminal1, line22.terminal1) annotation(
    Line(points = {{-40, -32}, {2, -32}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.002),
    Diagram(coordinateSystem(extent = {{-80, 20}, {100, -60}})),
    Documentation(info = "<html><head></head><body>
    <p><b>GFL – Grid Following Converter Parameters:</b>Tunning E</p><p>QfilterRef as set to 0.021 with a source otherwise when i 've set der(Q)=0 in steady state it did not took the , Q0 value 0.021 instead it took 0.031, it was observed when SCR=20</p><p>Here The line22 will be <b>dynamic ramp, this was done since in EMTP the stability limit of Zline=0.33pu and in OM Zline=0.04pu</b></p><p>tunningB+&nbsp;<b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tUqPLL = 1/2000</b><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">&nbsp;</span></p><p><br></p>

</body></html>"));
end TwoConverter_FixeLgrid_TunningE_v1;
