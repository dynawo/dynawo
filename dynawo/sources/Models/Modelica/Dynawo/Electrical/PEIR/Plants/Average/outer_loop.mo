within Dynawo.Electrical.PEIR.Plants.Average;

model outer_loop


  // ── Inputs ───────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput P_ref annotation(
    Placement(
      transformation(origin = {-90, 82}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-226, 92}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput P_meas annotation(
    Placement(
      transformation(origin = {-90, 50}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-226, 160}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput Q_ref annotation(
    Placement(
      transformation(origin = {-90, 18}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-223, 15}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput Q_meas annotation(
    Placement(
      transformation(origin = {-88, -12}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-225, -65}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput V_ref annotation(
    Placement(
      transformation(origin = {-88, -44}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-4, 218}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput V_meas annotation(
    Placement(
      transformation(origin = {-86, -76}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));

  // ── Rate limiters on Pref and Qref ───────────────────────────
  // These limit how fast the power references can change (pu/s).
  // They introduce a dynamic delay in the outer loop reference path
  // that overlaps with the outer loop bandwidth (1.6-8 Hz).
  // This interaction with the PLL is one of the documented causes
  // of low-frequency SSO (Cheng et al. 2023, third mechanism:
  // low-bandwidth PLL + outer control interaction).
  Modelica.Blocks.Nonlinear.SlewRateLimiter PrefRamp(
    Rising  =  dPrefMaxPu,
    Falling = -dPrefMaxPu,
    y(start = P0Pu)) annotation(
    Placement(transformation(origin = {-60, 82}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Nonlinear.SlewRateLimiter QrefRamp(
    Rising  =  dQrefMaxPu,
    Falling = -dQrefMaxPu,
    y(start = Q0Pu)) annotation(
    Placement(transformation(origin = {-60, 18}, extent = {{-10, -10}, {10, 10}})));

  // ── Sum nodes ────────────────────────────────────────────────
  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-30, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-30, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_v annotation(
    Placement(transformation(origin = {-46, -44}, extent = {{-10, -10}, {10, 10}})));

  // ── PI controllers ───────────────────────────────────────────
Dynawo.Electrical.Controls.PEIR.BaseControls.Average.pi_controller pi_controller_d(
    k_i = k_i_d,
    k_p = k_p_d,
    y_start = y_start_outer_d) annotation(
    Placement(transformation(origin = {0, 66}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add qvdroop(k1 = k_q, k2 = -1) annotation(
    Placement(transformation(origin = {6, -16}, extent = {{-10, -10}, {10, 10}})));

 Dynawo.Electrical.Controls.PEIR.BaseControls.Average.pi_controller pi_controller_q(
    k_p = k_p_q,
    k_i = k_i_q,
    y_start = y_start_outer_q) annotation(
    Placement(transformation(origin = {52, -16}, extent = {{-10, -10}, {10, 10}})));

  // ── Current limiter ──────────────────────────────────────────
 Dynawo.Electrical.Controls.PEIR.BaseControls.Average.current_limiter_reactive_boost current_limiter_outer_loop(
    Imax        = Imax,
    PQFlag      = PQFlag,
    UboostStart = UboostStart,
    Kqv         = Kqv,
    IqBoostMax  = IqBoostMax,
    IqBoostMin  = IqBoostMin) annotation(
    Placement(transformation(origin = {92, 40}, extent = {{-10, -10}, {10, 10}})));

  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput i_d_ref annotation(
    Placement(
      transformation(origin = {122, 50}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {225, 59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealOutput i_q_ref annotation(
    Placement(
      transformation(origin = {122, 30}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {225, -23}, extent = {{-15, -15}, {15, 15}})));

  // ── Parameters ───────────────────────────────────────────────
  parameter Real k_i_d;
  parameter Real k_p_d;
  parameter Real k_i_q;
  parameter Real k_p_q;
  parameter Real k_q;
  parameter Real Imax;
  parameter Real y_start_outer_d;
  parameter Real y_start_outer_q;
  parameter Boolean PQFlag;
  parameter Real UboostStart;
  parameter Real Kqv;
  parameter Real IqBoostMax;
  parameter Real IqBoostMin;

  // Rate limiter parameters on references (pu/s)
  // Set to large values (e.g. 99) to effectively disable.
  // Typical active values: 0.1 - 2 pu/s depending on plant response time.
  parameter Real dPrefMaxPu = 99
    "Max rate of change of P reference (pu/s)";
  parameter Real dQrefMaxPu = 99
    "Max rate of change of Q reference (pu/s)";

  // Initial values for rate limiter start conditions
  parameter Real P0Pu = 0 "Initial active power (pu)";
  parameter Real Q0Pu = 0 "Initial reactive power (pu)";

equation
  // ── Pref path: rate limiter → sum node → PI ──────────────────
  connect(P_ref, PrefRamp.u) annotation(
    Line(points = {{-90, 82}, {-72, 82}}, color = {0, 0, 127}));
  connect(PrefRamp.y, sum_node_p.u1) annotation(
    Line(points = {{-49, 82}, {-38, 82}}, color = {0, 0, 127}));
  connect(P_meas, sum_node_p.u2) annotation(
    Line(points = {{-90, 50}, {-30, 50}, {-30, 74}}, color = {0, 0, 127}));
  connect(sum_node_p.y, pi_controller_d.e) annotation(
    Line(points = {{-20, 82}, {-12, 82}, {-12, 66}}, color = {0, 0, 127}));

  // ── Qref path: rate limiter → sum node → qvdroop → PI ────────
  connect(Q_ref, QrefRamp.u) annotation(
    Line(points = {{-90, 18}, {-72, 18}}, color = {0, 0, 127}));
  connect(QrefRamp.y, sum_node_q.u1) annotation(
    Line(points = {{-49, 18}, {-38, 18}}, color = {0, 0, 127}));
  connect(Q_meas, sum_node_q.u2) annotation(
    Line(points = {{-88, -12}, {-30, -12}, {-30, 10}}, color = {0, 0, 127}));
  connect(sum_node_q.y, qvdroop.u1) annotation(
    Line(points = {{-20, 18}, {-10, 18}, {-10, -10}, {-6, -10}}, color = {0, 0, 127}));

  // ── V path: unchanged ────────────────────────────────────────
  connect(V_ref, sum_node_v.u1) annotation(
    Line(points = {{-88, -44}, {-54, -44}}, color = {0, 0, 127}));
  connect(V_meas, sum_node_v.u2) annotation(
    Line(points = {{-86, -76}, {-46, -76}, {-46, -52}}, color = {0, 0, 127}));
  connect(sum_node_v.y, qvdroop.u2) annotation(
    Line(points = {{-36, -44}, {-16, -44}, {-16, -22}, {-6, -22}}, color = {0, 0, 127}));

  // ── Q PI ─────────────────────────────────────────────────────
  connect(qvdroop.y, pi_controller_q.e) annotation(
    Line(points = {{18, -16}, {41, -16}}, color = {0, 0, 127}));


  // ── Current limiter ──────────────────────────────────────────
  connect(pi_controller_d.y, current_limiter_outer_loop.id_raw) annotation(
    Line(points = {{11, 66}, {70, 66}, {70, 44}, {81, 44}}, color = {0, 0, 127}));

  // ── Outputs ──────────────────────────────────────────────────
  connect(current_limiter_outer_loop.id_lim, i_d_ref) annotation(
    Line(points = {{103, 44}, {110, 44}, {110, 50}, {122, 50}}, color = {0, 0, 127}));
  connect(current_limiter_outer_loop.iq_lim, i_q_ref) annotation(
    Line(points = {{103, 36}, {112.5, 36}, {112.5, 30}, {122, 30}}, color = {0, 0, 127}));
  connect(pi_controller_q.y, current_limiter_outer_loop.iq_raw) annotation(
    Line(points = {{64, -16}, {68, -16}, {68, 39}, {81, 39}}, color = {0, 0, 127}));
  connect(current_limiter_outer_loop.U_meas_pu, V_meas) annotation(
    Line(points = {{81, 35}, {81, -78}, {-86, -78}, {-86, -76}}, color = {0, 0, 127}));
annotation(
  uses(Modelica(version = "3.2.3")),

  Icon(
   
    coordinateSystem(extent = {{-200, -200}, {200, 200}}),
    graphics = {
      
      
      Rectangle(extent = {{-200, 200}, {200, -200}}),
      Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}},
           textString = "Outer Loop"),
      Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}},
           textString = "P/Q/V control"),
      Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}},
           textString = "Pref/Qref rate limiters")
    }
  ),

 
  Diagram(
    coordinateSystem(extent = {{-200, -200}, {200, 200}})
  )
);
end outer_loop;