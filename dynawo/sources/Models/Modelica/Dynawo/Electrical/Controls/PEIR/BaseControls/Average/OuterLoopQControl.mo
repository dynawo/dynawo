within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model OuterLoopQControl "Outer loop controller for a Grid-Following (GFL) converter"

  // Parameters
  parameter Types.PerUnit DidMax "Max rate of change of idRefPu in pu/s";
  parameter Types.PerUnit DidMin "Min rate of change of idRefPu in pu/s";
  parameter Types.PerUnit IqBoostMaxPu "Max reactive current boost in pu";
  parameter Types.PerUnit IqBoostMinPu "Min reactive current boost in pu";
  parameter Types.CurrentModulePu IMaxPu  "Maximum total current magnitude in pu";
  parameter Types.PerUnit Kpd "Proportional gain of d-axis PI in pu";
  parameter Types.PerUnit Kid "Integral gain of d-axis PI in pu/s";
  parameter Types.PerUnit Kpq "Proportional gain of q-axis PI in pu";
  parameter Types.PerUnit Kiq "Integral gain of q-axis PI in pu/s";
  parameter Types.PerUnit Kqv "Reactive boost boost gain  in pu/pu, 0 to disable";
  parameter Boolean PQFlag "Priority flag: true = P priority, false = Q priority";
  parameter Boolean PControlFlag "true: bypass P PI, use idRefPu = PRefPu/ULVPu | false: use PI regulator (default)";
  parameter Boolean QControlFlag "true: bypass Q PI, use i_q_ref = QRefPu/ULVPu | false: use PI regulator (default)";
  parameter Types.VoltageModulePu UBoostHighPu "High voltage limit for reactiv power boost in pu";
  parameter Types.VoltageModulePu UBoostLowPu "Low voltage limit for reactiv power boost in pu";
  parameter Types.Time tBoost "Time constant of first-order filter on iqBoostPu in s to delay the reactive boost response. Set 0 to disable";
  parameter Types.Time tPlant "Time constant of plant-to-outer-loop delay in s";
  parameter Types.Time tSid "Sample time of idRefPu ramp limiter in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference in pu (base SNom)" annotation(
    Placement(transformation(origin = {-240, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PLVPu(start = PInj0Pu) "Measured active power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-240, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, 160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QInj0Pu) "Reactive power reference in pu (base SNom)" annotation(
    Placement(transformation(origin = {-240, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput QLVPu(start = QInj0Pu) "Measured reactive power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-240, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, -160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu(start = UFilter0Pu) "Measured voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = Id0Pu) "d-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {230, 16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = -Iq0Pu) "q-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {230, -16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, -80}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-98, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}})));
  // ── PI controllers (green path, default) ─────────────────────
  /*Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupIntegral pIAntiWindupVariableLimitsd(tI = 1/Kid, Kp = Kpd, Y0 = Id0Pu, DyMax = 5, YMax = IMaxPu)  annotation(
    Placement(transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupIntegral pIAntiWindupVariableLimitsq(Y0 = -Iq0Pu, tI = 1/Kiq, Kp = Kpq, DyMax = 5, YMax = IMaxPu)  annotation(
    Placement(transformation(origin = {-48, -40}, extent = {{-10, -10}, {10, 10}})));*/
  //using the above model : pIAntiwindupIntegral gives different results when the DyMax limits are reached (that don't exist in the PIAntiWindup= and when the YMax is reached since it is only on the integral
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup pIAntiWindupVariableLimitsd(Ki = Kid, Kp = Kpd, Y0 = Id0Pu, YMax = IMaxPu, YMin = - IMaxPu)  annotation(
      Placement(transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}})));
    Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup pIAntiWindupVariableLimitsq(Y0 = -Iq0Pu, Ki = Kiq, Kp = Kpq, YMax = IMaxPu, YMin = - IMaxPu)  annotation(
      Placement(transformation(origin = {-48, -40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {-70, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(transformation(origin = {30, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PControlFlag) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = QControlFlag) annotation(
    Placement(transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.CurrentLimiterReactiveBoost current_limiter_outer_loop(IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, U0Pu = UFilter0Pu, tBoost = tBoost) annotation(
    Placement(transformation(origin = {120, 0}, extent = {{-40, -40}, {40, 40}})));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DidMax, DuMin = DidMin, tS = tSid, Y0 = Id0Pu, y(start = Id0Pu)) annotation(
    Placement(transformation(origin = {190, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tPlant, y_start = PInj0Pu, y(start = PInj0Pu)) annotation(
    Placement(transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tPlant) annotation(
    Placement(transformation(origin = {-170, -40}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit Id0Pu "Initial d-axis current reference in pu (base SNom, UNom)";
  parameter Types.PerUnit Iq0Pu "Initial q-axis current reference in pu (base SNom, UNom)";
  parameter Types.ActivePowerPu PInj0Pu "Initial injected active power in pu (base SNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Initial injected reactive power in pu (base SNom)";
  parameter Types.VoltageModulePu UFilter0Pu "Initial filter voltage magnitude in pu (base UNom)";

equation
  connect(PLVPu, sum_node_p.u2) annotation(
    Line(points = {{-240, 40}, {-98, 40}, {-98, 72}}, color = {46, 194, 126}, thickness = 0.75));
  connect(QLVPu, sum_node_q.u2) annotation(
    Line(points = {{-240, -80}, {-100, -80}, {-100, -48}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u2, ULVPu) annotation(
    Line(points = {{-82, 34}, {-120, 34}, {-120, 0}, {-240, 0}}, color = {230, 97, 0}, thickness = 0.75));
  connect(division.u2, ULVPu) annotation(
    Line(points = {{-82, -106}, {-120, -106}, {-120, 0}, {-240, 0}}, color = {230, 97, 0}, thickness = 0.75));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{1, 60}, {18, 60}}, color = {255, 0, 255}));
  connect(division1.y, switch1.u1) annotation(
    Line(points = {{-59, 40}, {8.5, 40}, {8.5, 68}, {18, 68}}, color = {230, 97, 0}, thickness = 0.75));
  connect(booleanConstant1.y, switch2.u2) annotation(
    Line(points = {{1, -60}, {18, -60}}, color = {255, 0, 255}));
  connect(division.y, switch2.u1) annotation(
    Line(points = {{-59, -100}, {11, -100}, {11, -52}, {17, -52}}, color = {230, 97, 0}, thickness = 0.75));
  connect(switch1.y, current_limiter_outer_loop.idRawPu) annotation(
    Line(points = {{41, 60}, {60.5, 60}, {60.5, 16}, {76, 16}}, color = {0, 0, 127}));
  connect(current_limiter_outer_loop.idLimPu, rampLimiter.u) annotation(
    Line(points = {{164, 16}, {178, 16}}, color = {0, 0, 127}));
  connect(rampLimiter.y, idRefPu) annotation(
    Line(points = {{201, 16}, {230, 16}}, color = {0, 0, 127}));
  connect(iqRefPu, current_limiter_outer_loop.iqLimPu) annotation(
    Line(points = {{230, -16}, {164, -16}}, color = {0, 0, 127}));
  connect(PRefPu, firstOrder.u) annotation(
    Line(points = {{-240, 80}, {-182, 80}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum_node_p.u1) annotation(
    Line(points = {{-158, 80}, {-106, 80}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u1, firstOrder.y) annotation(
    Line(points = {{-82, 46}, {-140, 46}, {-140, 80}, {-158, 80}}, color = {230, 97, 0}, thickness = 0.75));
  connect(QRefPu, firstOrder1.u) annotation(
    Line(points = {{-240, -40}, {-182, -40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, sum_node_q.u1) annotation(
    Line(points = {{-159, -40}, {-108, -40}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division.u1, firstOrder1.y) annotation(
    Line(points = {{-82, -94}, {-82, -93}, {-145, -93}, {-145, -39.5}, {-159, -39.5}, {-159, -40}}, color = {230, 97, 0}, thickness = 0.75));
  connect(sum_node_q.y, pIAntiWindupVariableLimitsq.u) annotation(
    Line(points = {{-91, -40}, {-60, -40}}, color = {46, 194, 126}, thickness = 0.75));
  connect(pIAntiWindupVariableLimitsq.y, switch2.u3) annotation(
    Line(points = {{-37, -40}, {8, -40}, {8, -68}, {17, -68}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_p.y, pIAntiWindupVariableLimitsd.u) annotation(
    Line(points = {{-89, 80}, {-62, 80}}, color = {46, 194, 126}, thickness = 0.75));
  connect(pIAntiWindupVariableLimitsd.y, switch1.u3) annotation(
    Line(points = {{-38, 80}, {12, 80}, {12, 52}, {18, 52}}, color = {46, 194, 126}, thickness = 0.75));
  connect(switch2.y, current_limiter_outer_loop.iqRawPu) annotation(
    Line(points = {{42, -60}, {60, -60}, {60, -16}, {76, -16}}, color = {0, 0, 127}));
  connect(ULVPu, current_limiter_outer_loop.ULVPu) annotation(
    Line(points = {{-240, 0}, {76, 0}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-220, -200}, {220, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/Q/V control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "PI / Direct switchable")}),
    Diagram(coordinateSystem(extent = {{-220, -200}, {220, 200}})),
    Documentation(info = "<html><head></head><body><p><b>Author:</b> Gaia Bergamaschi</p>
      <p>Outer loop controller for a Grid-Following (GFL) converter.</p>
      <ul>
        <li><b>Green path (default):</b> anti-windup PI regulators for P and Q.</li>
        <li><b>Orange path:</b> stateless direct control — i_d = PRefPu/V, i_q = QRefPu/V.</li>
      </ul>
      <p>Set <code>k_direct_control_p = true</code> and/or <code>k_direct_control_q = true</code>
      to bypass the PI on the corresponding axis. Useful when PI parameters are
      unknown or cause low-frequency oscillations (SSO).</p><p><span style=\"color: rgb(0, 150, 0); font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">Two control modes are available, selectable independently for P and Q:</span></p><p><span style=\"color: rgb(0, 150, 0); font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">&nbsp; &nbsp;- PI mode (default, green):    error signal → PI regulator → current ref</span></p><p><span style=\"color: rgb(0, 150, 0); font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">&nbsp; &nbsp;- Direct mode (orange):        PRefPu/V or QRefPu/V → current ref directly</span></p><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"color: rgb(0, 150, 0); font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> Use direct mode if the PI parameters are unknown or cause instability.</span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"> k_direct_control_p = false  →  bypass P PI, use idRefPu = PRefPu / ULVPu</span></pre><p>





</p><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"> k_direct_control_q = false  →  bypass Q PI, use iqRefPu = QRefPu / ULVPu</span><!--EndFragment--></pre><p><br></p><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><!--StartFragment--><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Plant communication delay ─────────────────────────────────</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Models the delay between the plant-level controller and this outer loop.</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// A first-order filter with time constant tPlant is used.</span></pre><p>



</p><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Sum nodes (PRefPu - PLVPu, QRefPu - QLVPu) ───────────────</span><!--EndFragment--></pre><p><br></p><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><!--StartFragment--><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── PI controllers (green path, default) ─────────────────────</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Anti-windup PI regulators. Active when k_direct_control_* = false.</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Note: interaction between PI bandwidth and PLL is a known cause</span></pre><p>



</p><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// of low-frequency SSO (Cheng et al. 2023, third mechanism).</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Direct path (orange path) ─────────────────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Stateless feedforward: idRefPu = PRefPu / ULVPu</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">//                        iqRefPu = QRefPu / ULVPu</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Active when k_direct_control_* = true.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Useful for diagnostics when PI parameters are unknown or mistuned.</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Mode switches ─────────────────────────────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Modelica Switch: output = u1 if u2 is TRUE, else u3.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// u3 = direct path (orange), u1 = PI path (green).</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// So: k_direct_control_* = false  → direct, true → PI.</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\">
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Current limiter with reactive boost ──────────────────────</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\">

<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Output ramp limiter on idRefPu ────────────────────────────</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre></pre></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre></pre>
    </body></html>"));
end OuterLoopQControl;
