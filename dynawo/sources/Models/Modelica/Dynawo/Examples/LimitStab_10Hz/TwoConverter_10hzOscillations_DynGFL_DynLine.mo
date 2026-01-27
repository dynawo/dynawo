within Dynawo.Examples.LimitStab_10Hz;

model TwoConverter_10hzOscillations_DynGFL_DynLine

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

  Electrical.Lines.DynLine line(LPu = 0.03375, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0005 + 0.001875, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04)
   annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.DynLine line1(LPu = 0.015 + 0.01875, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0005 + 0.001875, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.DynLine line2(LPu = 0.055, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0055, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {2, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Types.VoltageModulePu U1Pu;
  Types.Angle UPhase1;
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1( CFilterPu = 1e-5,Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 0.01, tQFilt = 0.01, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL2( CFilterPu = 1e-5,Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.1072, UPhase0 = 0.098, tPFilt = 0.01, tQFilt = 0.01, tVSC = 0.00004) annotation(
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
  Documentation(info = "<html><head></head><body><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">GFL models are DynGFL, lines are dynamic, and an updated of the initialisation isnot done. That's why the results are really bad at the beginning for instance the reactive power output at GFL2 goes further than 10 pu (Snconv) as shown in the figure (values are in Snref). A better initialisation is presented in the model&nbsp;</span>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12pt;\">TwoConverter_10hzOscillations_DynGFL_DynLinePowerFlowMod</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12pt;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12pt;\"><br></span></pre>

<figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/EMTP_OM/TwoConverter_10hzOscillations_DynGFL_DynLine_Line_Q1.png\">
    </figure>
</body></html>"));


end TwoConverter_10hzOscillations_DynGFL_DynLine;
