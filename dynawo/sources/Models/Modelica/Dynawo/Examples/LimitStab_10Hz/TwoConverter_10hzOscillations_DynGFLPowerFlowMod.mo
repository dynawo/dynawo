within Dynawo.Examples.LimitStab_10Hz;

model TwoConverter_10hzOscillations_DynGFLPowerFlowMod

parameter Types.Time tOmegaEvtStart = 20;
  parameter Types.Time tOmegaEvtEnd = 21;
  parameter Types.Time tMagnitudeEvtstart = 6;
  parameter Types.Time tMagnitudeEvtEnd = 6.01;
  extends Modelica.Icons.Example;
  Electrical.Buses.Bus Bus annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line(RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875, GPu = 0, BPu = 0) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.0055, XPu = 0.055) annotation(
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
  Documentation(info = "<html><head></head><body>GFL models are DynGFL , line is not dynamic.&nbsp;<div>An updated of the initialisation is done with those values:<div style=\"background-color:#1e1f22;color:#bcbec4\"><pre style=\"font-family:'JetBrains Mono',monospace;font-size:9.8pt;\"><span style=\"color:#7a7e85;\"># Your exact impedances:<br></span>Z01 = (<span style=\"color:#2aacb8;\">0.0005 </span>+ <span style=\"color:#2aacb8;\">0.001875</span>) + <span style=\"color:#2aacb8;\">1j </span>* (<span style=\"color:#2aacb8;\">0.015 </span>+ <span style=\"color:#2aacb8;\">0.01875</span>)  <span style=\"color:#7a7e85;\"># 0.002375 + j0.03375<br></span>Z02 = Z01<br>Z03 = <span style=\"color:#2aacb8;\">0.0055 </span>+ <span style=\"color:#2aacb8;\">1j </span>* <span style=\"color:#2aacb8;\">0.055<br></span><span style=\"color:#2aacb8;\"><br></span>settings = StarPFSettings(<br>    <span style=\"color:#aa4926;\">Z01</span>=Z01, <span style=\"color:#aa4926;\">Z02</span>=Z02, <span style=\"color:#aa4926;\">Z03</span>=Z03,<br>    <span style=\"color:#aa4926;\">V3_mag</span>=<span style=\"color:#2aacb8;\">1.1</span>, <span style=\"color:#aa4926;\">V3_ang_deg</span>=-<span style=\"color:#2aacb8;\">0.04</span>*<span style=\"color:#2aacb8;\">180</span>/<span style=\"color:#2aacb8;\">3.14</span>,<br>    <span style=\"color:#aa4926;\">P1</span>=+<span style=\"color:#2aacb8;\">5</span>, <span style=\"color:#aa4926;\">Q1</span>=+<span style=\"color:#2aacb8;\">0.21</span>,<br>    <span style=\"color:#aa4926;\">P2</span>=-<span style=\"color:#2aacb8;\">5</span>, <span style=\"color:#aa4926;\">Q2</span>=+<span style=\"color:#2aacb8;\">0.21</span>,<br>    <span style=\"color:#aa4926;\">P0</span>=<span style=\"color:#2aacb8;\">0.0</span>, <span style=\"color:#aa4926;\">Q0</span>=<span style=\"color:#2aacb8;\">0.0</span>,<br></pre></div><div>Here the topology and the labels:</div><div><br></div><div><div style=\"background-color:#1e1f22;color:#bcbec4\"><pre style=\"font-family:'JetBrains Mono',monospace;font-size:9.8pt;\"><span style=\"color:#5f826b;font-style:italic;\">bus 1 --(Z01)--\<br></span><span style=\"color:#5f826b;font-style:italic;\">                \<br></span><span style=\"color:#5f826b;font-style:italic;\">bus 2 --(Z02)---- bus 0 ----(Z03)---- bus 3 (SLACK)<br></span><span style=\"color:#5f826b;font-style:italic;\">                /<br></span><span style=\"color:#5f826b;font-style:italic;\">       (junction)</span></pre></div></div></div></body></html>"));


end TwoConverter_10hzOscillations_DynGFLPowerFlowMod;
