within Dynawo.Electrical.PEIR.Plants.Average;

model GFLControl

  // ────────────────────────────────────────────────────────────
  // Complex initial conditions (Dynawo types)
  // ────────────────────────────────────────────────────────────
  parameter Types.ComplexVoltagePu u0Pu
    "Initial complex PCC voltage in pu (base UNom)";
  parameter Types.ComplexCurrentPu i0Pu
    "Initial complex PCC current in pu (base UNom, SnRef)";
  parameter Types.ComplexVoltagePu uFilter0Pu
    "Initial complex voltage at filter in pu (base UNom)";

  parameter Real P0Pu     "Initial active power at PCC (pu, generator convention)";
  parameter Real Q0Pu     "Initial reactive power at PCC (pu, generator convention)";
  parameter Real Omega0Pu "Initial frequency (pu)";
  parameter Real QInj0Pu "Initial reactive power at converter (pu, generator convention)"; 
  parameter Real PInj0Pu "Initial active power at converter (pu, generator convention)";
  parameter Real id_ref_0     "Initial d-axis current reference (pu)";
  parameter Real id_conv_0    "Initial d-axis measured current (pu)";
  parameter Real iq_ref_0     "Initial q-axis current reference (pu)";
  parameter Real iq_conv_0    "Initial q-axis measured current (pu)";

    // ── dq voltages at filter in control frame (from grid re/im using Theta0) ─
  // uFilter0Pu is in grid frame (re/im), control dq frame is rotated by Theta0
  final parameter Real Ud0Pu =
    uFilter0Pu.re * cos(Theta0) + uFilter0Pu.im * sin(Theta0)
    "Initial d-axis voltage at filter in control dq frame (pu)";

  final parameter Real Uq0Pu =
   -uFilter0Pu.re * sin(Theta0) + uFilter0Pu.im * cos(Theta0)
    "Initial q-axis voltage at filter in control dq frame (pu)";

  // Voltage magnitude squared U0^2 = Ud0^2 + Uq0^2
  final parameter Real U0Pu_sq =
    Ud0Pu^2 + Uq0Pu^2
    "Squared magnitude of initial filter voltage (pu^2)";

  // ── Initial dq currents at filter (your formulas) ───────────
  // i_d,0 = (P0*Ud0 + Q0*Uq0) / U0^2
  // i_q,0 = (P0*Uq0 - Q0*Ud0) / U0^2
  final parameter Real Id0Pu =
    (P0Pu * Ud0Pu + Q0Pu * Uq0Pu) / max(U0Pu_sq, 1e-6)
    "Initial d-axis current at filter in pu (from P0, Q0, Ud0, Uq0)";

  final parameter Real Iq0Pu =
    (P0Pu * Uq0Pu - Q0Pu * Ud0Pu) / max(U0Pu_sq, 1e-6)
    "Initial q-axis current at filter in pu (from P0, Q0, Ud0, Uq0)";

  // ── Initial voltage references for inner current loop ───────
  // v_d,ref,0 = U_d,0 + R_g*i_d,0 - Omega0Pu * L_g * i_q,0
  // v_q,ref,0 = U_q,0 + R_g*i_q,0 + Omega0Pu * L_g * i_d,0
  final parameter Real vd_ref_0 =
    Ud0Pu + R_g * Id0Pu - Omega0Pu * L_g * Iq0Pu
    "Initial d-axis voltage reference for current loop";

  final parameter Real vq_ref_0 =
    Uq0Pu + R_g * Iq0Pu + Omega0Pu * L_g * Id0Pu
    "Initial q-axis voltage reference for current loop";

  // ── Map to controller initial outputs ───────────────────────
  // Inner current loop initial outputs
  final parameter Real y_start_current_d =
    vd_ref_0 "Initial output of d-axis current controller (v_d,ref,0)";

  final parameter Real y_start_current_q =
    vq_ref_0 "Initial output of q-axis current controller (v_q,ref,0)";

  // Outer loop initial outputs (current references)
  final parameter Real y_start_outer_d =
    Id0Pu "Initial output of d-axis outer controller (i_d,ref,0)";

  final parameter Real y_start_outer_q =
    Iq0Pu "Initial output of q-axis outer controller (i_q,ref,0)";


  // ────────────────────────────────────────────────────────────
  // Design parameters
  // ────────────────────────────────────────────────────────────

  // Current loop
  parameter Real k_p_d_current "Current Loop Proportional gain PI d axis";
  parameter Real k_i_d_current "Current Loop integral gain PI d axis";
  parameter Real k_p_q_current "Current Loop Proportional gain PI q axis";
  parameter Real k_i_q_current "Current Loop integral gain PI q axis";
  parameter Real L_g "Grid equivaent inductance (pu)";
  parameter Real R_g "Grid equivaent resistance (pu)";


  parameter Real vd_0         "Initial d-axis converter voltage (pu)";
  parameter Real vq_0         "Initial q-axis converter voltage (pu)";


  parameter Real vmd_0        "Initial modulation voltage reference (pu)";
  parameter Real vmq_0        "Initial modulation voltage reference (pu)";



  // Outer loop — PI gains
  parameter Real k_p_d_outer "Outer loop Proportional gain PI d axis";
  parameter Real k_i_d_outer "Outer loop intgl gain PI d axis";
  parameter Real k_p_q_outer "Outer loop Proportional gain PI q axis";
  parameter Real k_i_q_outer "Outer loop intgl gain PI  q axis";
  parameter Real k_q_outer "Outer loop Q/V gain";
  parameter Real Imax "Maximum current (pu)";
  parameter Real PInjPu0    "Initial injected active power (pu)";
  parameter Real QInjPu0    "Initial injected reactive power (pu)";
  parameter Real U_filter0  "Initial filter voltage magnitude (pu)";


  // Outer loop — current limiter
  parameter Boolean PQFlag      "Q(false) or P(true) priority";
  parameter Real UboostStart    "Voltage threshold for Iq boost (pu)";
  parameter Real Kqv            "Iq boost gain (pu/pu), 0 to disable";
  parameter Real IqBoostMax     "Max Iq boost (pu)";
  parameter Real IqBoostMin     "Min Iq boost (pu)";

  // Outer loop — rate limiters on references
  parameter Real dPrefMaxPu "Max rate of change of Pref (pu/s)";
  parameter Real dQrefMaxPu  "Max rate of change of Qref (pu/s)";

 
// ───────────────── Plant controller parameters ─────────────────
  parameter Real K_p_q_plant
    "Voltage/Q loop PI: proportional gain on Q (pu/pu)";
  parameter Real K_i_q_plant
    "Voltage/Q loop PI: integral gain on Q (pu/pu·s)";

  parameter Real K_p_p_plant
    "Active power loop PI: proportional gain on P (pu/pu)";
  parameter Real K_i_p_plant
    "Active power loop PI: integral gain on P (pu/pu·s)";

  parameter Real Lambda
    "Voltage–reactive droop coefficient λ in U + λ·Q (pu U / pu Q)";

  parameter Real Kdroop_p
    "Frequency droop gain on P (pu Ω / pu P)";

  parameter Real QMaxPu
    "Maximum reactive power reference (pu)";
  parameter Real QMinPu
    "Minimum reactive power reference (pu)";

  parameter Real PMaxPu
    "Maximum active power reference (pu)";
  parameter Real PMinPu
    "Minimum active power reference (pu)";

  parameter Real FEMaxPu
    "Maximum allowed frequency error for droop block (pu)";
  parameter Real FEMinPu
    "Minimum allowed frequency error for droop block (pu)";

  parameter Real FDbd1Pu
    "Inner frequency deadband limit (pu) – first threshold";
  parameter Real FDbd2Pu
    "Outer frequency deadband limit (pu) – second threshold";

  parameter Real DbdPu
    "Static deadband in P–f or Q–U droop (pu)";

  parameter Real U0Pu
    "Initial PCC voltage magnitude used by PlantController (pu)";
  parameter Real Q0Pu_param
    "Initial reactive power at PCC used by PlantController (pu)";
  parameter Real P0Pu_param
    "Initial active power at PCC used by PlantController (pu)";

  // ───────────────── PLL parameters ─────────────────────────────
  parameter Real K_p_pll
    "PLL proportional gain";
  parameter Real K_i_pll
    "PLL integral gain";

  parameter Real OmegaMaxPu
    "Maximum PLL frequency (pu)";
  parameter Real OmegaMinPu
    "Minimum PLL frequency (pu)";

  parameter Real Theta0
    "Initial PLL angle (rad)";
    
    
  // ────────────────────────────────────────────────────────────
  // Sub-blocks
  // ────────────────────────────────────────────────────────────

  Dynawo.Electrical.PEIR.Plants.Average.current_loop current_loop_GFL(
    k_p_d             = k_p_d_current,
    k_i_d             = k_i_d_current,
    k_p_q             = k_p_q_current,
    k_i_q             = k_i_q_current,
    L_g               = L_g,
    y_start_current_d = y_start_current_d,
    y_start_current_q = y_start_current_q, id_ref_0 = id_ref_0, id_meas_0 = id_conv_0, iq_ref_0 = iq_ref_0, iq_meas_0 = iq_conv_0, vd_0 = vd_0, vq_0 = vq_0, Omega0Pu = Omega0Pu, vmd_0 = vmd_0, vmq_0 = vmq_0) annotation(
    Placement(transformation(origin = {68, 56}, extent = {{-20, -20}, {20, 20}})));

  Dynawo.Electrical.PEIR.Plants.Average.outer_loop outer_loop_GFL(
    k_p_d           = k_p_d_outer,
    k_i_d           = k_i_d_outer,
    k_p_q           = k_p_q_outer,
    k_i_q           = k_i_q_outer,
    k_q             = k_q_outer,
    Imax            = Imax,
    y_start_outer_d = y_start_outer_d,
    y_start_outer_q = y_start_outer_q,
    PQFlag          = PQFlag,
    UboostStart     = UboostStart,
    Kqv             = Kqv,
    IqBoostMax      = IqBoostMax,
    IqBoostMin      = IqBoostMin,
    dPrefMaxPu      = dPrefMaxPu,
    dQrefMaxPu      = dQrefMaxPu,
    P0Pu            = P0Pu_param,
    Q0Pu            = Q0Pu_param, PInjPu0 = PInjPu0, QInjPu0 = QInjPu0, U_filter0 = U_filter0, i_d_ref_0 = id_ref_0, i_q_ref_0 = iq_ref_0) annotation(
    Placement(transformation(origin = {-46, 52}, extent = {{-36, -36}, {36, 36}})));

  Dynawo.Electrical.PEIR.Plants.Average.Plant_controller plantController(
    Kp_q     = K_p_q_plant,
    Ki_q     = K_i_q_plant,
    Kp_p     = K_p_p_plant,
    Ki_p     = K_i_p_plant,
    Lambda   = Lambda,
    Kdroop   = Kdroop_p,
    QMaxPu   = QMaxPu,
    QMinPu   = QMinPu,
    PMaxPu   = PMaxPu,
    PMinPu   = PMinPu,
    FEMaxPu  = FEMaxPu,
    FEMinPu  = FEMinPu,
    FDbd1Pu  = FDbd1Pu,
    FDbd2Pu  = FDbd2Pu,
    DbdPu    = DbdPu,
    U0Pu     = U0Pu,
    Q0Pu     = Q0Pu_param,
    P0Pu     = P0Pu_param,
    Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu) annotation(
    Placement(transformation(origin = {-180, 68}, extent = {{-30, -30}, {30, 30}})));

 Dynawo.Electrical.PEIR.Plants.Average.pll pll(
    Ki         = K_i_pll,
    Kp         = K_p_pll,
    OmegaMaxPu = OmegaMaxPu,
    OmegaMinPu = OmegaMinPu,
    Theta0     = Theta0) annotation(
    Placement(transformation(origin = {15, -69}, extent = {{-23, -23}, {23, 23}})));

  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(transformation(origin = {162, 42}, extent = {{-18, -18}, {18, 18}})));

  // ── External inputs ──────────────────────────────────────────

  Modelica.Blocks.Interfaces.RealInput U_ref_pu annotation(
    Placement(transformation(origin = {-39, 129}, extent = {{-9, -9}, {9, 9}}, rotation = -90),
    iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealInput omegaRefPU annotation(
    Placement(transformation(origin = {-267, -59}, extent = {{-7, -7}, {7, 7}}),
    iconTransformation(origin = {72, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealInput P_plant_c annotation(
    Placement(transformation(origin = {-245, 65}, extent = {{-9, -9}, {9, 9}}),
    iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput Q_plant_pu annotation(
    Placement(transformation(origin = {-126, 110}, extent = {{-8, -8}, {8, 8}}, rotation = 180),
    iconTransformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput U_pu_plant_c annotation(
    Placement(transformation(origin = {-181, 123}, extent = {{-7, -7}, {7, 7}}, rotation = -90),
    iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput P_meas annotation(
    Placement(transformation(origin = {-128, 86}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-84, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput Q_meas annotation(
    Placement(transformation(origin = {-134, 30}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-48, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput V_d_meas annotation(
    Placement(transformation(origin = {73, 103}, extent = {{-9, -9}, {9, 9}}, rotation = -90),
    iconTransformation(origin = {46, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput V_q_meas annotation(
    Placement(transformation(origin = {59, 103}, extent = {{-9, -9}, {9, 9}}, rotation = -90),
    iconTransformation(origin = {72, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput i_d_meas annotation(
    Placement(transformation(origin = {14, 72}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {18, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput i_q_meas annotation(
    Placement(transformation(origin = {12, 30}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-8, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput U_ref_pcc_pu annotation(
    Placement(transformation(origin = {-231, 111}, extent = {{-7, -7}, {7, 7}}),
    iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealInput P_ref_pu annotation(
    Placement(transformation(origin = {-241, 85}, extent = {{-11, -11}, {11, 11}}),
    iconTransformation(origin = {-18, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // ── External outputs ─────────────────────────────────────────

  Modelica.Blocks.Interfaces.RealOutput vm_re annotation(
    Placement(transformation(origin = {206, 50}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput vm_im annotation(
    Placement(transformation(origin = {208, 30}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, 8}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput theta_pll annotation(
    Placement(transformation(origin = {72, -78}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput omega_pll_pu annotation(
    Placement(transformation(origin = {74, -60}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));

  // Voltage magnitude for outer loop
  Modelica.Blocks.Sources.RealExpression U_meas_pu(
    y = sqrt(V_d_meas^2 + V_q_meas^2)) annotation(
    Placement(transformation(origin = {-82, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput V_q_grid annotation(
    Placement(transformation(origin = {-278, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}})));
equation
// ── PLL ──────────────────────────────────────────────────────
// ── Transform DQ→RI ──────────────────────────────────────────
// ── Current loop ─────────────────────────────────────────────
// ── Outer loop → current loop ─────────────────────────────────
// ── Outer loop inputs ────────────────────────────────────────
// ── Plant controller → outer loop ────────────────────────────
// ── Plant controller inputs ───────────────────────────────────
// omegaRef to plant controller (external reference,)
// omegaPLL to plant controller (measured frequency for droop)
  connect(transformDQtoRI.ur, vm_re) annotation(
    Line(points = {{182, 53}, {200, 53}, {200, 50}, {206, 50}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ui, vm_im) annotation(
    Line(points = {{182, 31}, {200, 31}, {200, 30}, {208, 30}}, color = {0, 0, 127}));
  connect(pll.theta, theta_pll) annotation(
    Line(points = {{40, -78}, {72, -78}}, color = {0, 0, 127}));
  connect(transformDQtoRI.phi, pll.theta) annotation(
    Line(points = {{142, 31}, {133.5, 31}, {133.5, -94}, {134, -94}, {134, -97}, {40, -97}, {40, -78}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, omega_pll_pu) annotation(
    Line(points = {{40, -60}, {74, -60}}, color = {0, 0, 127}));
  connect(current_loop_GFL.vm_d, transformDQtoRI.ud) annotation(
    Line(points = {{90, 62}, {142, 62}, {142, 55}}, color = {0, 0, 127}));
  connect(current_loop_GFL.vm_q, transformDQtoRI.uq) annotation(
    Line(points = {{90, 46}, {142, 46}, {142, 47}}, color = {0, 0, 127}));
  connect(current_loop_GFL.v_d, V_d_meas) annotation(
    Line(points = {{74, 78}, {73, 78}, {73, 103}}, color = {0, 0, 127}));
  connect(current_loop_GFL.v_q, V_q_meas) annotation(
    Line(points = {{60, 78}, {59, 78}, {59, 103}}, color = {0, 0, 127}));
  connect(current_loop_GFL.omega_pll, pll.omegaPLLPu) annotation(
    Line(points = {{72, 34}, {72, -46.25}, {40, -46.25}, {40, -60}}, color = {0, 0, 127}));
  connect(i_q_meas, current_loop_GFL.i_q_meas) annotation(
    Line(points = {{12, 30}, {12, 28}, {46, 28}, {46, 44}}, color = {0, 0, 127}));
  connect(i_d_meas, current_loop_GFL.i_d_meas) annotation(
    Line(points = {{14, 72}, {14, 70}, {46, 70}}, color = {0, 0, 127}));
  connect(V_q_grid, pll.uqFilterPu) annotation(
    Line(points = {{-278, -80}, {-10.75, -80}, {-10.75, -78}, {-10, -78}}, color = {0, 0, 127}));
  connect(outer_loop_GFL.i_d_ref, current_loop_GFL.i_d_ref) annotation(
    Line(points = {{-5.5, 63}, {-5.5, 62}, {46, 62}, {46, 63}}, color = {0, 0, 127}));
  connect(outer_loop_GFL.i_q_ref, current_loop_GFL.i_q_ref) annotation(
    Line(points = {{-5.5, 48}, {19.25, 48}, {19.25, 52}, {46, 52}}, color = {0, 0, 127}));
  connect(outer_loop_GFL.V_meas, U_meas_pu.y) annotation(
    Line(points = {{-62, 92}, {-71, 92}, {-71, 110}}, color = {0, 0, 127}));
  connect(P_meas, outer_loop_GFL.P_meas) annotation(
    Line(points = {{-128, 86}, {-86, 86}, {-86, 80}}, color = {0, 0, 127}));
  connect(Q_meas, outer_loop_GFL.Q_meas) annotation(
    Line(points = {{-134, 30}, {-90, 30}, {-90, 40}, {-86, 40}}, color = {0, 0, 127}));
  connect(plantController.QInjRefPu, outer_loop_GFL.Q_ref) annotation(
    Line(points = {{-146, 54}, {-86, 54}}, color = {0, 0, 127}));
  connect(outer_loop_GFL.P_ref, plantController.PInjRefPu) annotation(
    Line(points = {{-86, 68}, {-146, 68}, {-146, 80}}, color = {0, 0, 127}));
  connect(omegaRefPU, pll.omegaRefPu) annotation(
    Line(points = {{-267, -59}, {-11, -59}, {-11, -60}, {-10, -60}}, color = {0, 0, 127}));
  connect(plantController.omegaRefPu, omegaRefPU) annotation(
    Line(points = {{-212, 48}, {-241, 48}, {-241, -59}, {-267, -59}}, color = {0, 0, 127}));
  connect(plantController.omegaPLLPu, pll.omegaPLLPu) annotation(
    Line(points = {{-180, 34}, {-152.75, 34}, {-152.75, -32}, {40, -32}, {40, -60}}, color = {0, 0, 127}));
  connect(U_ref_pcc_pu, plantController.URefPu) annotation(
    Line(points = {{-231, 111}, {-198, 111}, {-198, 102}}, color = {0, 0, 127}));
  connect(U_pu_plant_c, plantController.UfiltPu) annotation(
    Line(points = {{-181, 123}, {-182, 123}, {-182, 102}}, color = {0, 0, 127}));
  connect(Q_plant_pu, plantController.QfiltPu) annotation(
    Line(points = {{-126, 110}, {-168, 110}, {-168, 102}}, color = {0, 0, 127}));
  connect(P_ref_pu, plantController.PRefPu) annotation(
    Line(points = {{-241, 85}, {-233, 85}, {-233, 84}, {-214, 84}}, color = {0, 0, 127}));
  connect(P_plant_c, plantController.PfiltPu) annotation(
    Line(points = {{-245, 65}, {-212, 65}, {-212, 66}}, color = {0, 0, 127}));
  connect(outer_loop_GFL.V_ref, U_ref_pu) annotation(
    Line(points = {{-40, 90}, {-40, 129}, {-39, 129}}, color = {0, 0, 127}));
  annotation(
    uses(Dynawo(version = "1.8.0"), Modelica(version = "3.2.3")),
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}}),
      Text(origin = {6, 22}, extent = {{-90, 20}, {90, -20}},
           textString = "GFL Control"),
      Text(origin = {6, -8}, extent = {{-90, 15}, {90, -15}},
           textString = "Plant + outer/inner loops"),
      Text(origin = {-6, -32}, extent = {{-90, 15}, {90, -15}},
           textString = "PLL")},
      coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-260, -120}, {240, 120}}), graphics = {Text(extent = {{-40, 60}, {-40, 60}}, textString = "text")}));


end GFLControl;