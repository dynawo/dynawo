within Dynawo.Electrical.PEIR.Plants.Average;

model test_outer_loop_linearized

  parameter Real Ud0 = 1.09 "D-axis voltage at operating point (pu)";

  // ── External ports (needed for linearization) ─────────────────────────────
  Modelica.Blocks.Interfaces.RealInput  P_ref_ext(start = 0.5)
    annotation(Placement(transformation(origin = {-110, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput  Q_ref_ext(start = 0.021)
    annotation(Placement(transformation(origin = {-110, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput i_d_ref_ext
    annotation(Placement(transformation(origin = {116, 42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput i_q_ref_ext
    annotation(Placement(transformation(origin = {116, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 18}, extent = {{-10, -10}, {10, 10}})));

  Average.outer_loop_linearized outer_loop_linearized(
    k_p_d = 0.0333, k_i_d = 10, DyMax_pi_d = 1e4, y_start_outer_d = 0.4586,
    k_p_q = 0.0333, k_i_q = 10, DyMax_pi_q = 1e4, y_start_outer_q = -0.0288,
    Imax = 3, PQFlag = false,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 2,
    IqBoostMax = 0.5, IqBoostMin = -0.5,
    DuMax_idref = 10, DuMin_idref = -10, tS_idref = 1e-4,
    delay_time_plant = 0.02,
    PInjPu0 = 0.5, QInjPu0 = 0.021, U_filter0 = 1.09,
    i_d_ref_0 = 0.458, i_q_ref_0 = -0.017)
    annotation(Placement(transformation(origin = {-2, 36}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Math.Gain gain_p(k = Ud0)
    annotation(Placement(transformation(origin = {0, 78}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Gain gain_q(k = -Ud0)
    annotation(Placement(transformation(origin = {0, -20}, extent = {{10, -10}, {-10, 10}})));

equation
  connect(P_ref_ext, outer_loop_linearized.P_ref) annotation(
    Line(points = {{-110, 56}, {-59.5, 56}, {-59.5, 42}, {-23, 42}}, color = {0, 0, 127}));
  connect(Q_ref_ext, outer_loop_linearized.Q_ref) annotation(
    Line(points = {{-110, 18}, {-62.75, 18}, {-62.75, 30}, {-23.5, 30}}, color = {0, 0, 127}));
  connect(outer_loop_linearized.i_d_ref, i_d_ref_ext) annotation(
    Line(points = {{20, 42}, {116, 42}}, color = {0, 0, 127}));
  connect(i_q_ref_ext, outer_loop_linearized.i_q_ref) annotation(
    Line(points = {{116, 20}, {20, 20}, {20, 34}}, color = {0, 0, 127}));
  connect(outer_loop_linearized.i_d_ref, gain_p.u) annotation(
    Line(points = {{20, 42}, {21, 42}, {21, 44}, {20, 44}, {20, 78}, {12, 78}}, color = {0, 0, 127}));
  connect(outer_loop_linearized.P_meas, gain_p.y) annotation(
    Line(points = {{-24, 52}, {-25, 52}, {-25, 78}, {-10, 78}, {-10, 78}}, color = {0, 0, 127}));
  connect(gain_q.u, outer_loop_linearized.i_q_ref) annotation(
    Line(points = {{12, -20}, {20, -20}, {20, 34}}, color = {0, 0, 127}));
  connect(gain_q.y, outer_loop_linearized.Q_meas) annotation(
    Line(points = {{-10, -20}, {-24, -20}, {-24, 20}}, color = {0, 0, 127}));
end test_outer_loop_linearized;