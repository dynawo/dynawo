within Dynawo.Examples.WithFeedForward;

model OneDynGFLDynLine_TunningB
  extends Icons.Example;
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 7.95, Kic = 3.6, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.3819, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 300, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 / 300, tVSC = 1 / (22500 * 2 * 3.1416)) annotation(
    Placement(visible = true, transformation(origin = {0, 12}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  // Dynawo.Types.VoltageModulePu U1Pu;
  // Dynawo.Types.Angle UPhase1;
  // Dynawo.Types.VoltageModulePu U2Pu;
  // Dynawo.Types.Angle UPhase2;
  Dynawo.Electrical.Lines.DynLine dynLine(LPu = 0.05, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.005, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {60, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Real modif1 = 1;
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.5, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0.01, offset = 0.021, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-126, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus InfiniteBus(UNom = 400, UPhase = -0.04, UPu = 1.1) annotation(
    Placement(visible = true, transformation(origin = {102, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.1, offset = 0, startTime = 3) annotation(
    Placement(visible = true, transformation(origin = {-122, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-70, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(height = 0.01, offset = 0, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {-126, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-68, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step4(height = 0.1, offset = 0, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-120, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{20, 12}, {35, 12}, {35, 14}, {50, 14}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, InfiniteBus.terminal) annotation(
    Line(points = {{70, 14}, {102, 14}, {102, 36}}, color = {0, 0, 255}));
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
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 100}, {120, -80}}), graphics = {Text(origin = {-121, -30}, extent = {{5, 0}, {-5, 0}}, textString = "text")}),
    Documentation(info = "<html><head></head><body><div><br></div><div><b><font size=\"6\">Improved tunning (tunning B)</font></b></div><div><b><font size=\"6\">FeedForward is activated:</font></b></div><div><b><font size=\"6\"><br></font></b></div><div><b><font size=\"4\">SCR=2 used for the comparison</font></b></div><div><b><font size=\"4\">SCRmin=1.25</font></b></div><div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></b></div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Rated values and operating point:</b></div><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>SNom = 1000</li><li>P0pu=5</li><li>Q0pu=-0.21</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Frequency limits:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>OmegaMaxPu = 1.1</li><li>OmegaMinPu = 0.9</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Filter and transformer parameters (pu):</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>RFilterPu = 0.003</li><li>LFilterPu = 0.1</li><li>CFilterPu = 1e-5</li><li>RTransformerPu = 0.002</li><li>LTransformerPu = 0.05</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>OuterLoop for P and Q:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kpd = 0.033</li><li>Kpq = 0.033</li><li>Kid = 10</li><li>Kiq = 10</li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\">EMTP:</p><p><font face=\"DejaVu Sans Mono\">PCntrl_ki=10;</font></p><p><font face=\"DejaVu Sans Mono\">PCntrl_kp=0.033;</font></p><p><font face=\"DejaVu Sans Mono\">QCntrl_ki=10;</font></p><p></p><p><font face=\"DejaVu Sans Mono\">QCntrl_kp=0.033;</font></p><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b><br></b></p><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>PLL:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kp =&nbsp;0.318</li><li>Ki =&nbsp;7.95</li></ul><div><font face=\"DejaVu Sans Mono\">EMTP:&nbsp;</font></div><div><br></div><div><div><br></div><div>Kp = 0.318 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;// Kp : fixed proportional gain</div><div>Ki &nbsp;= 7.95 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // Ki : &nbsp;fixed integral gain</div></div><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Current Control:</b></p><ul style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><li>Kpc = 0.3819</li><li>Kic = 3.6</li><li><b>Kfd = 1</b></li><li><b>Kfq = 1</b></li></ul><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\">EMTP: (the values were directly changed and the mask values are not considered)</p><p><br></p><p style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><b>Measurement and converter dynamics:</b></p><ul><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tPFilt = 1/300</b> 0.0033&nbsp;(raw value is coded);</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tQFilt = 1/300</b>&nbsp;0.0033&nbsp;(raw value is coded);</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">tVSC = 1/(22500*2*3.1416)&nbsp;</li><li style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>tUqPLL = 1/300</b>&nbsp;0.0033 (raw value is coded)</li><li><font face=\"DejaVu Sans Mono\">tUfilt = 1 / 6283&nbsp;wf_dq_grid=6283.185307179586;</font></li></ul><div><br></div><div><br></div></div><div><br></div>The tunning of the GFL was by considering this:<div><br></div><div><div style=\"background-color:#1e1f22;color:#bcbec4\"><pre style=\"font-family:'JetBrains Mono',monospace;font-size:9.8pt;\"><span style=\"color:#cf8e6d;\">import </span>math<br><br><span style=\"color:#7a7e85;\"># =========================<br></span><span style=\"color:#7a7e85;\"># INPUTS<br></span><span style=\"color:#7a7e85;\"># =========================<br></span><span style=\"color:#7a7e85;\"><br></span><span style=\"color:#7a7e85;\"># Filter / transformer<br></span>Rfilter = <span style=\"color:#2aacb8;\">0.003<br></span>Lfilter = <span style=\"color:#2aacb8;\">0.1<br></span>Ltransfo = <span style=\"color:#2aacb8;\">0.05      </span><span style=\"color:#7a7e85;\"># pu Ltransfo + Lfiltre<br></span>Rtransfo = <span style=\"color:#2aacb8;\">0.002    </span><span style=\"color:#7a7e85;\"># pu Rtransfo + rfiltre<br></span><span style=\"color:#7a7e85;\"><br></span><span style=\"color:#7a7e85;\"># Base values<br></span>fn = <span style=\"color:#2aacb8;\">50              </span><span style=\"color:#7a7e85;\"># nominal frequency in Hz<br></span>fb = fn<br>wb = <span style=\"color:#2aacb8;\">2 </span>* math.pi * fb  <span style=\"color:#7a7e85;\"># nominal angunar frequency in rad/s<br></span><span style=\"color:#7a7e85;\"><br></span><span style=\"color:#7a7e85;\"># PLL<br></span>wn_PLL = <span style=\"color:#2aacb8;\">50         </span><span style=\"color:#7a7e85;\"># rad/s (PLL bandwidth)<br></span>zeta_PLL = <span style=\"color:#2aacb8;\">1<br></span><span style=\"color:#2aacb8;\"><br></span><span style=\"color:#7a7e85;\"># Current loop<br></span>wn_i = <span style=\"color:#2aacb8;\">1200          </span><span style=\"color:#7a7e85;\"># rad/s (current loop bandwidth)<br></span>zeta_i = <span style=\"color:#2aacb8;\">1<br></span>Kffi = <span style=\"color:#2aacb8;\">1<br></span><span style=\"color:#2aacb8;\"><br></span><span style=\"color:#7a7e85;\"># Outer loop<br></span>w_P = <span style=\"color:#2aacb8;\">10             </span><span style=\"color:#7a7e85;\"># rad/s (P control bandwidth)<br></span>w_V = <span style=\"color:#2aacb8;\">50             </span><span style=\"color:#7a7e85;\"># rad/s (Q control bandwidth)<br></span>w_LPF = <span style=\"color:#2aacb8;\">300          </span><span style=\"color:#7a7e85;\"># rad/s (LPF bandwidth)<br></span><span style=\"color:#7a7e85;\"><br></span><span style=\"color:#7a7e85;\"># =========================<br></span><span style=\"color:#7a7e85;\"># COMPUTATIONS<br></span><span style=\"color:#7a7e85;\"># =========================<br></span><span style=\"color:#7a7e85;\"><br></span><span style=\"color:#7a7e85;\"># PLL gains<br></span>Kp_PLL = <span style=\"color:#2aacb8;\">2 </span>* zeta_PLL * wn_PLL / wb<br>Ki_PLL = wn_PLL**<span style=\"color:#2aacb8;\">2 </span>/ wb<br><br><span style=\"color:#7a7e85;\"># Current controller gains<br></span><span style=\"color:#7a7e85;\">#Tunning method: Placement of poles is not used<br></span><span style=\"color:#7a7e85;\"># Pole-Compensated PI Controller for Grid-Following Converter<br></span><span style=\"color:#7a7e85;\"># This code computes Kp and Ki for a current controller given desired bandwidth and filter parameters.<br></span><span style=\"color:#7a7e85;\"><br></span>Ki_i = Rfilter * wn_i<br>Kp_i = (Lfilter / wb) * wn_i<br><br><span style=\"color:#7a7e85;\"># Outer loop gains<br></span>Kp_p = w_P / w_LPF<br>Ki_p = w_P<br><br>Kp_q = w_P / w_LPF<br>Ki_q = w_P</pre></div></div>

       <div>SCR=2</div><div>====================</div><div><br></div><img width=\"900\" src=\"modelica://Dynawo/Examples/WithFeedForward/P_SCCR2_tunningB.png\">
<br><br>

       <img width=\"900\" src=\"modelica://Dynawo/Examples/WithFeedForward/Q_SCCR2_tunningB.png\">
<br><br>SCR=20<div>========================</div><div><br>

       <img width=\"900\" src=\"modelica://Dynawo/Examples/WithFeedForward/P_SCCR20_tunningB.png\">
<br><br>

       <img width=\"900\" src=\"modelica://Dynawo/Examples/WithFeedForward/Q_SCCR20_tunningB.png\">
<br><br>

</div></body></html>"));
end OneDynGFLDynLine_TunningB;
