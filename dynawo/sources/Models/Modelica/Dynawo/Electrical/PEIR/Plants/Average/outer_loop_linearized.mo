within Dynawo.Electrical.PEIR.Plants.Average;

model outer_loop_linearized
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
  // ── Plant communication delay ─────────────────────────────────
  // Models the delay between the plant-level controller and this outer loop.
  // A first-order filter with time constant delay_time_plant is used.
  // ── Sum nodes (P_ref - P_meas, Q_ref - Q_meas) ───────────────
  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-88, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-74, 20}, extent = {{-10, -10}, {10, 10}})));
  // ── PI controllers (green path, default) ─────────────────────
  // Anti-windup PI regulators. Active when k_direct_control_* = false.
  // Note: interaction between PI bandwidth and PLL is a known cause
  // of low-frequency SSO (Cheng et al. 2023, third mechanism).
  // ── Direct path (orange path) ─────────────────────────────────
  // Stateless feedforward: i_d_ref = P_ref / V_meas
  //                        i_q_ref = Q_ref / V_meas
  // Active when k_direct_control_* = true.
  // Useful for diagnostics when PI parameters are unknown or mistuned.
  // ── Mode switches ─────────────────────────────────────────────
  // Modelica Switch: output = u1 if u2 is TRUE, else u3.
  // u3 = direct path (orange), u1 = PI path (green).
  // So: k_direct_control_* = false  → direct, true → PI.
  // ── Current limiter with reactive boost ──────────────────────
  // ── Output ramp limiter on i_d_ref ────────────────────────────
  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput i_d_ref(start = i_d_ref_0) annotation(
    Placement(transformation(origin = {212, 82}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {225, 59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealOutput i_q_ref(start = i_q_ref_0) annotation(
    Placement(transformation(origin = {210, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {225, -23}, extent = {{-15, -15}, {15, 15}})));
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
  Controls.PEIR.BaseControls.Average.pi_controller pi_controller(k_p = k_p_d, k_i = k_i_d, y_start = y_start_outer_d)  annotation(
    Placement(transformation(origin = {-40, 82}, extent = {{-10, -10}, {10, 10}})));
  Controls.PEIR.BaseControls.Average.pi_controller pi_controller1(k_p = k_p_q, k_i = k_i_q, y_start = y_start_outer_q)  annotation(
    Placement(transformation(origin = {-44, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = -1)  annotation(
    Placement(transformation(origin = {14, 20}, extent = {{-10, -10}, {10, 10}})));
equation
// ── P path ───────────────────────────────────────────────────
  connect(P_meas, sum_node_p.u2) annotation(
    Line(points = {{-220, 52}, {-88, 52}, {-88, 74}}, color = {46, 194, 126}, thickness = 0.75));
// ── Q path ───────────────────────────────────────────────────
  connect(Q_meas, sum_node_q.u2) annotation(
    Line(points = {{-220, -20}, {-74, -20}, {-74, 10}, {-72, 10}, {-72, 12}, {-74, 12}}, color = {46, 194, 126}, thickness = 0.75));
// ── Direct path: P_ref/V (orange) ────────────────────────────
// ── Direct path: Q_ref/V (orange) ────────────────────────────
// ── Switch d: u1=direct(true), u3=PI(false) ──────────────────
// ── Switch q: u1=direct(true), u3=PI(false) ──────────────────
// ── Switch outputs → current limiter ─────────────────────────
// ── V_meas → current limiter ──────────────────────────────────
// ── Current limiter → ramp limiter → i_d_ref ─────────────────
// ── Current limiter → i_q_ref ────────────────────────────────
  connect(Q_ref, sum_node_q.u1) annotation(
    Line(points = {{-220, 18}, {-82, 18}, {-82, 20}}, color = {0, 0, 127}));
  connect(P_ref, sum_node_p.u1) annotation(
    Line(points = {{-220, 82}, {-96, 82}}, color = {0, 0, 127}));
  connect(pi_controller.e, sum_node_p.y) annotation(
    Line(points = {{-51, 82}, {-78, 82}}, color = {0, 0, 127}));
  connect(pi_controller.y, i_d_ref) annotation(
    Line(points = {{-28, 82}, {212, 82}}, color = {0, 0, 127}));
  connect(sum_node_q.y, pi_controller1.e) annotation(
    Line(points = {{-64, 20}, {-54, 20}}, color = {0, 0, 127}));
  connect(pi_controller1.y, gain.u) annotation(
    Line(points = {{-32, 20}, {2, 20}}, color = {0, 0, 127}));
  connect(gain.y, i_q_ref) annotation(
    Line(points = {{26, 20}, {210, 20}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/Q/V control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "PI / Direct switchable")}),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
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
end outer_loop_linearized;