within Dynawo.Examples.LimitStab;

model OneDynGFLDynLine_TunningC
  extends Icons.Example;
  // Dynawo.Types.VoltageModulePu U1Pu;
  // Dynawo.Types.Angle UPhase1;
  // Dynawo.Types.VoltageModulePu U2Pu;
  // Dynawo.Types.Angle UPhase2;
  parameter Real modif1 = 1;
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.5, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0.01, offset = 0.021, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {-126, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus InfiniteBus(UNom = 400, UPhase = -0.04, UPu = 1.1) annotation(
    Placement(visible = true, transformation(origin = {102, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.1, offset = 0, startTime = 3) annotation(
    Placement(visible = true, transformation(origin = {-122, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-70, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(height = 0.01, offset = 0, startTime = 7) annotation(
    Placement(visible = true, transformation(origin = {-126, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-68, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step4(height = 0.1, offset = 0, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-120, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynLine dynLine(LPu = 0.05, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.005, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {62, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.01925978, UPhase0 = -11.490041 * 3.14 / 180, tPFilt = 0.01, tQFilt = 0.01, tUFilt = 1 / 6283, tUqPLL = 1 / 6283, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {1, 13}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
equation
  dynLine.switchOffSignal1.value = false;
  dynLine.switchOffSignal2.value = false;
  der(GFL1.omegaRefPu) = 0;
  GFL1.switchOffSignal1.value = false;
  GFL1.switchOffSignal2.value = false;
  GFL1.switchOffSignal3.value = false;
  dynLine.omegaPu.value = 1;
//  U1Pu = Modelica.ComplexMath.'abs'(GFL1.terminal.V);
// UPhase1 = Modelica.ComplexMath.arg(GFL1.terminal.V);
  connect(step2.y, add1.u1) annotation(
    Line(points = {{-114, -28}, {-96, -28}, {-96, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(step3.y, add1.u2) annotation(
    Line(points = {{-114, -64}, {-92, -64}, {-92, -32}, {-82, -32}}, color = {0, 0, 127}));
  connect(step.y, add3.u1) annotation(
    Line(points = {{-109, 80}, {-80, 80}, {-80, 36}}, color = {0, 0, 127}));
  connect(step1.y, add3.u3) annotation(
    Line(points = {{-110, 6}, {-80, 6}, {-80, 20}}, color = {0, 0, 127}));
  connect(step4.y, add3.u2) annotation(
    Line(points = {{-108, 42}, {-92, 42}, {-92, 28}, {-80, 28}}, color = {0, 0, 127}));
  connect(dynLine.terminal2, InfiniteBus.terminal) annotation(
    Line(points = {{72, 14}, {102, 14}, {102, 36}}, color = {0, 0, 255}));
  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{24, 14}, {52, 14}}, color = {0, 0, 255}));
  connect(add3.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{-56, 28}, {-22, 28}, {-22, 30}}, color = {0, 0, 127}));
  connect(add1.y, GFL1.QFilterRefPu) annotation(
    Line(points = {{-58, -26}, {-38, -26}, {-38, 4}, {-22, 4}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 100}, {120, -80}}), graphics = {Text(origin = {-121, -30}, extent = {{5, 0}, {-5, 0}}, textString = "text")}),
    Documentation(info = "<html><head></head><body><br><div>The stability limit is SCR=2, the tunning paramerters are taken from EMTP_based&nbsp;</div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12pt;\">&nbsp;</span></div><div><br></div><div><b>FeedForward is not activated</b></div><div><code><b><br></b></code></div><div><code><b>Tunning C</b></code></div><div><code><b>===============================</b></code></div><div><code><br></code></div><div><code><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>OuterLoop for P and Q:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kpd = 0.11</li><li>Kpq = 0.11</li><li>Kid = 50</li><li>Kiq = 50</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>PLL:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kp = 2</li><li>Ki =&nbsp;10</li></ul><div style=\"font-family: -webkit-standard;\"><br></div><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Current Control:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kpc = 0.5</li><li>Kic = 7</li><li><b>Kfd = 0</b></li><li><b>Kfq = 0</b></li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\">EMTP: (the values were directly changed and the mask values are not considered)</p><p style=\"font-family: -webkit-standard;\"><br></p><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Measurement and converter dynamics:</b></p><ul><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tPFilt = 1/100</b>&nbsp;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tQFilt = 1/100</b>&nbsp;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tVSC = 0.00004 emtp: 1/(22500*2*3.1416)&nbsp;</li><li><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tUqPLL =&nbsp;</b><font face=\"DejaVu Sans Mono\"><span style=\"font-size: 12px;\"><b>1 / 6283</b>&nbsp;(Why the tUqPLL is so fast , faster as tUfilt used in the CC control)</span></font></li><li><font face=\"DejaVu Sans Mono\"><font face=\"-webkit-standard\">tUfilt =&nbsp;</font>1 / 6283<font face=\"-webkit-standard\">&nbsp;</font></font></li></ul></code></div><div><br></div><br>

    </body></html>"));
end OneDynGFLDynLine_TunningC;
