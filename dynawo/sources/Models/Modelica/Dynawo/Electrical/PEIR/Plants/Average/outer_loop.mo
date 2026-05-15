within Dynawo.Electrical.PEIR.Plants.Average;

model outer_loop
  // =============================================================================
  // Author  : Gaia Bergamaschi
  // Model   : Outer loop controller for a Grid-Following (GFL) converter.
  //
  // Two control modes are available, selectable independently for P and Q:
  //   - PI mode (default, green):    error signal → PI regulator → current ref
  //   - Direct mode (orange):        P_ref/V or Q_ref/V → current ref directly
  //
  // Use direct mode if the PI parameters are unknown or cause instability.
  // k_direct_control_p = false  →  bypass P PI, use i_d_ref = P_ref / V_meas
  // k_direct_control_q = false  →  bypass Q PI, use i_q_ref = Q_ref / V_meas
  // =============================================================================
  // ── Inputs ───────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput P_ref(start = PInjPu0) annotation(
    Placement(transformation(origin = {-220, 82}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-214, 58}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput P_meas(start = PInjPu0) annotation(
    Placement(transformation(origin = {-220, 52}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-216, 158}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput Q_ref(start = QInjPu0) annotation(
    Placement(transformation(origin = {-220, 18}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-215, -59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput Q_meas(start = QInjPu0) annotation(
    Placement(transformation(origin = {-220, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-217, -161}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput V_meas(start = U_filter0) annotation(
    Placement(transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
  // ── Plant communication delay ─────────────────────────────────
  // Models the delay between the plant-level controller and this outer loop.
  // A first-order filter with time constant delay_time_plant is used.
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k = 1, T = delay_time_plant, y_start = PInjPu0, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(transformation(origin = {-148, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k = 1, y_start = QInjPu0, T = delay_time_plant, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(transformation(origin = {-148, 18}, extent = {{-10, -10}, {10, 10}})));
  // ── Sum nodes (P_ref - P_meas, Q_ref - Q_meas) ───────────────
  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-88, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-74, 20}, extent = {{-10, -10}, {10, 10}})));
  // ── PI controllers (green path, default) ─────────────────────
  // Anti-windup PI regulators. Active when k_direct_control_* = false.
  // Note: interaction between PI bandwidth and PLL is a known cause
  // of low-frequency SSO (Cheng et al. 2023, third mechanism).
  Controls.PEIR.BaseControls.Average.pi_controller_antiwind pi_controller_antiwind(k_p = k_p_d, tI = 1/k_i_d, y_start = y_start_outer_d, DyMax = DyMax_pi_d, YMax = Imax) annotation(
    Placement(transformation(origin = {-28, 82}, extent = {{-20, -20}, {20, 20}})));
  Controls.PEIR.BaseControls.Average.pi_controller_antiwind pi_controller_antiwind1(k_p = k_p_q, tI = 1/(k_i_q), y_start = -y_start_outer_q, DyMax = DyMax_pi_q, YMax = Imax) annotation(
    Placement(transformation(origin = {-24, 20}, extent = {{-20, -20}, {20, 20}})));
  // ── Direct path (orange path) ─────────────────────────────────
  // Stateless feedforward: i_d_ref = P_ref / V_meas
  //                        i_q_ref = Q_ref / V_meas
  // Active when k_direct_control_* = true.
  // Useful for diagnostics when PI parameters are unknown or mistuned.
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-66, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {-50, -36}, extent = {{-10, -10}, {10, 10}})));
  // ── Mode switches ─────────────────────────────────────────────
  // Modelica Switch: output = u1 if u2 is TRUE, else u3.
  // u3 = direct path (orange), u1 = PI path (green).
  // So: k_direct_control_* = false  → direct, true → PI.
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {34, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(transformation(origin = {42, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = k_direct_control_p) annotation(
    Placement(transformation(origin = {6, 70}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = k_direct_control_q) annotation(
    Placement(transformation(origin = {13, 11}, extent = {{-5, -5}, {5, 5}})));
  // ── Current limiter with reactive boost ──────────────────────
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.current_limiter_reactive_boost current_limiter_outer_loop(Imax = Imax, PQFlag = PQFlag, UboostHigh = UboostHigh, UboostLow = UboostLow, Kqv = Kqv, IqBoostMax = IqBoostMax, IqBoostMin = IqBoostMin) annotation(
    Placement(transformation(origin = {129, 47}, extent = {{-39, -39}, {39, 39}})));
  // ── Output ramp limiter on i_d_ref ────────────────────────────
  NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DuMax_idref, DuMin = DuMin_idref, tS = tS_idref, Y0 = i_d_ref_0, y(start = i_d_ref_0)) annotation(
    Placement(transformation(origin = {192, 62}, extent = {{-10, -10}, {10, 10}})));
  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput i_d_ref(start = i_d_ref_0) annotation(
    Placement(transformation(origin = {224, 62}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {225, 59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealOutput i_q_ref(start = -i_q_ref_0) annotation(
    Placement(transformation(origin = {210, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {225, -23}, extent = {{-15, -15}, {15, 15}})));
  // ── Parameters ───────────────────────────────────────────────
  // Control mode selection
  parameter Boolean k_direct_control_p = false "true: bypass P PI, use i_d_ref = P_ref/V_meas | false: use PI regulator (default)";
  parameter Boolean k_direct_control_q = false "true: bypass Q PI, use i_q_ref = Q_ref/V_meas | false: use PI regulator (default)";
  // PI tuning — d axis (active power)
  parameter Real k_p_d "Proportional gain of d-axis PI (pu)";
  parameter Real k_i_d "Integral gain of d-axis PI (pu/s)";
  parameter Real DyMax_pi_d "Max rate of change of d-axis PI output (pu/s)";
  parameter Real y_start_outer_d "Initial output of d-axis PI (pu)";
  // PI tuning — q axis (reactive power)
  parameter Real k_p_q "Proportional gain of q-axis PI (pu)";
  parameter Real k_i_q "Integral gain of q-axis PI (pu/s)";
  parameter Real DyMax_pi_q "Max rate of change of q-axis PI output (pu/s)";
  parameter Real y_start_outer_q "Initial output of q-axis PI (pu)";
  // Current limiter
  parameter Real Imax "Maximum total current magnitude (pu)";
  parameter Boolean PQFlag "Priority flag: true = P priority, false = Q priority";
  parameter Real UboostHigh "High voltage threshold for reactive boost (pu)";
  parameter Real UboostLow "Low voltage threshold for reactive boost (pu)";
  parameter Real Kqv "Reactive boost gain (pu)";
  parameter Real IqBoostMax "Maximum reactive current boost (pu)";
  parameter Real IqBoostMin "Minimum reactive current boost (pu)";
  // Output ramp limiter on i_d_ref
  parameter Real DuMax_idref "Max rate of change of i_d_ref (pu/s)";
  parameter Real DuMin_idref "Min rate of change of i_d_ref (pu/s)";
  parameter Real tS_idref "Sample time of i_d_ref ramp limiter (s)";
  // Plant communication delay
  parameter Real delay_time_plant "Time constant of plant-to-outer-loop delay (s)";
  // Initial conditions
  parameter Real PInjPu0 "Initial injected active power (pu)";
  parameter Real QInjPu0 "Initial injected reactive power (pu)";
  parameter Real U_filter0 "Initial filter voltage magnitude (pu)";
  parameter Real i_d_ref_0 "Initial d-axis current reference (pu)";
  parameter Real i_q_ref_0 "Initial q-axis current reference (pu)";
equation
// ── P path ───────────────────────────────────────────────────
  connect(P_ref, firstOrder.u) annotation(
    Line(points = {{-220, 82}, {-160, 82}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum_node_p.u1) annotation(
    Line(points = {{-136, 82}, {-96, 82}}, color = {46, 194, 126}, thickness = 0.75));
  connect(P_meas, sum_node_p.u2) annotation(
    Line(points = {{-220, 52}, {-88, 52}, {-88, 74}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_p.y, pi_controller_antiwind.e) annotation(
    Line(points = {{-79, 82}, {-50, 82}}, color = {46, 194, 126}, thickness = 0.75));
// ── Q path ───────────────────────────────────────────────────
  connect(Q_ref, firstOrder1.u) annotation(
    Line(points = {{-220, 18}, {-160, 18}}, color = {0, 0, 127}));
  connect(sum_node_q.u1, firstOrder1.y) annotation(
    Line(points = {{-82, 20}, {-138, 20}, {-138, 18}, {-136, 18}}, color = {46, 194, 126}, thickness = 0.75));
  connect(Q_meas, sum_node_q.u2) annotation(
    Line(points = {{-220, -20}, {-74, -20}, {-74, 10}, {-72, 10}, {-72, 12}, {-74, 12}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_q.y, pi_controller_antiwind1.e) annotation(
    Line(points = {{-65, 20}, {-46, 20}}, color = {46, 194, 126}, thickness = 0.75));
// ── Direct path: P_ref/V (orange) ────────────────────────────
  connect(division1.u1, firstOrder.y) annotation(
    Line(points = {{-78, 48}, {-136, 48}, {-136, 82}}, color = {230, 97, 0}, thickness = 0.75));
  connect(division1.u2, V_meas) annotation(
    Line(points = {{-78, 36}, {-190, 36}, {-190, -60}, {-220, -60}}, color = {230, 97, 0}, thickness = 0.75));
// ── Direct path: Q_ref/V (orange) ────────────────────────────
  connect(division.u1, firstOrder1.y) annotation(
    Line(points = {{-62, -30}, {-122, -30}, {-122, 20}, {-136, 20}, {-136, 18}}, color = {230, 97, 0}, thickness = 0.75));
  connect(division.u2, V_meas) annotation(
    Line(points = {{-62, -42}, {-172, -42}, {-172, -60}, {-220, -60}}, color = {230, 97, 0}, thickness = 0.75));
// ── Switch d: u1=direct(true), u3=PI(false) ──────────────────
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{22, 74}, {13, 74}, {13, 70}}, color = {255, 0, 255}));
  connect(division1.y, switch1.u1) annotation(
    Line(points = {{-55, 42}, {22, 42}, {22, 82}}, color = {230, 97, 0}, thickness = 0.75));
  connect(pi_controller_antiwind.y, switch1.u3) annotation(
    Line(points = {{-6, 82}, {22, 82}, {22, 66}}, color = {46, 194, 126}, thickness = 0.75));
// ── Switch q: u1=direct(true), u3=PI(false) ──────────────────
  connect(booleanConstant1.y, switch2.u2) annotation(
    Line(points = {{18.5, 11}, {10, 11}, {10, 12}, {30, 12}}, color = {255, 0, 255}));
  connect(division.y, switch2.u1) annotation(
    Line(points = {{-38, -36}, {28, -36}, {28, 20}, {30, 20}}, color = {230, 97, 0}, thickness = 0.75));
  connect(pi_controller_antiwind1.y, switch2.u3) annotation(
    Line(points = {{-2, 20}, {30, 20}, {30, 4}}, color = {46, 194, 126}, thickness = 0.75));
// ── Switch outputs → current limiter ─────────────────────────
  connect(switch1.y, current_limiter_outer_loop.id_raw) annotation(
    Line(points = {{46, 74}, {46, 62}, {86, 62}}, color = {0, 0, 127}));
  connect(switch2.y, current_limiter_outer_loop.iq_raw) annotation(
    Line(points = {{53, 12}, {69, 12}, {69, 42}, {86, 44}}, color = {0, 0, 127}));
// ── V_meas → current limiter ──────────────────────────────────
  connect(V_meas, current_limiter_outer_loop.U_meas_pu) annotation(
    Line(points = {{-220, -60}, {86, -60}, {86, 27.5}}, color = {0, 0, 127}));
// ── Current limiter → ramp limiter → i_d_ref ─────────────────
  connect(current_limiter_outer_loop.id_lim, rampLimiter.u) annotation(
    Line(points = {{172, 62}, {180, 62}}, color = {0, 0, 127}));
  connect(rampLimiter.y, i_d_ref) annotation(
    Line(points = {{203, 62}, {224, 62}}, color = {0, 0, 127}));
// ── Current limiter → i_q_ref ────────────────────────────────
  connect(i_q_ref, current_limiter_outer_loop.iq_lim) annotation(
    Line(points = {{210, 32}, {172, 31}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/Q/V control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "PI / Direct switchable")}),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}}), graphics = {Text(origin = {-5, -118}, extent = {{-147, 38}, {147, -38}}, textString = "Author: Gaia Bergamaschi
Model of the outer loop of a GFL converter.
Green path (default): PI regulators for P and Q.
Orange path: direct control via P_ref/V and Q_ref/V.
k_direct_control_p/q = false → PI (default)
k_direct_control_p/q = true  → direct (bypass PI)")}),
    Documentation(info = "<html>
      <p><b>Author:</b> Gaia Bergamaschi</p>
      <p>Outer loop controller for a Grid-Following (GFL) converter.</p>
      <ul>
        <li><b>Green path (default):</b> anti-windup PI regulators for P and Q.</li>
        <li><b>Orange path:</b> stateless direct control — i_d = P_ref/V, i_q = Q_ref/V.</li>
      </ul>
      <p>Set <code>k_direct_control_p = true</code> and/or <code>k_direct_control_q = true</code>
      to bypass the PI on the corresponding axis. Useful when PI parameters are
      unknown or cause low-frequency oscillations (SSO).</p>
    </html>"));
end outer_loop;