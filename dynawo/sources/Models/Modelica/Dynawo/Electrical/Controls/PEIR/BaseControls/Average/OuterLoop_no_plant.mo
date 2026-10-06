within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;



model OuterLoop_no_plant
  // =============================================================================
  // Author  : Gaia Bergamaschi
  // Model   : Outer loop controller for a Grid-Following (GFL) converter.
  //
  // Two control modes are available, selectable independently for P and Q:
  //   - PI mode (default, green):    error signal → PI regulator → current ref
  //   - Direct mode (orange):        PRefPu/V or U_ref/V → current ref directly
  //
  // Use direct mode if the PI parameters are unknown or cause instability.
  // k_direct_control_p = false  →  bypass P PI, use idRefPu = PRefPu / UMeasPu
  // k_direct_control_q = false  →  bypass Q PI, use i_q_ref = U_ref / UMeasPu
  // =============================================================================
  // ── Inputs ───────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) annotation(
    Placement(transformation(origin = {-220, 82}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-214, 58}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput PMeasPu(start = PInj0Pu) annotation(
    Placement(transformation(origin = {-220, 52}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-216, 158}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput U_ref(start = UFilter0Pu) annotation(
    Placement(transformation(origin = {-220, 18}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-215, -59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput UMeasPu(start = UFilter0Pu) annotation(
    Placement(transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
  // ── Plant communication delay ─────────────────────────────────
  // Models the delay between the plant-level controller and this outer loop.
  // A first-order filter with time constant tPlant is used.
  // ── Sum nodes (PRefPu - PMeasPu, U_ref - QMeasPu) ───────────────
  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-88, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-74, 20}, extent = {{-10, -10}, {10, 10}})));
  // ── PI controllers (green path, default) ─────────────────────
  // Anti-windup PI regulators. Active when k_direct_control_* = false.
  // Note: interaction between PI bandwidth and PLL is a known cause
  // of low-frequency SSO (Cheng et al. 2023, third mechanism).
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupIntegral pi_controller_antiwind(Kp = Kpd, tI = 1/Kid, Y0 = y_start_outer_d, DyMax = DyMaxd, YMax = IMaxPu) annotation(
    Placement(transformation(origin = {-28, 82}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupIntegral pi_controller_antiwind1(Kp = Kpq, tI = 1/(Kiq), Y0 = -y_start_outer_q, DyMax = DyMaxq, YMax = IMaxPu) annotation(
    Placement(transformation(origin = {-24, 20}, extent = {{-20, -20}, {20, 20}})));
  // ── Direct path (orange path) ─────────────────────────────────
  // Stateless feedforward: idRefPu = PRefPu / UMeasPu
  //                        i_q_ref = U_ref / UMeasPu
  // Active when k_direct_control_* = true.
  // Useful for diagnostics when PI parameters are unknown or mistuned.
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-66, 42}, extent = {{-10, -10}, {10, 10}})));
  // ── Mode switches ─────────────────────────────────────────────
  // Modelica Switch: output = u1 if u2 is TRUE, else u3.
  // u3 = direct path (orange), u1 = PI path (green).
  // So: k_direct_control_* = false  → direct, true → PI.
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {34, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PControlFlag) annotation(
    Placement(transformation(origin = {6, 70}, extent = {{-6, -6}, {6, 6}})));
  // ── Current limiter with reactive boost ──────────────────────
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.CurrentLimiterReactiveBoost current_limiter_OuterLoop(IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, U0Pu = UFilter0Pu, tBoost = tBoost) annotation(
    Placement(transformation(origin = {129, 47}, extent = {{-39, -39}, {39, 39}})));
  // ── Output ramp limiter on idRefPu ────────────────────────────
  NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DidMax, DuMin = DidMin, tS = tSid, Y0 = idRef0Pu, y(start = idRef0Pu)) annotation(
    Placement(transformation(origin = {192, 62}, extent = {{-10, -10}, {10, 10}})));
  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = idRef0Pu) annotation(
    Placement(transformation(origin = {224, 62}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {225, 59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealOutput i_q_ref(start = -iqRef0Pu) annotation(
    Placement(transformation(origin = {210, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {225, -23}, extent = {{-15, -15}, {15, 15}})));
  // ── Parameters ───────────────────────────────────────────────
  // Control mode selection
  parameter Boolean PControlFlag "true: bypass P PI, use idRefPu = PRefPu/UMeasPu | false: use PI regulator (default)";
  parameter Boolean QControlFlag "true: bypass Q PI, use i_q_ref = U_ref/UMeasPu | false: use PI regulator (default)";
  // PI tuning — d axis (active power)
  parameter Real Kpd "Proportional gain of d-axis PI (pu)";
  parameter Real Kid "Integral gain of d-axis PI (pu/s)";
  parameter Real DyMaxd "Max rate of change of d-axis PI output (pu/s)";
  parameter Real y_start_outer_d "Initial output of d-axis PI (pu)";
  // PI tuning — q axis (reactive power)
  parameter Real Kpq "Proportional gain of q-axis PI (pu)";
  parameter Real Kiq "Integral gain of q-axis PI (pu/s)";
  parameter Real DyMaxq "Max rate of change of q-axis PI output (pu/s)";
  parameter Real y_start_outer_q "Initial output of q-axis PI (pu)";
  // Current limiter
  parameter Real IMaxPu "Maximum total current magnitude (pu)";
  parameter Boolean PQFlag "Priority flag: true = P priority, false = Q priority";
  parameter Real UBoostHighPu "High voltage threshold for reactive boost (pu)";
  parameter Real UBoostLowPu "Low voltage threshold for reactive boost (pu)";
  parameter Real Kqv "Reactive boost gain (pu)";
  parameter Real IqBoostMaxPu "Maximum reactive current boost (pu)";
  parameter Real IqBoostMinPu "Minimum reactive current boost (pu)";
  // Output ramp limiter on idRefPu
  parameter Real DidMax "Max rate of change of idRefPu (pu/s)";
  parameter Real DidMin "Min rate of change of idRefPu (pu/s)";
  parameter Real tSid "Sample time of idRefPu ramp limiter (s)";
  // Initial conditions
  parameter Real PInj0Pu "Initial injected active power (pu)";
  parameter Real QInj0Pu "Initial injected reactive power (pu)";
  parameter Real UFilter0Pu "Initial filter voltage magnitude (pu)";
  parameter Real idRef0Pu "Initial d-axis current reference (pu)";
  parameter Real iqRef0Pu "Initial q-axis current reference (pu)";
    parameter Real tBoost
    "Time constant of first-order filter on iqBoostPu (s) to delay the reactive boost response. Set 0 to disable";
equation
// ── P path ───────────────────────────────────────────────────
  connect(PMeasPu, sum_node_p.u2) annotation(
    Line(points = {{-220, 52}, {-88, 52}, {-88, 74}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_p.y, pi_controller_antiwind.u) annotation(
    Line(points = {{-79, 82}, {-50, 82}}, color = {46, 194, 126}, thickness = 0.75));
// ── Q path ───────────────────────────────────────────────────
  connect(sum_node_q.y, pi_controller_antiwind1.u) annotation(
    Line(points = {{-65, 20}, {-46, 20}}, color = {46, 194, 126}, thickness = 0.75));
// ── Direct path: PRefPu/V (orange) ────────────────────────────
  connect(division1.u2, UMeasPu) annotation(
    Line(points = {{-78, 36}, {-190, 36}, {-190, -60}, {-220, -60}}, color = {230, 97, 0}, thickness = 0.75));
// ── Direct path: U_ref/V (orange) ────────────────────────────
// ── Switch d: u1=direct(true), u3=PI(false) ──────────────────
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{22, 74}, {13, 74}, {13, 70}}, color = {255, 0, 255}));
  connect(division1.y, switch1.u1) annotation(
    Line(points = {{-55, 42}, {22, 42}, {22, 82}}, color = {230, 97, 0}, thickness = 0.75));
  connect(pi_controller_antiwind.y, switch1.u3) annotation(
    Line(points = {{-6, 82}, {22, 82}, {22, 66}}, color = {46, 194, 126}, thickness = 0.75));
// ── Switch q: u1=direct(true), u3=PI(false) ──────────────────
// ── Switch outputs → current limiter ─────────────────────────
  connect(switch1.y, current_limiter_OuterLoop.id_raw) annotation(
    Line(points = {{46, 74}, {46, 62}, {86, 62}}, color = {0, 0, 127}));
// ── UMeasPu → current limiter ──────────────────────────────────
  connect(UMeasPu, current_limiter_OuterLoop.UMeasPu) annotation(
    Line(points = {{-220, -60}, {86, -60}, {86, 27.5}}, color = {0, 0, 127}));
// ── Current limiter → ramp limiter → idRefPu ─────────────────
  connect(current_limiter_OuterLoop.idLimPu, rampLimiter.u) annotation(
    Line(points = {{172, 62}, {180, 62}}, color = {0, 0, 127}));
  connect(rampLimiter.y, idRefPu) annotation(
    Line(points = {{203, 62}, {224, 62}}, color = {0, 0, 127}));
// ── Current limiter → i_q_ref ────────────────────────────────
  connect(i_q_ref, current_limiter_OuterLoop.iqLimPu) annotation(
    Line(points = {{210, 32}, {172, 31}}, color = {0, 0, 127}));
  connect(PRefPu, sum_node_p.u1) annotation(
    Line(points = {{-220, 82}, {-96, 82}}, color = {0, 0, 127}));
  connect(division1.u1, PRefPu) annotation(
    Line(points = {{-78, 48}, {-178, 48}, {-178, 82}, {-220, 82}}, color = {0, 0, 127}));
  connect(pi_controller_antiwind1.y, current_limiter_OuterLoop.iq_raw) annotation(
    Line(points = {{-2, 20}, {42, 20}, {42, 44}, {86, 44}, {86, 44}}, color = {0, 0, 127}));
  connect(U_ref, sum_node_q.u1) annotation(
    Line(points = {{-220, 18}, {-84, 18}, {-84, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(sum_node_q.u2, UMeasPu) annotation(
    Line(points = {{-74, 12}, {-70, 12}, {-70, -60}, {-220, -60}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/Q/V control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "PI / Direct switchable")}),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}}), graphics = {Text(origin = {-5, -118}, extent = {{-147, 38}, {147, -38}}, textString = "Author: Gaia Bergamaschi
Model of the outer loop of a GFL converter.
Green path (default): PI regulators for P and Q.
Orange path: direct control via PRefPu/V and U_ref/V.
k_direct_control_p/q = false → PI (default)
k_direct_control_p/q = true  → direct (bypass PI)")}),
    Documentation(info = "<html>
      <p><b>Author:</b> Gaia Bergamaschi</p>
      <p>Outer loop controller for a Grid-Following (GFL) converter.</p>
      <ul>
        <li><b>Green path (default):</b> anti-windup PI regulators for P and Q.</li>
        <li><b>Orange path:</b> stateless direct control — i_d = PRefPu/V, i_q = U_ref/V.</li>
      </ul>
      <p>Set <code>k_direct_control_p = true</code> and/or <code>k_direct_control_q = true</code>
      to bypass the PI on the corresponding axis. Useful when PI parameters are
      unknown or cause low-frequency oscillations (SSO).</p>
    </html>"));



end OuterLoop_no_plant;
