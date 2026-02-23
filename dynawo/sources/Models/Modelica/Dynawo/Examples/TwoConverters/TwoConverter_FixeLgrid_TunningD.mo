within Dynawo.Examples.TwoConverters;

model TwoConverter_FixeLgrid_TunningD
  parameter Types.Time tOmegaEvtStart = 20;
  parameter Types.Time tOmegaEvtEnd = 21;
  parameter Types.Time tMagnitudeEvtstart = 30;
  parameter Types.Time tMagnitudeEvtEnd = 30.01;
  extends Modelica.Icons.Example;
  Electrical.Buses.Bus Bus annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Electrical.Lines.DynLine line(XPu = 0.03375, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0005 + 0.001875, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04)
  //Electrical.Lines.DynLine line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875)
  // Electrical.Lines.DynLine line2(BPu = 0, GPu = 0, RPu = 0.0055, XPu = 0.055)
  Electrical.Lines.DynLine line(LPu = 0.0144, P01Pu = 5, P02Pu = -4.94531238, Q01Pu = 0.21, Q02Pu = 0.56713991, RPu = 0.00144, U01Pu = 1.04289359, U02Pu = 1.03733331, UPhase01 = 6.668423 * 3.14 / 180, UPhase02 = -2.278818 * 180 / 3.14) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.DynLine line1(LPu = 0.0144, P01Pu = -5, P02Pu = 5.05725313, Q01Pu = 0.21, Q02Pu = 0.60359717, RPu = 0.00144, U01Pu = 1.01925978, U02Pu = 1.03733331, UPhase01 = -11.490041 * 3.14 / 180, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;




  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFL GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 0, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.38, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 300, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 /2000, tVSC = 0, tPQFilt = 1/111.055) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFL GFL2(CFilterPu = 1e-5, Kfd = 1, Kfq = 0, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.38, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.1072, UPhase0 = 0.098, tPFilt = 1 / 300, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 /2000, tVSC = 0, tPQFilt = 1/111.055) annotation(
    Placement(transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {2, -48}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.DynLine line22(LPu = 0.1,P01Pu = 0.11901040, P02Pu = -0.11194076, Q01Pu = 1.24143346, Q02Pu = -1.17073708, RPu = 0.01, U01Pu = 1.1, U02Pu = 1.03733331, UPhase01 = -0.04, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {2, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.idealSwitch idealSwitch annotation(
    Placement(transformation(origin = {-20, -16}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.DynLine dynLine1(LPu = 0.077775, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0077775, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(transformation(origin = {-40, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanTable booleanTable(startValue = true, table = {0, 4}) annotation(
    Placement(transformation(origin = {30, -36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(height = -0.1, offset = -0.5, startTime = 2.5) annotation(
    Placement(transformation(origin = {-108, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step2(height = 0.01, offset = 0.021, startTime = 1.5) annotation(
    Placement(transformation(origin = {-108, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 0.01, offset = 0.021, startTime = 1.5) annotation(
    Placement(transformation(origin = {124, -10}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Step step3(height = 0.1, offset = 0.5, startTime = 2.5) annotation(
    Placement(transformation(origin = {120, -60}, extent = {{10, -10}, {-10, 10}})));
equation
// No switch-off of the lines
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line22.switchOffSignal1.value = false;
  line22.switchOffSignal2.value = false;
//omega for dynamic Lines
  line.omegaPu.value = 1;
  line1.omegaPu.value = 1;
  line22.omegaPu.value = 1;
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
  dynLine1.switchOffSignal1.value = false;
  dynLine1.switchOffSignal2.value = false;
  dynLine1.omegaPu.value = 1;
  connect(line1.terminal2, Bus.terminal) annotation(
    Line(points = {{-22, 0}, {2, 0}}, color = {0, 0, 255}));
  connect(Bus.terminal, line.terminal2) annotation(
    Line(points = {{2, 0}, {24, 0}}, color = {0, 0, 255}));
  connect(GFL1.terminal, line1.terminal1) annotation(
    Line(points = {{-56, 0}, {-42, 0}}, color = {0, 0, 255}));
  connect(GFL2.terminal, line.terminal1) annotation(
    Line(points = {{63, 0}, {44, 0}}, color = {0, 0, 255}));
  connect(line22.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{2, -34}, {2, -48}}, color = {0, 0, 255}));
  connect(line22.terminal2, Bus.terminal) annotation(
    Line(points = {{2, -14}, {2, 0}}, color = {0, 0, 255}));
  connect(booleanTable.y, idealSwitch.control) annotation(
    Line(points = {{42, -36}, {46, -36}, {46, -4}, {-20, -4}}, color = {255, 0, 255}));
  connect(step1.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{-96, 10}, {-78, 10}, {-78, 8}}, color = {0, 0, 127}));
  connect(step2.y, GFL1.QFilterRefPu) annotation(
    Line(points = {{-96, -30}, {-90, -30}, {-90, -4}, {-78, -4}}, color = {0, 0, 127}));
  connect(step.y, GFL2.QFilterRefPu) annotation(
    Line(points = {{114, -10}, {102, -10}, {102, 4}, {86, 4}}, color = {0, 0, 127}));
  connect(step3.y, GFL2.PFilterRefPu) annotation(
    Line(points = {{110, -60}, {100, -60}, {100, -8}, {86, -8}}, color = {0, 0, 127}));
  connect(dynLine1.terminal2, idealSwitch.terminal1) annotation(
    Line(points = {{-40, -14}, {-30, -14}, {-30, -12}}, color = {0, 0, 255}));
  connect(idealSwitch.terminal2, line22.terminal2) annotation(
    Line(points = {{-10, -12}, {2, -12}, {2, -14}}, color = {0, 0, 255}));
  connect(dynLine1.terminal1, line22.terminal1) annotation(
    Line(points = {{-40, -34}, {2, -34}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.002),
    Diagram(coordinateSystem(extent = {{-80, 20}, {100, -60}})),
    Documentation(info = "<html><head></head><body>
    <p><b>GFL – Grid Following Converter Parameters:</b>Tunning D. Oscillations are found around 29hz for a Xgrid=0.07</p><ul>
</ul>

 <img width=\"900\" src=\"modelica://Dynawo/Examples/TwoConverters/tunningD_Roots.png\">
<br><br>


</body></html>"));
end TwoConverter_FixeLgrid_TunningD;
