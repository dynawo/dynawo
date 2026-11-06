within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model OuterLoopUControl

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
  parameter Types.VoltageModulePu UBoostHighPu "High voltage limit for reactiv power boost in pu";
  parameter Types.VoltageModulePu UBoostLowPu "Low voltage limit for reactiv power boost in pu";
  parameter Types.Time tBoost "Time constant of first-order filter on iqBoostPu in s to delay the reactive boost response. Set 0 to disable";
  parameter Types.Time tSid "Sample time of idRefPu ramp limiter in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference in pu (base SNom)" annotation(
    Placement(transformation(origin = {-240, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-214, 58}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput PLVPu(start = PInj0Pu) "Measured active power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-240, 38}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-216, 158}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = UFilter0Pu) annotation(
    Placement(transformation(origin = {-240, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-215, -59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu(start = UFilter0Pu) "Measured voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = Id0Pu) "d-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {230, 16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = -Iq0Pu) "q-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {230, -16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, -80}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup pIAntiWindupVariableLimitsd(Ki = Kid, Kp = Kpd, Y0 = Id0Pu, YMax = IMaxPu, YMin = -IMaxPu) annotation(
    Placement(transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup pIAntiWindupVariableLimitsq(Ki = Kiq, Kp = Kpq, Y0 = -Iq0Pu, YMax = IMaxPu, YMin = -IMaxPu) annotation(
    Placement(transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PControlFlag) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.CurrentLimiterReactiveBoost current_limiter_OuterLoop(IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, U0Pu = UFilter0Pu, tBoost = tBoost) annotation(
    Placement(transformation(origin = {121, -1}, extent = {{-41, -41}, {41, 41}})));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DidMax, DuMin = DidMin, tS = tSid, Y0 = Id0Pu, y(start = Id0Pu)) annotation(
    Placement(transformation(origin = {190, 14}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit Id0Pu "Initial d-axis current reference in pu (base SNom, UNom)";
  parameter Types.PerUnit Iq0Pu "Initial q-axis current reference in pu (base SNom, UNom)";
  parameter Types.ActivePowerPu PInj0Pu "Initial injected active power in pu (base SNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Initial injected reactive power in pu (base SNom)";
  parameter Types.VoltageModulePu UFilter0Pu "Initial filter voltage magnitude in pu (base UNom)";

equation
  connect(PLVPu, sum_node_p.u2) annotation(
    Line(points = {{-240, 38}, {-100, 38}, {-100, 72}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u2, ULVPu) annotation(
    Line(points = {{-82, 34}, {-140, 34}, {-140, -60}, {-240, -60}}, color = {230, 97, 0}, thickness = 0.75));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{1, 60}, {18, 60}}, color = {255, 0, 255}));
  connect(division1.y, switch1.u1) annotation(
    Line(points = {{-59, 40}, {11, 40}, {11, 68}, {18, 68}}, color = {230, 97, 0}, thickness = 0.75));
  connect(switch1.y, current_limiter_OuterLoop.idRawPu) annotation(
    Line(points = {{41, 60}, {59.5, 60}, {59.5, 15}, {76, 15}}, color = {0, 0, 127}));
  connect(current_limiter_OuterLoop.idLimPu, rampLimiter.u) annotation(
    Line(points = {{166, 15}, {178, 15}, {178, 14}}, color = {0, 0, 127}));
  connect(rampLimiter.y, idRefPu) annotation(
    Line(points = {{201, 14}, {230, 14}}, color = {0, 0, 127}));
  connect(iqRefPu, current_limiter_OuterLoop.iqLimPu) annotation(
    Line(points = {{230, -16}, {230, -17}, {166, -17}}, color = {0, 0, 127}));
  connect(PRefPu, sum_node_p.u1) annotation(
    Line(points = {{-240, 80}, {-108, 80}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u1, PRefPu) annotation(
    Line(points = {{-82, 46}, {-140, 46}, {-140, 80}, {-240, 80}}, color = {230, 97, 0}, thickness = 0.75));
  connect(URefPu, sum_node_q.u1) annotation(
    Line(points = {{-240, -20}, {-108, -20}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_q.u2, ULVPu) annotation(
    Line(points = {{-100, -28}, {-100, -60}, {-240, -60}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_q.y, pIAntiWindupVariableLimitsq.u) annotation(
    Line(points = {{-90, -20}, {-62, -20}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_p.y, pIAntiWindupVariableLimitsd.u) annotation(
    Line(points = {{-90, 80}, {-62, 80}}, color = {46, 194, 126}, thickness = 0.75));
  connect(pIAntiWindupVariableLimitsd.y, switch1.u3) annotation(
    Line(points = {{-38, 80}, {8, 80}, {8, 52}, {18, 52}}, color = {46, 194, 126}, thickness = 0.75));
  connect(pIAntiWindupVariableLimitsq.y, current_limiter_OuterLoop.iqRawPu) annotation(
    Line(points = {{-38, -20}, {76, -20}, {76, -18}}, color = {46, 194, 126}, thickness = 0.75));
  connect(ULVPu, current_limiter_OuterLoop.ULVPu) annotation(
    Line(points = {{-240, -60}, {40, -60}, {40, 0}, {76, 0}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-220, -200}, {220, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/Q/V control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "PI / Direct switchable")}),
    Diagram(coordinateSystem(extent = {{-220, -200}, {220, 200}})),
    Documentation(info = "<html><head></head><body><p><b>Author:</b> Gaia Bergamaschi</p>
      <p>Outer loop controller for a Grid-Following (GFL) converter.</p>
      <ul>
        <li><b>Green path (default):</b> anti-windup PI regulators for P and Q.</li>
        <li><b>Orange path:</b> stateless direct control — i_d = PRefPu/V, i_q = URefPu/V.</li>
      </ul>
      <p>Set <code>k_direct_control_p = true</code> and/or <code>k_direct_control_q = true</code>
      to bypass the PI on the corresponding axis. Useful when PI parameters are
      unknown or cause low-frequency oscillations (SSO).</p><p><br></p><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><!--StartFragment--><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">   Model   : Outer </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">loop</span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\"> controller </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">for</span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\"> a Grid-Following (GFL) converter.</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">  </span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">   Two control modes are available, selectable independently </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">for</span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\"> P </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">and</span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\"> Q:</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">     - PI mode (default, green):    error signal → PI regulator → current ref</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">     - Direct mode (orange):        PRefPu/V </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">or</span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\"> URefPu/V → current ref directly</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">  </span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">   Use direct mode </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">if</span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\"> the PI parameters are unknown </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">or</span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\"> cause instability.</span></pre><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">   k_direct_control_p = </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">false</span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#000000;\">  →  bypass P PI, use idRefPu = PRefPu / UMeasPu</span></pre><p>








</p><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   k_direct_control_q = </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">false</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  →  bypass Q PI, use i_q_ref = URefPu / UMeasPu</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Models the delay between the plant-level controller and this outer loop.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// A first-order filter with time constant tPlant is used.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Sum nodes (PRefPu - PMeasPu, URefPu - QMeasPu) ───────────────</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\">
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── PI controllers (green path, default) ─────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Anti-windup PI regulators. Active when k_direct_control_* = false.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Note: interaction between PI bandwidth and PLL is a known cause</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// of low-frequency SSO (Cheng et al. 2023, third mechanism).</span><!--EndFragment--></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"><br></span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\">

<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">    </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Direct path (orange path) ─────────────────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Stateless feedforward: idRefPu = PRefPu / UMeasPu</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">//                        i_q_ref = URefPu / UMeasPu</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Active when k_direct_control_* = true.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Useful for diagnostics when PI parameters are unknown or mistuned.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Mode switches ─────────────────────────────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// Modelica Switch: output = u1 if u2 is TRUE, else u3.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// u3 = direct path (orange), u1 = PI path (green).</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// So: k_direct_control_* = false  → direct, true → PI.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">    </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Current limiter with reactive boost ──────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">      </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\">// ── Output ramp limiter on idRefPu ────────────────────────────</span><!--EndFragment--></pre></pre></pre></pre>
    </body></html>"));
end OuterLoopUControl;
