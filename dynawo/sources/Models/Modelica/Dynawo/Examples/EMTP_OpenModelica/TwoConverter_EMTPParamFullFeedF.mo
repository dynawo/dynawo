within Dynawo.Examples.EMTP_OpenModelica;

model TwoConverter_EMTPParamFullFeedF
  parameter Types.Time tOmegaEvtStart = 20;
  parameter Types.Time tOmegaEvtEnd = 21;
  parameter Types.Time tMagnitudeEvtstart = 3;
  parameter Types.Time tMagnitudeEvtEnd = 3.01;
  extends Modelica.Icons.Example;
  Electrical.Buses.Bus Bus annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Electrical.Lines.DynLine line(XPu = 0.03375, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0005 + 0.001875, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04)
  //Electrical.Lines.DynLine line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875)
  // Electrical.Lines.DynLine line2(BPu = 0, GPu = 0, RPu = 0.0055, XPu = 0.055)
  Electrical.Lines.DynLine line(LPu = 0.03375, P01Pu = 5, P02Pu = -4.94531238, Q01Pu = 0.21, Q02Pu = 0.56713991, RPu = 0.003375, U01Pu = 1.04289359, U02Pu = 1.03733331, UPhase01 = 6.668423 * 3.14 / 180, UPhase02 = -2.278818 * 180 / 3.14) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.DynLine line1(LPu = 0.03375, P01Pu = -5, P02Pu = 5.05725313, Q01Pu = 0.21, Q02Pu = 0.60359717, RPu = 0.003375, U01Pu = 1.01925978, U02Pu = 1.03733331, UPhase01 = -11.490041 * 3.14 / 180, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 2.197, Kid = 25, Kiq = 25, Kp = 2, Kpc = 0.209, Kpd = 0.1, Kpq = 0.1, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 111, tQFilt = 1 / 111, tVSC = 1 / 22500) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL2(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 2.197, Kid = 25, Kiq = 25, Kp = 2, Kpc = 0.209, Kpd = 0.1, Kpq = 0.1, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.1072, UPhase0 = 0.098, tPFilt = 1 / 111, tQFilt = 1 / 111, tVSC = 1 / 22500)  annotation(
    Placement(transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {2, -48}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.DynLine_Ramp line22(L0Pu = 0.012 / 2, P01Pu = 0.11901040, P02Pu = -0.11194076, Q01Pu = 1.24143346, Q02Pu = -1.17073708, R0Pu = 0.0012 / 2, RampL0 = 0.001, U01Pu = 1.1, U02Pu = 1.03733331, UPhase01 = -0.04, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {2, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
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
  der(GFL1.PFilterRefPu) = 0;
  der(GFL1.QFilterRefPu) = 0;
  der(GFL1.omegaRefPu) = 0;
  der(GFL2.PFilterRefPu) = 0;
  der(GFL2.QFilterRefPu) = 0;
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
  connect(line22.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{2, -34}, {2, -48}}, color = {0, 0, 255}));
  connect(line22.terminal2, Bus.terminal) annotation(
    Line(points = {{2, -14}, {2, 0}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.002),
    Diagram(coordinateSystem(extent = {{-80, 20}, {100, -60}})),
    Documentation(info = "<html><head></head><body>
    <p><b>GFL2 – Grid Following Converter Parameters</b></p>

<p>When The feedforward is activated the model does not simulate anymore. In the paper \"Impact of Converters Fast Control Loops on Power System Stability and Slow &nbsp;Modes\", a comparison between No Voltage feedforward (NVF) and Full Voltage FeedF <b>(FVF) showing that FVF is more stable than NVF</b></p><p><b>difficult to find oscillations in this simulation !!</b></p><p><b>Rated values and operating point:</b></p>
<ul>
  <li>SNom = 1000</li>
  <li>U0Pu = 1.01925978</li>
  <li>UPhase0 = -11.490041 * 3.14 / 180</li>
  <li>P0Pu = 5</li>
  <li>Q0Pu = -0.21</li>
</ul>

<p><b>Frequency limits:</b></p>
<ul>
  <li>OmegaMaxPu = 1.1</li>
  <li>OmegaMinPu = 0.9</li>
</ul>

<p><b>Filter and transformer parameters (pu):</b></p>
<ul>
  <li>RFilterPu = 0.003</li>
  <li>LFilterPu = 0.1</li>
  <li>CFilterPu = 1e-5</li>
  <li>RTransformerPu = 0.002</li>
  <li>LTransformerPu = 0.05</li>
</ul>

<p><b>OuterLoop for P and Q:</b></p>
<ul>
  <li>Kpd = 0.1</li>
  <li>Kpq = 0.1</li>
  <li>Kid = 25</li>
  <li>Kiq = 25</li>
</ul>

<p><b>PLL:</b></p>
<ul>
  <li>Kp = 2</li>
  <li>Ki = 10</li>
</ul>

<p><b>Current Control:</b></p>
<ul>
  <li>Kpc = 0.18</li>
  <li>Kic = 1.87</li>
  <li><b>Kfd = 1</b></li>
  <li><b>Kfq = 1</b></li>
</ul>

<p><b>Measurement and converter dynamics:</b></p>
<ul>
  <li>tPFilt = 0.01</li>
  <li>tQFilt = 0.01</li>
  <li>tVSC = 0.00004</li>
</ul>

</body></html>"));
end TwoConverter_EMTPParamFullFeedF;
