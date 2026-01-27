within Dynawo.Examples.LimitStab;

model TwoConverter_LineGridRamp
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
  Electrical.Lines.DynLine line(LPu = 0.03375, P01Pu = 5, P02Pu = -4.94531238, Q01Pu = 0.21, Q02Pu = 0.56713991, RPu = 0.0005 + 0.001875, U01Pu = 1.04289359, U02Pu = 1.03733331, UPhase01 = 6.668423 * 3.14 / 180, UPhase02 = -2.278818 * 180 / 3.14) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.DynLine line1(LPu = 0.015 + 0.01875, P01Pu = -5, P02Pu = 5.05725313, Q01Pu = 0.21, Q02Pu = 0.60359717, RPu = 0.0005 + 0.001875, U01Pu = 1.01925978, U02Pu = 1.03733331, UPhase01 = -11.490041 * 3.14 / 180, UPhase02 = -2.278818 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.01925978, UPhase0 = -11.490041 * 3.14 / 180, tPFilt = 0.01, tQFilt = 0.01, tUFilt = 1 / 6283, tUqPLL = 1 / 6283, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL2(CFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.04289359, UPhase0 = 6.668423 * 3.14 / 180, tPFilt = 0.01, tQFilt = 0.01, tUFilt = 1 / 6283, tUqPLL = 1 / 6283, tVSC = 0.00004) annotation(
    Placement(transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(transformation(origin = {2, -48}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.DynLine_Ramp line22(L0Pu = 0.055, RampL0 = 0.002, P01Pu = 0.11901040, P02Pu = -0.11194076, Q01Pu = 1.24143346, Q02Pu = -1.17073708, R0Pu = 0.0055, U01Pu = 1.1, U02Pu = 1.03733331, UPhase01 = -0.04, UPhase02 = -2.278818 * 3.14 / 180) annotation(
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
    Documentation(

      info = "<html><head></head><body>

  <p>
  GFL models are DynGFL, lines are dynamic. The main objective is to find the
  limit of stability for line22.
  </p>

  <p>
  Initially, a line was connected in parallel and then disconnected, but this
  did not work for dynamic lines (it only works for non-dynamic lines).
  Therefore, a <b>dynamicLine</b> with a new line model that changes at
  <b>t = 1.5 s</b> using a ramp profile is used.
  </p>


<br>
<p><b>Time evolution of active power and line inductance:</b></p>
<br>

<img width=\"900\" src=\"modelica://Dynawo/Examples/LimitStab/TwoConverter_LineGridRamp_line.P1pu.png\">
<br><br>

<img width=\"900\" src=\"modelica://Dynawo/Examples/LimitStab/TwoConverter_LineGridRamp_line22.Lpu.png\">


  <p>
  An update of the initialization is performed using the following values:
  </p><p><b>Initialization A</b></p><p><b>============================</b></p>

  <p><b>Impedances:</b></p>
  <code>
  Z01 = (0.0005 + 0.001875) + j*(0.015 + 0.01875) = 0.002375 + j0.03375<br>
  Z02 = Z01<br>
  Z03 = 0.0055 + j0.055
  </code>

  <p><b>Power flow settings:</b></p>
  <code>
  V3_mag = 1.1<br>
  V3_ang = -0.04 * 180 / 3.14<br>
  P1 = +5, Q1 = +0.21<br>
  P2 = -5, Q2 = +0.21<br>
  P0 = 0.0, Q0 = 0.0
  </code>

  <p><b>Bus voltages:</b></p>
  <ul>
    <li>Bus 0: |V| = 1.0373 pu, θ = -2.279 deg</li>
    <li>Bus 1: |V| = 1.0429 pu, θ = 6.668 deg</li>
    <li>Bus 2: |V| = 1.0193 pu, θ = -11.49 deg</li>
    <li><b>Bus 3 (Slack): |V| = 1.10 pu, θ = -2.293 deg</b></li>
  </ul>

  <p><b>Line power flows (i → j):</b></p>
  <ul>
    <li>S0→1: P = -4.945 pu, Q = +0.567 pu</li>
    <li>S1→0: P = +5.000 pu, Q = +0.210 pu</li>
    <li>S0→2: P = +5.057 pu, Q = +0.604 pu</li>
    <li>S2→0: P = -5.000 pu, Q = +0.210 pu</li>
    <li>S0→3: P = -0.112 pu, Q = -1.171 pu</li>
    <li>S3→0: P = +0.119 pu, Q = +1.241 pu</li>
  </ul>

  <p><b>Network topology:</b></p>
  <code>
  bus 1 --(Z01)--\<br>
                  \<br>
  bus 2 --(Z02)---- bus 0 ----(Z03)---- bus 3 (SLACK)<br>
                  /<br>
               (junction)
  </code>






    <div><code><br></code></div><div><code><b>Tunning C</b></code></div><div><code><b>===============================</b></code></div><div><code><br></code></div><div><code><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>OuterLoop for P and Q:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kpd = 0.11</li><li>Kpq = 0.11</li><li>Kid = 50</li><li>Kiq = 50</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>PLL:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kp = 2</li><li>Ki =&nbsp;10</li></ul><div style=\"font-family: -webkit-standard;\"><br></div><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Current Control:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kpc = 0.5</li><li>Kic = 7</li><li><b>Kfd = 0</b></li><li><b>Kfq = 0</b></li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\">EMTP: (the values were directly changed and the mask values are not considered)</p><p style=\"font-family: -webkit-standard;\"><br></p><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Measurement and converter dynamics:</b></p><ul><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tPFilt = 1/100</b>&nbsp;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tQFilt = 1/100</b>&nbsp;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tVSC = 0.00004 emtp: 1/(22500*2*3.1416)&nbsp;</li><li><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tUqPLL =&nbsp;</b><font face=\"DejaVu Sans Mono\"><span style=\"font-size: 12px;\"><b>1 / 6283</b>&nbsp;</span></font></li><li><font face=\"DejaVu Sans Mono\"><font face=\"-webkit-standard\">tUfilt =&nbsp;</font>1 / 6283<font face=\"-webkit-standard\">&nbsp;</font></font></li></ul></code></div><div><code><br></code></div></body></html>"));
end TwoConverter_LineGridRamp;
