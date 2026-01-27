within Dynawo.Examples.LimitStab_10Hz;

model TwoConverter_10hzOscillations_DynGFL_DynLinePowerFlowMod

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

  Electrical.Lines.DynLine line(LPu = 0.03375, P01Pu = 5, P02Pu = -4.94531238, Q01Pu = 0.21, Q02Pu = 0.56713991, RPu = 0.0005 + 0.001875, U01Pu = 1.04289359, U02Pu = 1.03733331, UPhase01 = 6.668423 * 3.14 / 180, UPhase02 = -2.278818 * 180 / 3.14)
   annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.DynLine line1(LPu = 0.015 + 0.01875, P01Pu = -5, P02Pu = 5.05725313, Q01Pu = 0.21, Q02Pu = 0.60359717, RPu = 0.0005 + 0.001875, U01Pu = 1.01925978, U02Pu = 1.03733331, UPhase01 = -11.490041 * 3.14 / 180, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.DynLine line2(LPu = 0.055, P01Pu = 0.11901040, P02Pu = -0.11194076, Q01Pu = 1.24143346, Q02Pu = -1.17073708, RPu = 0.0055, U01Pu = 1.1, U02Pu = 1.03733331, UPhase01 = -0.04, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {2, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1( CFilterPu = 1e-5,Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.01925978, UPhase0 = -11.490041 * 3.14 / 180, tPFilt = 0.01, tQFilt = 0.01, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL2( CFilterPu = 1e-5,Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.04289359, UPhase0 = 6.668423 * 3.14 / 180, tPFilt = 0.01, tQFilt = 0.01, tVSC = 0.00004) annotation(
    Placement(transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {2, -48}, extent = {{-10, -10}, {10, 10}})));
equation
// No switch-off of the lines
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  //omega for dynamic Lines
   line.omegaPu.value = 1;
  line1.omegaPu.value = 1;
  line2.omegaPu.value = 1;


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
  connect(line2.terminal2, Bus.terminal) annotation(
    Line(points = {{2, -10}, {2, 0}}, color = {0, 0, 255}));
  connect(Bus.terminal, line.terminal2) annotation(
    Line(points = {{2, 0}, {24, 0}}, color = {0, 0, 255}));
  connect(GFL1.terminal, line1.terminal1) annotation(
    Line(points = {{-56, 0}, {-42, 0}}, color = {0, 0, 255}));
  connect(GFL2.terminal, line.terminal1) annotation(
    Line(points = {{63, 0}, {44, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{2, -30}, {2, -48}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.002),
    Diagram(coordinateSystem(extent = {{-80, 20}, {100, -60}})),
  Documentation(info = "<html><head></head><body>GFL models are DynGFL, lines are dynamic, and an updated of the initialisation is done with those values:<div style=\"background-color: rgb(30, 31, 34); color: rgb(188, 190, 196);\"><pre style=\"font-family: 'JetBrains Mono', monospace; font-size: 9.8pt;\"><span style=\"color: rgb(122, 126, 133);\"># Your exact impedances:<br></span>Z01 = (<span style=\"color: rgb(42, 172, 184);\">0.0005 </span>+ <span style=\"color: rgb(42, 172, 184);\">0.001875</span>) + <span style=\"color: rgb(42, 172, 184);\">1j </span>* (<span style=\"color: rgb(42, 172, 184);\">0.015 </span>+ <span style=\"color: rgb(42, 172, 184);\">0.01875</span>)  <span style=\"color: rgb(122, 126, 133);\"># 0.002375 + j0.03375<br></span>Z02 = Z01<br>Z03 = <span style=\"color: rgb(42, 172, 184);\">0.0055 </span>+ <span style=\"color: rgb(42, 172, 184);\">1j </span>* <span style=\"color: rgb(42, 172, 184);\">0.055<br></span><span style=\"color: rgb(42, 172, 184);\"><br></span>settings = StarPFSettings(<br>    <span style=\"color: rgb(170, 73, 38);\">Z01</span>=Z01, <span style=\"color: rgb(170, 73, 38);\">Z02</span>=Z02, <span style=\"color: rgb(170, 73, 38);\">Z03</span>=Z03,<br>    <span style=\"color: rgb(170, 73, 38);\">V3_mag</span>=<span style=\"color: rgb(42, 172, 184);\">1.1</span>, <span style=\"color: rgb(170, 73, 38);\">V3_ang_deg</span>=-<span style=\"color: rgb(42, 172, 184);\">0.04</span>*<span style=\"color: rgb(42, 172, 184);\">180</span>/<span style=\"color: rgb(42, 172, 184);\">3.14</span>,<br>    <span style=\"color: rgb(170, 73, 38);\">P1</span>=+<span style=\"color: rgb(42, 172, 184);\">5</span>, <span style=\"color: rgb(170, 73, 38);\">Q1</span>=+<span style=\"color: rgb(42, 172, 184);\">0.21</span>,<br>    <span style=\"color: rgb(170, 73, 38);\">P2</span>=-<span style=\"color: rgb(42, 172, 184);\">5</span>, <span style=\"color: rgb(170, 73, 38);\">Q2</span>=+<span style=\"color: rgb(42, 172, 184);\">0.21</span>,<br>    <span style=\"color: rgb(170, 73, 38);\">P0</span>=<span style=\"color: rgb(42, 172, 184);\">0.0</span>, <span style=\"color: rgb(170, 73, 38);\">Q0</span>=<span style=\"color: rgb(42, 172, 184);\">0.0</span>,<br></pre></div><div><br></div><div><br></div><div><p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">Those values are important for Dynamic lines initialisation:</span></p><p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\"><br></span></p><p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">=== Bus Voltages ===</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">Bus 0: |V|=1.03733331 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
theta=-2.278818 deg, V= 1.03651295-0.04124685j</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">Bus 1: |V|=1.04289359 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
theta= 6.668423 deg, V= 1.03583820+0.12110431j</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">Bus 2: |V|=1.01925978 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
theta=-11.490041 deg, V= 0.99883315-0.20303410j</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri; font-weight: bold;\">Bus 3: |V|=1.10000000 </span><span style=\"font-size: 11pt; font-family: Calibri; font-weight: bold;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri; font-weight: bold;\">,
theta=-2.292994 </span><span style=\"font-size: 11pt; font-family: Calibri;\">deg,
V= 1.09911922-0.04401057j</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">=== Line Flows S(</span><span style=\"font-size: 11pt; font-family: Calibri;\">i</span><span style=\"font-size: 11pt; font-family: Calibri;\">-&gt;j)
===</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">S0-&gt;1: P=-4.94531238 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
Q=+0.56713991 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">S1-&gt;0: P=+5.00000000 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
Q=+0.21000000 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">S0-&gt;2: P=+5.05725313 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
Q=+0.60359717 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">S2-&gt;0: P=-5.00000000 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
Q=+0.21000000 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">S0-&gt;3: P=-0.11194076 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
Q=-1.17073708 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span></p>

<p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\">S3-&gt;0: P=+0.11901040 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span><span style=\"font-size: 11pt; font-family: Calibri;\">,
Q=+1.24143346 </span><span style=\"font-size: 11pt; font-family: Calibri;\">pu</span></p><p style=\"margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;\"><span style=\"font-size: 11pt; font-family: Calibri;\"><br></span></p></div><div>Here the topology and the labels:</div><div><br></div><div><div style=\"background-color: rgb(30, 31, 34); color: rgb(188, 190, 196);\"><pre style=\"font-family: 'JetBrains Mono', monospace; font-size: 9.8pt;\"><span style=\"color: rgb(95, 130, 107); font-style: italic;\">bus 1 --(Z01)--\<br></span><span style=\"color: rgb(95, 130, 107); font-style: italic;\">                \<br></span><span style=\"color: rgb(95, 130, 107); font-style: italic;\">bus 2 --(Z02)---- bus 0 ----(Z03)---- bus 3 (SLACK)<br></span><span style=\"color: rgb(95, 130, 107); font-style: italic;\">                /<br></span><span style=\"color: rgb(95, 130, 107); font-style: italic;\">       (junction)</span></pre><pre style=\"font-family: 'JetBrains Mono', monospace; font-size: 9.8pt;\"><br></pre></div></div></body></html>"));


end TwoConverter_10hzOscillations_DynGFL_DynLinePowerFlowMod;
