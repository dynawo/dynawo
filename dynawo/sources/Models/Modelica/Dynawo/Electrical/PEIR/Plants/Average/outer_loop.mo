within Dynawo.Electrical.PEIR.Plants.Average;

model outer_loop
  // ── Inputs ───────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput P_ref  (start=PInjPu0) annotation(
    Placement(transformation(origin = {-220, 82}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-214, 58}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput P_meas  (start=PInjPu0) annotation(
    Placement(transformation(origin = {-220, 52}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-216, 158}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput Q_ref (start=QInjPu0) annotation(
    Placement(transformation(origin = {-220, 18}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-215, -59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput Q_meas (start=QInjPu0) annotation(
    Placement(transformation(origin = {-220, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-217, -161}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput V_meas (start=U_filter0) annotation(
    Placement(transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
  // ── Rate limiters on Pref and Qref ───────────────────────────
  // These limit how fast the power references can change (pu/s).
  // They introduce a dynamic delay in the outer loop reference path
  // that overlaps with the outer loop bandwidth (1.6-8 Hz).
  // This interaction with the PLL is one of the documented causes
  // of low-frequency SSO (Cheng et al. 2023, third mechanism:
  // low-bandwidth PLL + outer control interaction).
  // ── Sum nodes ────────────────────────────────────────────────
  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-30, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-30, 18}, extent = {{-10, -10}, {10, 10}})));
  // ── PI controllers ───────────────────────────────────────────
  // ── Current limiter ──────────────────────────────────────────
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.current_limiter_reactive_boost current_limiter_outer_loop(Imax = Imax, PQFlag = PQFlag, UboostHigh = UboostHigh, UboostLow = UboostLow, Kqv = Kqv, IqBoostMax = IqBoostMax, IqBoostMin = IqBoostMin) annotation(
    Placement(transformation(origin = {129, 47}, extent = {{-39, -39}, {39, 39}})));
  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput i_d_ref (start=i_d_ref_0) annotation(
    Placement(transformation(origin = {262, 62}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {225, 59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealOutput i_q_ref (start=i_q_ref_0) annotation(
    Placement(transformation(origin = {262, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {225, -23}, extent = {{-15, -15}, {15, 15}})));
  // ── Parameters ───────────────────────────────────────────────
  parameter Real k_i_d;
  parameter Real k_p_d;
  parameter Real k_i_q;
  parameter Real k_p_q;
  parameter Real Imax;
  parameter Real y_start_outer_d;
  parameter Real y_start_outer_q;
  parameter Boolean PQFlag;
  parameter Real UboostHigh "HIgh voltage limit for reactiv power boost (pu)";
  parameter Real UboostLow "Low voltage limit for reactiv power boost (pu)";
  parameter Real Kqv;
  parameter Real IqBoostMax;
  parameter Real IqBoostMin;
  parameter Real PInjPu0    "Initial injected active power (pu)";
  parameter Real QInjPu0    "Initial injected reactive power (pu)";
  parameter Real U_filter0  "Initial filter voltage magnitude (pu)";
  parameter Real i_d_ref_0  "Initial d-axis current reference (pu)";
  parameter Real i_q_ref_0  "Initial q-axis current reference (pu)";
  parameter Real DyMax_pi_d  "Max rate of change of d-axis PI output (pu/s)";
  parameter Real DyMax_pi_q  "Max rate of change of q-axis PI output (pu/s)";
  parameter Real DuMax_idref "Max rate of change of i_d_ref (pu/s)";
  parameter Real DuMin_idref "Min rate of change of i_d_ref (pu/s)";
  parameter Real tS_idref    "Sample time of i_d_ref ramp limiter (s)";
  // Initial values for rate limiter start conditions
  parameter Real delay_time_plant "Delay time between Plant controller and outer loop (s)";
  Controls.PEIR.BaseControls.Average.pi_controller_antiwind pi_controller_antiwind(k_p = k_p_d, tI = 1/k_i_d, y_start = y_start_outer_d, DyMax = DyMax_pi_d, YMax = Imax)  annotation(
    Placement(transformation(origin = {26, 62}, extent = {{-20, -20}, {20, 20}})));
  Controls.PEIR.BaseControls.Average.pi_controller_antiwind pi_controller_antiwind1(k_p = k_p_q, tI = 1/(k_i_q), y_start = y_start_outer_q, DyMax = DyMax_pi_q, YMax = Imax)  annotation(
    Placement(transformation(origin = {24, 18}, extent = {{-20, -20}, {20, 20}})));
  NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DuMax_idref, DuMin = DuMin_idref, tS = tS_idref, Y0 = i_d_ref_0, y(start = i_d_ref_0))  annotation(
    Placement(transformation(origin = {214, 62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k = 1, T = delay_time_plant, y_start = PInjPu0)  annotation(
    Placement(transformation(origin = {-148, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k = 1, y_start = QInjPu0, T = delay_time_plant)  annotation(
    Placement(transformation(origin = {-148, 18}, extent = {{-10, -10}, {10, 10}})));
equation
// ── Pref path: rate limiter → sum node → PI ──────────────────
  connect(P_meas, sum_node_p.u2) annotation(
    Line(points = {{-220, 52}, {-32, 52}, {-32, 74}, {-30, 74}}, color = {0, 0, 127}));
// ── Qref path: rate limiter → sum node → qvdroop → PI ────────
  connect(Q_meas, sum_node_q.u2) annotation(
    Line(points = {{-220, -20}, {-30, -20}, {-30, 10}}, color = {0, 0, 127}));
// ── V path: unchanged ────────────────────────────────────────
// ── Q PI ─────────────────────────────────────────────────────
// ── Current limiter ──────────────────────────────────────────
// ── Outputs ──────────────────────────────────────────────────
  connect(current_limiter_outer_loop.U_meas_pu, V_meas) annotation(
    Line(points = {{86, 27.5}, {86, -60}, {-220, -60}}, color = {0, 0, 127}));
  connect(i_q_ref, current_limiter_outer_loop.iq_lim) annotation(
    Line(points = {{262, 32}, {260.5, 32}, {260.5, 30}, {169, 30}, {169, 31}, {172, 31}}, color = {0, 0, 127}));
  connect(pi_controller_antiwind.y, current_limiter_outer_loop.id_raw) annotation(
    Line(points = {{48, 62}, {86, 62}}, color = {0, 0, 127}));
  connect(sum_node_p.y, pi_controller_antiwind.e) annotation(
    Line(points = {{-20, 82}, {-4.5, 82}, {-4.5, 62}, {4, 62}}, color = {0, 0, 127}));
  connect(pi_controller_antiwind1.y, current_limiter_outer_loop.iq_raw) annotation(
    Line(points = {{46, 18}, {64, 18}, {64, 44}, {86, 44}}, color = {0, 0, 127}));
  connect(sum_node_q.y, pi_controller_antiwind1.e) annotation(
    Line(points = {{-20, 18}, {2, 18}}, color = {0, 0, 127}));
  connect(current_limiter_outer_loop.id_lim, rampLimiter.u) annotation(
    Line(points = {{172, 62}, {202, 62}}, color = {0, 0, 127}));
  connect(rampLimiter.y, i_d_ref) annotation(
    Line(points = {{225, 62}, {262, 62}}, color = {0, 0, 127}));
  connect(firstOrder.u, P_ref) annotation(
    Line(points = {{-160, 82}, {-220, 82}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum_node_p.u1) annotation(
    Line(points = {{-136, 82}, {-38, 82}}, color = {0, 0, 127}));
  connect(Q_ref, firstOrder1.u) annotation(
    Line(points = {{-220, 18}, {-160, 18}}, color = {0, 0, 127}));
  connect(firstOrder1.y, sum_node_q.u1) annotation(
    Line(points = {{-137, 18}, {-38, 18}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/Q/V control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "Pref/Qref rate limiters")}),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end outer_loop;