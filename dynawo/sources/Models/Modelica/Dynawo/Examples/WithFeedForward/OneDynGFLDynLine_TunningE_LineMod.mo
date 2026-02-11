within Dynawo.Examples.WithFeedForward;

model OneDynGFLDynLine_TunningE_LineMod
  extends Icons.Example;
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1 (CFilterPu = 1 / 10e10, Kfd = 1, Kfq = 1, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.3819, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 300, tPQFilt = 1 / 111.055, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 / 2000, tVSC = 1 / (2 *2.5e3)) annotation(
    Placement(visible = true, transformation(origin = {0, 14}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  // Dynawo.Types.VoltageModulePu U1Pu;
  // Dynawo.Types.Angle UPhase1;
  // Dynawo.Types.VoltageModulePu U2Pu;
  // Dynawo.Types.Angle UPhase2;
  parameter Real modif1 = 1;
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.5, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0.01, offset = 0.021, startTime = 8) annotation(
    Placement(visible = true, transformation(origin = {-126, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus InfiniteBus(UNom = 400, UPhase = -0.04, UPu = 1.1) annotation(
    Placement(visible = true, transformation(origin = {102, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.1, offset = 0, startTime = 6) annotation(
    Placement(visible = true, transformation(origin = {-122, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-70, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(height = 0.01, offset = 0, startTime = 10) annotation(
    Placement(visible = true, transformation(origin = {-126, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-62, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step4(height = 0.1, offset = 0, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-120, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {52, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  der(GFL1.omegaRefPu) = 0;
  GFL1.switchOffSignal1.value = false;
  GFL1.switchOffSignal2.value = false;
  GFL1.switchOffSignal3.value = false;
  //dynLine.omegaPu.value = 1;
//  U1Pu = Modelica.ComplexMath.'abs'(GFL1.terminal.V);
// UPhase1 = Modelica.ComplexMath.arg(GFL1.terminal.V);
  connect(add1.y, GFL1.QFilterRefPu) annotation(
    Line(points = {{-58, -26}, {-42, -26}, {-42, 7}, {-20, 7}}, color = {0, 0, 127}));
  connect(step.y, add3.u1) annotation(
    Line(points = {{-109, 80}, {-74, 80}, {-74, 36}}, color = {0, 0, 127}));
  connect(add3.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{-51, 28}, {-20, 28}}, color = {0, 0, 127}));
  connect(step3.y, add1.u2) annotation(
    Line(points = {{-114, -64}, {-92, -64}, {-92, -32}, {-82, -32}}, color = {0, 0, 127}));
  connect(step2.y, add1.u1) annotation(
    Line(points = {{-114, -28}, {-96, -28}, {-96, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(step1.y, add3.u3) annotation(
    Line(points = {{-110, 6}, {-74, 6}, {-74, 20}}, color = {0, 0, 127}));
  connect(step4.y, add3.u2) annotation(
    Line(points = {{-108, 42}, {-92, 42}, {-92, 28}, {-74, 28}}, color = {0, 0, 127}));
  connect(GFL1.terminal, line1.terminal2) annotation(
    Line(points = {{20, 14}, {42, 14}, {42, 12}}, color = {0, 0, 255}));
  connect(line1.terminal1, InfiniteBus.terminal) annotation(
    Line(points = {{62, 12}, {102, 12}, {102, 36}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 100}, {120, -80}}), graphics = {Text(origin = {-121, -30}, extent = {{5, 0}, {-5, 0}}, textString = "text")}),
    Documentation(info = "<html><head></head><body><div><br></div><div><b><font size=\"6\">Improved tunning (tunning D)</font></b></div><div><b>FeedForward is activated:</b></div><div><b><font size=\"4\">Heritage from tunningB but with a difference:</font></b></div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tUqPLL = 1/2000 instead of 1/300 (tunningB)</b></div><div><font face=\"DejaVu Sans Mono\"><b>tPQFilter = 1 / 111.055 (from emtp) that value cannot be changed in emtp therefore we have to heritate it</b></font></div><div><b><font size=\"4\"><br></font></b></div><div><b><font size=\"4\">SCRmin=</font></b></div><div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></b></div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Rated values and operating point:</b></div><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>SNom = 1000</li><li>P0pu=5</li><li>Q0pu=-0.21</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Frequency limits:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>OmegaMaxPu = 1.1</li><li>OmegaMinPu = 0.9</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Filter and transformer parameters (pu):</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>RFilterPu = 0.003</li><li>LFilterPu = 0.1</li><li>CFilterPu = 1e-5</li><li>RTransformerPu = 0.002</li><li>LTransformerPu = 0.05</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>OuterLoop for P and Q:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kpd = 0.033</li><li>Kpq = 0.033</li><li>Kid = 10</li><li>Kiq = 10</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\">EMTP:</p><p><font face=\"DejaVu Sans Mono\">PCntrl_ki=10;</font></p><p><font face=\"DejaVu Sans Mono\">PCntrl_kp=0.033;</font></p><p><font face=\"DejaVu Sans Mono\">QCntrl_ki=10;</font></p><p></p><p><font face=\"DejaVu Sans Mono\">QCntrl_kp=0.033;</font></p><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b><br></b></p><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>PLL:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kp =&nbsp;0.318</li><li>Ki =&nbsp;7.95</li></ul><div><font face=\"DejaVu Sans Mono\">EMTP:&nbsp;</font></div><div><br></div><div><div><br></div><div>Kp = 0.318 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;// Kp : fixed proportional gain</div><div>Ki &nbsp;= 7.95 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // Ki : &nbsp;fixed integral gain</div></div><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Current Control:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kpc = 0.3819</li><li>Kic = 3.6</li><li><b>Kfd = 1</b></li><li><b>Kfq = 1</b></li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\">EMTP: (the values were directly changed and the mask values are not considered)</p><p><br></p><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Measurement and converter dynamics:</b></p><ul><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tPFilt = 1/300</b> 0.0033&nbsp;(raw value is coded);</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tQFilt = 1/300</b>&nbsp;0.0033&nbsp;(raw value is coded);</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tVSC = 1/(22500*2*3.1416)&nbsp;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tUqPLL = 1/2000</b>&nbsp;</li><li><font face=\"DejaVu Sans Mono\">tUfilt = 1 / 6283&nbsp;wf_dq_grid=6283.185307179586;</font></li></ul><div><br></div></div><br>

     <img width=\"900\" src=\"modelica://Dynawo/Examples/WithFeedForward/Q_SCCR20_tunningE.png\">
<br><br>


</body></html>"),
  experiment(StartTime = 0, StopTime = 50, Tolerance = 1e-6, Interval = 0.001));
end OneDynGFLDynLine_TunningE_LineMod;
