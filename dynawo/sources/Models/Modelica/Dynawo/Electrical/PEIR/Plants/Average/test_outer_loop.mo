within Dynawo.Electrical.PEIR.Plants.Average;

model test_outer_loop

  parameter Real Ud0 = 1.09 "D-axis voltage at operating point (pu)";

  // ── External ports (needed for linearization) ─────────────────────────────
  Modelica.Blocks.Interfaces.RealInput  P_ref_ext(start = 0.5)
    annotation(Placement(transformation(origin = {-108, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput  Q_ref_ext(start = 0.021)
    annotation(Placement(transformation(origin = {-110, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput  V_meas_ext(start = 1.09)
    annotation(Placement(transformation(origin = {-2, 66}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput i_d_ref_ext
    annotation(Placement(transformation(origin = {112, 42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput i_q_ref_ext
    annotation(Placement(transformation(origin = {112, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 18}, extent = {{-10, -10}, {10, 10}})));

  outer_loop outer_loop_1(
    k_p_d = 0.0333, k_i_d = 10, DyMax_pi_d = 1e4, y_start_outer_d = 0.4586,
    k_p_q = 0.0333, k_i_q = 10, DyMax_pi_q = 1e4, y_start_outer_q = -0.0288,
    Imax = 3, PQFlag = false,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 2,
    IqBoostMax = 0.5, IqBoostMin = -0.5,
    DuMax_idref = 10, DuMin_idref = -10, tS_idref = 1e-4,
    delay_time_plant = 0.02,
    PInjPu0 = 0.5, QInjPu0 = 0.021, U_filter0 = 1.09,
    i_d_ref_0 = 0.458, i_q_ref_0 = -0.017)
    annotation(Placement(transformation(origin = {6, 24}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Math.Gain gain_p(k = Ud0)
    annotation(Placement(transformation(origin = {5, 89}, extent = {{7, -7}, {-7, 7}})));
  Modelica.Blocks.Math.Gain gain_q(k = -Ud0)
    annotation(Placement(transformation(origin = {0, -20}, extent = {{10, -10}, {-10, 10}})));

equation
  connect(outer_loop_1.P_ref, P_ref_ext) annotation(
    Line(points = {{-15, 30}, {-100, 30}, {-100, 31}, {-108, 31}, {-108, 32}}, color = {0, 0, 127}));
  connect(Q_ref_ext, outer_loop_1.Q_ref) annotation(
    Line(points = {{-110, 18}, {-15.5, 18}}, color = {0, 0, 127}));
  connect(outer_loop_1.V_meas, V_meas_ext) annotation(
    Line(points = {{-4, 46}, {-2, 46}, {-2, 66}}, color = {0, 0, 127}));
  connect(gain_q.u, outer_loop_1.i_q_ref) annotation(
    Line(points = {{12, -20}, {28, -20}, {28, 22}}, color = {0, 0, 127}));
  connect(outer_loop_1.i_q_ref, i_q_ref_ext) annotation(
    Line(points = {{28, 22}, {112, 22}}, color = {0, 0, 127}));
  connect(outer_loop_1.i_d_ref, i_d_ref_ext) annotation(
    Line(points = {{28, 30}, {98, 30}, {98, 42}, {108, 42}, {108, 41}, {112, 41}, {112, 42}}, color = {0, 0, 127}));
  connect(outer_loop_1.i_d_ref, gain_p.u) annotation(
    Line(points = {{28.5, 30}, {30.5, 30}, {30.5, 76}, {30, 76}, {30, 75.5}, {14, 75.5}, {14, 90}}, color = {0, 0, 127}));
  connect(outer_loop_1.Q_meas, gain_q.y) annotation(
    Line(points = {{-16, 8}, {-16, -20}, {-10, -20}, {-10, -20}}, color = {0, 0, 127}));
  connect(gain_p.y, outer_loop_1.P_meas) annotation(
    Line(points = {{-2, 90}, {-18, 90}, {-18, 40}, {-16, 40}}, color = {0, 0, 127}));
end test_outer_loop;