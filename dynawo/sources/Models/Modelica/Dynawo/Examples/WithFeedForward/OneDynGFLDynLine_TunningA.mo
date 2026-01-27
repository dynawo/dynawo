within Dynawo.Examples.WithFeedForward;

model OneDynGFLDynLine_TunningA
  extends Icons.Example;
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 2.1972, Kid = 25, Kiq = 25, Kp = 2, Kpc = 0.20981, Kpd = 0.1, Kpq = 0.1, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 111, tQFilt = 1 / 111, tUFilt = 1 / 6283, tUqPLL = 1 / 111, tVSC = 1 / (22500 * 2 * 3.1416)) annotation(
    Placement(visible = true, transformation(origin = {0, 12}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
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
  Dynawo.Electrical.Lines.DynLine dynLine(LPu = 0.03, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.003, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {62, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  connect(add1.y, GFL1.QFilterRefPu) annotation(
    Line(points = {{-58, -26}, {-42, -26}, {-42, 4}, {-20, 4}}, color = {0, 0, 127}));
  connect(step2.y, add1.u1) annotation(
    Line(points = {{-114, -28}, {-96, -28}, {-96, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(step3.y, add1.u2) annotation(
    Line(points = {{-114, -64}, {-92, -64}, {-92, -32}, {-82, -32}}, color = {0, 0, 127}));
  connect(step.y, add3.u1) annotation(
    Line(points = {{-109, 80}, {-80, 80}, {-80, 36}}, color = {0, 0, 127}));
  connect(step1.y, add3.u3) annotation(
    Line(points = {{-110, 6}, {-80, 6}, {-80, 20}}, color = {0, 0, 127}));
  connect(add3.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{-56, 28}, {-20, 28}, {-20, 26}}, color = {0, 0, 127}));
  connect(step4.y, add3.u2) annotation(
    Line(points = {{-108, 42}, {-92, 42}, {-92, 28}, {-80, 28}}, color = {0, 0, 127}));
  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{20, 12}, {52, 12}, {52, 14}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, InfiniteBus.terminal) annotation(
    Line(points = {{72, 14}, {102, 14}, {102, 36}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 100}, {120, -80}}), graphics = {Text(origin = {-121, -30}, extent = {{5, 0}, {-5, 0}}, textString = "text")}),
    Documentation(info = "<html><head></head><body>SCR=3.33<div>The stability limit is even lower SCR=3.33 compared to the tunning obtained from equations (SCR=1.25).tuning here are from EMTP based parameters.</div><div>The tunning paramerters are taken from EMTP_based&nbsp;</div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12pt;\">&nbsp;</span></div><div><b><font size=\"6\">EMTP_based tunning (tunning A):</font></b></div><div><b>FeedForward is activated</b></div><div><b><br></b></div><div><b>SCRmin=3.33 (used for the comparison)</b></div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></b></div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Rated values and operating point:</b></div><ul style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><li>SNom = 1000</li><li>P0pu=5</li><li>Q0pu=-0.21</li></ul><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>Frequency limits:</b></p><ul style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><li>OmegaMaxPu = 1.1</li><li>OmegaMinPu = 0.9</li></ul><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>Filter and transformer parameters (pu):</b></p><ul style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><li>RFilterPu = 0.003</li><li>LFilterPu = 0.1</li><li>CFilterPu = 1e-5</li><li>RTransformerPu = 0.002</li><li>LTransformerPu = 0.05</li></ul><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>OuterLoop for P and Q:</b></p><ul style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><li>Kpd = 0.1</li><li>Kpq = 0.1</li><li>Kid = 25</li><li>Kiq = 25</li></ul><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">EMTP:</p><p><font face=\"DejaVu Sans Mono\">PCntrl_ki=25;</font></p><p><font face=\"DejaVu Sans Mono\">PCntrl_kp=0.1;</font></p><p><font face=\"DejaVu Sans Mono\">QCntrl_ki=25;</font></p><p></p><p><font face=\"DejaVu Sans Mono\">QCntrl_kp=0.1;</font></p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b><br></b></p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>PLL:</b></p><ul style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><li>Kp = 2</li><li>Ki = 10</li></ul><div><font face=\"DejaVu Sans Mono\">EMTP:&nbsp;</font></div><div><br></div><div>Kp = 2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;// Kp : fixed proportional gain</div><div>Ki &nbsp;= 10 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // Ki : &nbsp;fixed integral gain</div><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>Current Control:</b></p><ul style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><li>Kpc = 0.20981</li><li>Kic = 2.1972</li><li><b>Kfd = 1</b></li><li><b>Kfq = 1</b></li></ul><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">EMTP:</p><p><font face=\"DejaVu Sans Mono\">GridCtrl_ki=2.197225126642364;</font></p><p></p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"></p><ul></ul><p></p><p style=\"color: rgb(0, 0, 0); font-family: -webkit-standard; font-style: normal; font-variant-caps: normal; letter-spacing: normal; orphans: auto; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0.4); -webkit-text-stroke-width: 0px;\"><font face=\"DejaVu Sans Mono\">GridCtrl_kp=0.20981953525203;</font></p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>Measurement and converter dynamics:</b></p><ul><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tPFilt = 1/111 wf_dq_PQV_cal=111.05530030439918;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tQFilt = 1/111 wf_dq_PQV_cal=111.05530030439918;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tVSC = 1/(22500*2*3.1416)&nbsp;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tUqPLL = 1/111&nbsp;wf_dq_pll=111.05530030439918;</li><li><font face=\"DejaVu Sans Mono\">tUfilt = 1 / 6283&nbsp;wf_dq_grid=6283.185307179586;</font></li></ul><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div>

    <img width=\"900\" src=\"modelica://Dynawo/Examples/EMTP_OM/Qfilter_SCR3_33.png\">
<br><br>

    </body></html>"));
end OneDynGFLDynLine_TunningA;
