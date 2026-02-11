within Dynawo.Examples.WithFeedForward;

model TwoConverter_FixeLgrid_TunningE_v2
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
  Electrical.Lines.DynLine line(LPu = 0.0144, P01Pu = 5, P02Pu = -4.96, Q01Pu = 0.21, Q02Pu = 0.127, RPu = 0.00144, U01Pu = 1.019, U02Pu = 1.0257, UPhase01 = -6.85 / 180 * 3.14, UPhase02 = -2.89 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.DynLine line1(LPu = 0.0144, P01Pu = -5, P02Pu = 5.034, Q01Pu = 0.21, Q02Pu = 0.137, RPu = 0.00144, U01Pu = 1.019, U02Pu = 1.025, UPhase01 = -6.85 * 3.14 / 180, UPhase02 = -2.89 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;




  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1( CFilterPu = 1 / 1e5, Kfd = 1, Kfq = 1, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.3819, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5,Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000,  U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 300, tPQFilt = 1 / 111.055, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 / 2000, tVSC = 1 / (2 *2.5e3)) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL2(CFilterPu = 1 / 1e5, Kfd = 1, Kfq = 1, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.3819, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9,    P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.1072, UPhase0 = 0.098, tPFilt = 1 / 300, tPQFilt = 1 / 111.055, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 / 2000, tVSC = 1 / (2 *2.5e3))  annotation(
    Placement(transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.1, UEvtPu = 1.14, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = -1.8, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(visible = true, transformation(origin = {2, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0, offset = 0.021, startTime = 40) annotation(
    Placement(visible = true, transformation(origin = {-126, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0, offset = 0.021, startTime = 40) annotation(
    Placement(visible = true, transformation(origin = {142, 2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynLine line22(LPu = 0.03, P01Pu = 0.07, P02Pu = -0.06, Q01Pu = 0.28, Q02Pu = -0.26,  RPu = 0.003,U01Pu = 1.1, U02Pu = 1.025, UPhase01 = -2.29 * 3.14 / 180, UPhase02 = -2.89 * 3.14 / 180) annotation(
    Placement(visible = true, transformation(origin = {2, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
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
  //der(GFL1.QFilterRefPu) = 0;
  der(GFL1.omegaRefPu) = 0;
  der(GFL2.PFilterRefPu) = 0;
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
    Line(points = {{-114, 4}, {-96, 4}, {-96, -4}, {-78, -4}}, color = {0, 0, 127}));
  connect(GFL2.QFilterRefPu, step.y) annotation(
    Line(points = {{86, 4}, {106, 4}, {106, 2}, {132, 2}}, color = {0, 0, 127}));
  connect(line22.terminal2, Bus.terminal) annotation(
    Line(points = {{2, -12}, {2, 0}}, color = {0, 0, 255}));
  connect(line22.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{2, -32}, {2, -48}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.002),
    Diagram(coordinateSystem(extent = {{-80, 20}, {100, -60}})),
    Documentation(info = "<html><head></head><body>
    <p><b>GFL – Grid Following Converter Parameters:</b>Tunning E</p><p>QfilterRef as set to 0.021 with a source otherwise when i 've set der(Q)=0 in steady state it did not took the , Q0 value 0.021 instead it took 0.031, it was observed when SCR=20</p><p>Here The line22 is static</p><p><br></p><p>tunningB+&nbsp;<b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tUqPLL = 1/2000</b><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">&nbsp;</span></p><p><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></span></p><p><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Initialisation was improved.</span></p><p><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></span></p><p><b>=== Bus Voltages ===</b></p><p><b>Bus 0: |V|=1.02574616 pu, theta=-2.890174 deg, V= 1.02444143-0.05171982j</b></p><p><b>Bus 1: |V|=1.03329117 pu, theta= 0.988618 deg, V= 1.03313735+0.01782818j</b></p><p><b>Bus 2: |V|=1.01919271 pu, theta=-6.855929 deg, V= 1.01190493-0.12166429j</b></p><p><b>Bus 3: |V|=1.10000000 pu, theta=-2.292994 deg, V= 1.09911922-0.04401057j</b></p><p><b><br></b></p><p><b>=== Bus Injections (generator convention: + into network) ===</b></p><p><b>Bus 0: P=+0.00000000 pu, Q=-0.00000000 pu</b></p><p><b>Bus 1: P=+5.00000000 pu, Q=+0.21000000 pu</b></p><p><b>Bus 2: P=-5.00000000 pu, Q=+0.21000000 pu</b></p><p><b>Bus 3: P=+0.07048816 pu, Q=+0.28488159 pu</b></p><p><b><br></b></p><p><b>=== Line Flows S(i-&gt;j) ===</b></p><p><b>S0-&gt;1: P=-4.96622289 pu, Q=+0.12777110 pu</b></p><p><b>S1-&gt;0: P=+5.00000000 pu, Q=+0.21000000 pu</b></p><p><b>S0-&gt;2: P=+5.03471805 pu, Q=+0.13718048 pu</b></p><p><b>S2-&gt;0: P=-5.00000000 pu, Q=+0.21000000 pu</b></p><p><b>S0-&gt;3: P=-0.06849516 pu, Q=-0.26495158 pu</b></p><p><b></b></p><p><b>S3-&gt;0: P=+0.07048816 pu, Q=+0.28488159 pu</b></p><div><b><br></b></div><p><br></p>

</body></html>"));
end TwoConverter_FixeLgrid_TunningE_v2;
