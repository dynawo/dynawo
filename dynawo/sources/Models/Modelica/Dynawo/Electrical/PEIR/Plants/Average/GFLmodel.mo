within Dynawo.Electrical.PEIR.Plants.Average;

model GFLmodel
  // ────────────────────────────────────────────────────────────
  // Network initial conditions (PCC, LV side)
  // ────────────────────────────────────────────────────────────
  parameter Real UrPcc0Pu "Initial real part of PCC (LV) voltage (pu)";
  parameter Real UiPcc0Pu "Initial imaginary part of PCC (LV) voltage (pu)";
  parameter Real P0_pcc "Initial active power at PCC (pu, load convention >0 into converter)";
  parameter Real Q0_pcc "Initial reactive power at PCC (pu, load convention >0 into converter)";
  parameter Real Omega0Pu "Initial per-unit frequency (pu) – nominal operating point";
  // ────────────────────────────────────────────────────────────
  // VSC delay
  // ────────────────────────────────────────────────────────────
  parameter Real tVSC "VSC Pade delay time constant (s)";
  // ────────────────────────────────────────────────────────────
  // LC filter (converter-side filter)
  // ────────────────────────────────────────────────────────────
  parameter Real RfPu "Filter series resistance R_f (pu, base UNom, SNom)";
  parameter Real LfPu "Filter series inductance L_f (pu, base UNom, SNom)";
  parameter Real CfPu "Filter shunt capacitance C_f (pu, base UNom, SNom)";
  parameter Real omegaNom "Nominal angular frequency ω_nom (rad/s) used as base";
  // ────────────────────────────────────────────────────────────
  // RL transformer / grid equivalent (LV side)
  // ────────────────────────────────────────────────────────────
  parameter Real RPuHV "Transformer / grid series resistance (pu, HV side)";
  parameter Real LPuHV "Transformer / grid series inductance (pu, HV side)";
  parameter Real RPuLV "Transformer / grid series resistance (pu, LV side)";
  parameter Real LPuLV "Transformer / grid series inductance (pu, LV side)";
  // ────────────────────────────────────────────────────────────
  // Measurement filter
  // ────────────────────────────────────────────────────────────
  parameter Real k_filter "Measurement filter gain";
  parameter Real T_filter "Measurement filter time constant (s)";
  // ────────────────────────────────────────────────────────────
  // Inner and outer current controllers (converter control)
  // ────────────────────────────────────────────────────────────
  // Inner current loop gains
  parameter Real k_p_d_current "Inner current loop PI: proportional gain on d-axis";
  parameter Real k_i_d_current "Inner current loop PI: integral gain on d-axis";
  parameter Real k_p_q_current "Inner current loop PI: proportional gain on q-axis";
  parameter Real k_i_q_current "Inner current loop PI: integral gain on q-axis";
  // Outer P/Q loop gains
  parameter Real k_p_d_outer "Outer loop PI: proportional gain on d-axis (active power)";
  parameter Real k_i_d_outer "Outer loop PI: integral gain on d-axis (active power)";
  parameter Real k_p_q_outer "Outer loop PI: proportional gain on q-axis (reactive/voltage)";
  parameter Real k_i_q_outer "Outer loop PI: integral gain on q-axis (reactive/voltage)";
  parameter Real Imax "Maximum converter current magnitude (pu)";
  parameter Boolean PQFlag "Priority flag: false = Q-priority, true = P-priority";
  // Reactive power boost around voltage thresholds
  parameter Real UboostHigh "High-voltage threshold for reactive power boost (pu)";
  parameter Real UboostLow "Low-voltage threshold for reactive power boost (pu)";
  parameter Real Kqv "Reactive boost gain dIq/dU (pu/pu), 0 to disable";
  parameter Real IqBoostMax "Maximum additional Iq boost (pu)";
  parameter Real IqBoostMin "Minimum additional Iq boost (pu)";
  // ────────────────────────────────────────────────────────────
  // Plant controller (P–f and Q–U droop and PI loops)
  // ────────────────────────────────────────────────────────────
  parameter Real K_p_q_plant "Plant Q/U PI: proportional gain on Q (pu/pu)";
  parameter Real K_i_q_plant "Plant Q/U PI: integral gain on Q (pu/pu·s)";
  parameter Real K_p_p_plant "Plant P/f PI: proportional gain on P (pu/pu)";
  parameter Real K_i_p_plant "Plant P/f PI: integral gain on P (pu/pu·s)";
  parameter Real Lambda "Voltage–reactive droop coefficient λ in U + λ·Q (pu U / pu Q)";
  parameter Real Kdroop "Frequency droop gain on active power (pu/pu)";
  parameter Real QMaxPu "Maximum reactive power reference (pu)";
  parameter Real QMinPu "Minimum reactive power reference (pu)";
  parameter Real PMaxPu "Maximum active power reference (pu)";
  parameter Real PMinPu "Minimum active power reference (pu)";
  parameter Real FEMaxPu "Maximum frequency error after droop limiter (pu)";
  parameter Real FEMinPu "Minimum frequency error after droop limiter (pu)";
  parameter Real FDbd1Pu "Inner frequency deadband limit (pu, lower/first threshold)";
  parameter Real FDbd2Pu "Outer frequency deadband limit (pu, upper/second threshold)";
  parameter Real DbdPu "Voltage error deadband half-width in U + λ·Q loop (pu)";
  // ────────────────────────────────────────────────────────────
  // PLL parameters
  // ────────────────────────────────────────────────────────────
  parameter Real K_p_pll "PLL PI: proportional gain";
  parameter Real K_i_pll "PLL PI: integral gain";
  parameter Real OmegaMaxPu "Maximum PLL frequency (pu)";
  parameter Real OmegaMinPu "Minimum PLL frequency (pu)";
  parameter Real Theta0 "Initial PLL angle (rad)";
  // ────────────────────────────────────────────────────────────
  // Outer-loop PI slew-rate limits & i_d_ref ramp limiter
  // ────────────────────────────────────────────────────────────
  parameter Real DyMax_pi_d "Maximum rate of change of d-axis outer PI output (pu/s)";
  parameter Real DyMax_pi_q "Maximum rate of change of q-axis outer PI output (pu/s)";
  parameter Real DuMax_idref "Maximum rate of change of i_d_ref (pu/s)";
  parameter Real DuMin_idref "Minimum rate of change of i_d_ref (pu/s)";
  parameter Real tS_idref "Sample/update time of i_d_ref ramp limiter (s)";
  parameter Real delay_time_plant "Time delay between plant controller output and outer loop (s)";
  parameter Real voltagefeedforwardflag "If 0 no feedforward pplied, else 1";
  final parameter Real P0Pu = -P0_pcc;
  final parameter Real Q0Pu = -Q0_pcc;
  final parameter Complex u0Pu_init = Complex(UrPcc0Pu, UiPcc0Pu);
  final parameter Real U0Sq = UrPcc0Pu^2 + UiPcc0Pu^2;
  final parameter Real U0Pu = sqrt(U0Sq);
  final parameter Real IrPcc0Pu = (-P0_pcc*UrPcc0Pu - Q0_pcc*UiPcc0Pu)/U0Sq;
  final parameter Real IiPcc0Pu = (-P0_pcc*UiPcc0Pu + Q0_pcc*UrPcc0Pu)/U0Sq;
  final parameter Real L_g = LfPu + LPuLV "grid inductance (pu)";
  final parameter Real R_g = RfPu + RPuLV "grid resistance (pu)";
  final parameter Complex i0Pu_init = Complex(IrPcc0Pu, IiPcc0Pu);
  final parameter Real IrConv0Pu = IrPcc0Pu - Omega0Pu*CfPu*ucaP0Pu_init.im "Initial real part of converter current (pu)";
  final parameter Real IiConv0Pu = IiPcc0Pu + Omega0Pu*CfPu*ucaP0Pu_init.re "Initial imaginary part of converter current (pu)";
  final parameter Real Id_conv_0 = IrConv0Pu*cos(Theta0) + IiConv0Pu*sin(Theta0) "Initial d-axis converter current (pu)";
  final parameter Real Iq_conv_0 = -IrConv0Pu*sin(Theta0) + IiConv0Pu*cos(Theta0) "Initial q-axis converter current (pu)";
  final parameter Complex Z_f = Complex(RPuHV + RPuLV, Omega0Pu*(LPuHV + LPuLV));
  final parameter Complex Z_g = Complex(R_g + RPuHV, Omega0Pu*(L_g + LPuHV));
  final parameter Real QInj0Pu = -Q0_pcc + LPuHV*(IrPcc0Pu^2 + IiPcc0Pu^2) "Intial reactive power in pu in gnerator convenction";
  final parameter Real PInj0Pu = -P0_pcc + RPuHV*(IrPcc0Pu^2 + IiPcc0Pu^2) "Intial reactive power in pu in gnerator convenction";
  final parameter Real V_q_g_0 = -u0Pu_init.re*sin(Theta0) + u0Pu_init.im*cos(Theta0);
  final parameter Complex uconv0Pu_init = u0Pu_init - i0Pu_init*Z_g;
  final parameter Complex ucaP0Pu_init = u0Pu_init - i0Pu_init*Z_f;
  final parameter Real Uq0Pu = -uconv0Pu_init.re*sin(Theta0) + uconv0Pu_init.im*cos(Theta0);
  final parameter Real Ud0Pu = uconv0Pu_init.re*cos(Theta0) + uconv0Pu_init.im*sin(Theta0);
  final parameter Complex Z_HV = Complex(RPuHV, Omega0Pu*LPuHV);
  // Tensione nodo LV iniziale: u_LV = u_PCC + i_PCC * Z_HV
  final parameter Complex uLV0Pu_init = u0Pu_init - i0Pu_init*Z_HV;
  final parameter Real Ud_LV0Pu =
  uLV0Pu_init.re*cos(Theta0) + uLV0Pu_init.im*sin(Theta0);
final parameter Real Uq_LV0Pu =
 -uLV0Pu_init.re*sin(Theta0) + uLV0Pu_init.im*cos(Theta0);

  Dynawo.Connectors.ACPower terminalPcc(V(re(start = UrPcc0Pu), im(start = UiPcc0Pu)), i(re(start = IrPcc0Pu), im(start = IiPcc0Pu))) annotation(
    Placement(transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -80}, extent = {{-20, -20}, {20, 20}})));
  GFLControl gFLControl(Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu, id_ref_0 = Id_conv_0, id_conv_0 = Id_conv_0, iq_ref_0 = Iq_conv_0, iq_conv_0 = Iq_conv_0, DyMax_pi_d = DyMax_pi_d, DyMax_pi_q = DyMax_pi_q, DuMax_idref = DuMax_idref, DuMin_idref = DuMin_idref, tS_idref = tS_idref, delay_time_plant = delay_time_plant, k_p_d_current = k_p_d_current, k_i_d_current = k_i_d_current, k_p_q_current = k_p_q_current, k_i_q_current = k_i_q_current, L_g = L_g, R_g = R_g, vd_0 = Ud0Pu, vq_0 = Uq0Pu, vmd_0 = Ud0Pu, vmq_0 = Uq0Pu, k_p_d_outer = k_p_d_outer, k_i_d_outer = k_i_d_outer, k_p_q_outer = k_p_q_outer, k_i_q_outer = k_i_q_outer, Imax = Imax, PQFlag = PQFlag, UboostHigh = UboostHigh, UboostLow = UboostLow, Kqv = Kqv, IqBoostMax = IqBoostMax, IqBoostMin = IqBoostMin, K_p_pll = K_p_pll, K_i_pll = K_i_pll, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0, voltagefeedforwardflag = voltagefeedforwardflag, vm0 = uconv0Pu_init, U_LV0 = sqrt(uLV0Pu_init.re^2 + uLV0Pu_init.im^2), Uq0Pu = V_q_g_0) annotation(
    Placement(transformation(origin = {-95, 47}, extent = {{-17, -17}, {17, 17}})));
  Plant_controller plant_controller(Kp_q = K_p_q_plant, Ki_q = K_i_q_plant, Kp_p = K_p_p_plant, Ki_p = K_i_p_plant, Lambda = Lambda, Kdroop = Kdroop, QMaxPu = QMaxPu, QMinPu = QMinPu, PMaxPu = PMaxPu, PMinPu = PMinPu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, DbdPu = DbdPu, U0Pu = U0Pu, Q0Pu = Q0Pu, P0Pu = P0Pu, Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu) annotation(
    Placement(transformation(origin = {-151, 53}, extent = {{-17, -17}, {17, 17}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) annotation(
    Placement(transformation(origin = {-209, 59}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-118, 72}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput UREfPu(start = U0Pu) annotation(
    Placement(transformation(origin = {-209, 43}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Controls.PEIR.BaseControls.Average.VSC_with_pade_delay vSC_with_pade_delay(tVSC = tVSC, UreConv0Pu = uconv0Pu_init.re, UimConv0Pu = uconv0Pu_init.im) annotation(
    Placement(transformation(origin = {-38, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) annotation(
    Placement(transformation(origin = {-81, 109}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));
  // ── Internal LV node ──────────────────
  // ── PCC node ───────────────────────
  MeasurementBlock measurementBlock(UrPcc0Pu = UrPcc0Pu, UiPcc0Pu = UiPcc0Pu, IrPcc0Pu = IrPcc0Pu, IiPcc0Pu = IiPcc0Pu, Theta0 = Theta0, U0_pcc = U0Pu, k_filter = k_filter, T_filter = T_filter, P0_pcc = P0Pu, Q0_pcc = Q0Pu, U_pcc_q_0 = V_q_g_0, I_conv_d_0 = Id_conv_0, I_conv_q_0 = Iq_conv_0, I_conv_re_0 = IrConv0Pu, I_conv_im_0 = IiConv0Pu, u_LV_re_0 = uLV0Pu_init.re, u_LV_im_0 = uLV0Pu_init.im, P0_LV = PInj0Pu, Q0_LV = QInj0Pu, V_LV_d_0 = Ud_LV0Pu, V_LV_q_0 = Uq_LV0Pu) annotation(
    Placement(transformation(origin = {-92, -42}, extent = {{-26, -26}, {26, 26}}, rotation = 90)));
  LCDynFilter lCDynFilter(uLeft_rePu0 = uconv0Pu_init.re, uLeft_imPu0 = uconv0Pu_init.im, iRight_rePu0 = IrPcc0Pu, iRight_imPu0 = IiPcc0Pu, omegaPu0 = Omega0Pu, iLeft_rePu0 = IrConv0Pu, iLeft_imPu0 = IiConv0Pu, uRight_rePu0 = ucaP0Pu_init.re, uRight_imPu0 = ucaP0Pu_init.im, RfPu = RfPu, LfPu = LfPu, CfPu = CfPu, omegaNom = omegaNom) annotation(
    Placement(transformation(origin = {1, 53}, extent = {{-11, -11}, {11, 11}})));
  RLDynTrafo TrafoLV(RPu = RPuLV, LPu = LPuLV, Omega0Pu = Omega0Pu, Ir0Pu = IrPcc0Pu, Ii0Pu = IiPcc0Pu) annotation(
    Placement(transformation(origin = {39, 53}, extent = {{-10, -10}, {10, 10}})));
  RLDynTrafo TrafoHV(RPu = RPuHV, LPu = LPuHV, Omega0Pu = Omega0Pu, Ir0Pu = IrPcc0Pu, Ii0Pu = IiPcc0Pu) annotation(
    Placement(transformation(origin = {79, 53}, extent = {{-10, -10}, {10, 10}})));
  // Nodo LV intermedio tra TrafoLV e TrafoHV
  Dynawo.Connectors.ACPower terminalLV(V(re(start = uLV0Pu_init.re), im(start = uLV0Pu_init.im)), i(re(start = IrPcc0Pu), im(start = IiPcc0Pu))) annotation(
    Placement(transformation(origin = {61, 55}, extent = {{-5, -5}, {5, 5}}), iconTransformation(origin = {60, 50}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(PRefPu, plant_controller.PRefPu) annotation(
    Line(points = {{-209, 59}, {-209, 61}, {-170, 61}, {-170, 61.5}}, color = {220, 138, 221}, thickness = 0.75));
  connect(UREfPu, plant_controller.URefPu) annotation(
    Line(points = {{-209, 43}, {-189.5, 43}, {-189.5, 45}, {-170, 45}}, color = {220, 138, 221}, thickness = 0.75));
  connect(omegaRefPu, gFLControl.omegaRefPU) annotation(
    Line(points = {{-80, 110}, {-80, 90}, {-83, 90}, {-83, 66}}, color = {220, 138, 221}, thickness = 0.75));
  connect(plant_controller.PInjRefPu, gFLControl.P_ref) annotation(
    Line(points = {{-131, 59}, {-114, 59}}, color = {255, 120, 0}, thickness = 0.75));
  connect(plant_controller.omegaPLLPu, gFLControl.omega_pll_pu_2) annotation(
    Line(points = {{-132, 51}, {-132, 54}, {-114, 54}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(gFLControl.Q_ref, plant_controller.QInjRefPu) annotation(
    Line(points = {{-114, 49}, {-122, 49}, {-122, 45}, {-131, 45}}, color = {255, 120, 0}, thickness = 0.75));
  connect(gFLControl.vm_re, vSC_with_pade_delay.uReConvRefPu) annotation(
    Line(points = {{-76, 55.5}, {-61.5, 55.5}, {-61.5, 60}, {-49, 60}}, color = {249, 240, 107}, thickness = 0.75));
  connect(gFLControl.vm_im, vSC_with_pade_delay.uImConvRefPu) annotation(
    Line(points = {{-76, 48}, {-55.5, 48}, {-55.5, 54}, {-48.25, 54}, {-48.25, 56}, {-49, 56}}, color = {249, 240, 107}, thickness = 0.75));
  connect(measurementBlock.theta_pll, gFLControl.theta_pll) annotation(
    Line(points = {{-70, -14}, {-70, 35}, {-76, 35}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(measurementBlock.U_pcc_q, gFLControl.V_q_grid) annotation(
    Line(points = {{-120, -20}, {-123, -20}, {-123, 40}, {-122, 40}, {-122, 44.75}, {-114, 44.75}, {-114, 38.5}}, color = {220, 138, 221}, thickness = 0.75));
  connect(measurementBlock.U_pcc_pu_abs, plant_controller.UfiltPu) annotation(
    Line(points = {{-120, -30}, {-120, 34}, {-141, 34}}, color = {220, 138, 221}, thickness = 0.75));
  connect(measurementBlock.Q_plant, plant_controller.QfiltPu) annotation(
    Line(points = {{-120, -38}, {-120, -36}, {-150, -36}, {-150, 34}}, color = {220, 138, 221}, thickness = 0.75));
  connect(measurementBlock.P_plant, plant_controller.PfiltPu) annotation(
    Line(points = {{-120, -44}, {-120, -42}, {-158, -42}, {-158, 34}}, color = {220, 138, 221}, thickness = 0.75));
  connect(measurementBlock.P_LV, gFLControl.P_meas) annotation(
    Line(points = {{-112, -14}, {-112, 28}, {-109, 28}}, color = {255, 120, 0}, thickness = 0.75));
  connect(measurementBlock.Q_LV, gFLControl.Q_meas) annotation(
    Line(points = {{-104, -14}, {-105, -14}, {-105, -12}, {-106, -12}, {-106, 28}, {-103, 28}}, color = {255, 120, 0}, thickness = 0.75));
  connect(measurementBlock.I_conv_q, gFLControl.i_q_meas) annotation(
    Line(points = {{-98, -14}, {-96, -14}, {-96, -12}, {-98, -12}, {-98, 29}, {-96, 29}, {-96, 28}}, color = {249, 240, 107}, thickness = 0.75));
  connect(measurementBlock.I_conv_d, gFLControl.i_d_meas) annotation(
    Line(points = {{-92, -14}, {-92, 28}}, color = {249, 240, 107}, thickness = 0.75));
  connect(measurementBlock.V_LV_d, gFLControl.V_d_meas) annotation(
    Line(points = {{-84, -14}, {-84, 28}, {-87, 28}}, color = {255, 120, 0}, thickness = 0.75));
  connect(measurementBlock.V_LV_q, gFLControl.V_q_meas) annotation(
    Line(points = {{-76, -14}, {-77, -14}, {-77, -12}, {-76, -12}, {-76, 28}, {-83, 28}}, color = {255, 120, 0}, thickness = 0.75));
  connect(vSC_with_pade_delay.uReConvPu, lCDynFilter.uLeft_rePu) annotation(
    Line(points = {{-26, 60}, {-12, 60}}, color = {249, 240, 107}, thickness = 0.75));
  connect(vSC_with_pade_delay.uImConvPu, lCDynFilter.uLeft_imPu) annotation(
    Line(points = {{-26, 54}, {-12, 54}}, color = {249, 240, 107}, thickness = 0.75));
  connect(lCDynFilter.omegaPu, gFLControl.omega_pll_pu) annotation(
    Line(points = {{-6, 40}, {-41, 40}, {-41, 42}, {-76, 42}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(lCDynFilter.terminalRight, TrafoLV.left) annotation(
    Line(points = {{12, 54}, {13, 54}, {13, 53}, {29, 53}}, color = {0, 0, 255}));
  connect(TrafoHV.right, terminalPcc) annotation(
    Line(points = {{89, 53}, {100, 53}, {100, 50}, {110, 50}}, color = {0, 0, 255}));
  connect(TrafoLV.omegaPu, gFLControl.omega_pll_pu) annotation(
    Line(points = {{40, 42}, {-76, 42}}, color = {153, 193, 241}, thickness = 0.75));
  connect(TrafoHV.omegaPu, gFLControl.omega_pll_pu) annotation(
    Line(points = {{80, 42}, {-76, 42}}, color = {0, 0, 127}));
  connect(measurementBlock.I_conv_re, lCDynFilter.iLeft_rePu) annotation(
    Line(points = {{-64, -18}, {-12, -18}, {-12, 50}}, color = {0, 0, 127}));
  connect(measurementBlock.I_conv_im, lCDynFilter.iLeft_imPu) annotation(
    Line(points = {{-64, -24}, {-12, -24}, {-12, 44}}, color = {0, 0, 127}));
  connect(TrafoLV.right, terminalLV) annotation(
    Line(points = {{50, 54}, {61, 54}, {61, 55}}, color = {0, 0, 255}));
  connect(TrafoHV.left, terminalLV) annotation(
    Line(points = {{70, 54}, {65, 54}, {65, 55}, {61, 55}}, color = {0, 0, 255}));
// Tensione nodo LV (tra TrafoLV e TrafoHV)
  measurementBlock.u_LV_re = terminalLV.V.re;
  measurementBlock.u_LV_im = terminalLV.V.im;
// Tensione al PCC
  measurementBlock.V_pcc_re = terminalPcc.V.re;
  measurementBlock.V_pcc_im = terminalPcc.V.im;
  measurementBlock.I_pcc_re = -terminalPcc.i.re;
  measurementBlock.I_pcc_im = -terminalPcc.i.im;
  annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-80, 20}, {80, -20}}, textString = "GFL model")}),
    Diagram(coordinateSystem(extent = {{-200, -200}, {100, 100}})));
end GFLmodel;