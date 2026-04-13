within Dynawo.Electrical.PEIR.Plants.Average;

model GFLModel
  // ────────────────────────────────────────────────────────────
  // Network initial conditions (PCC, LV side)
  // ────────────────────────────────────────────────────────────
  parameter Real UrPcc0Pu
    "Initial real part of PCC (LV) voltage (pu)";
  parameter Real UiPcc0Pu
    "Initial imaginary part of PCC (LV) voltage (pu)";

  parameter Real P0_pcc
    "Initial active power at PCC (pu, load convention >0 into converter)";
  parameter Real Q0_pcc
    "Initial reactive power at PCC (pu, load convention >0 into converter)";

  parameter Real Omega0Pu
    "Initial per-unit frequency (pu) – nominal operating point";


  // ────────────────────────────────────────────────────────────
  // VSC delay
  // ────────────────────────────────────────────────────────────
  parameter Real tVSC
    "VSC Pade delay time constant (s)";


  // ────────────────────────────────────────────────────────────
  // LC filter (converter-side filter)
  // ────────────────────────────────────────────────────────────
  parameter Real RfPu
    "Filter series resistance R_f (pu, base UNom, SNom)";
  parameter Real LfPu
    "Filter series inductance L_f (pu, base UNom, SNom)";
  parameter Real CfPu
    "Filter shunt capacitance C_f (pu, base UNom, SNom)";

  parameter Real omegaNom
    "Nominal angular frequency ω_nom (rad/s) used as base";


  // ────────────────────────────────────────────────────────────
  // RL transformer / grid equivalent (LV side)
  // ────────────────────────────────────────────────────────────
  parameter Real RPu
    "Transformer / grid series resistance (pu, LV side)";
  parameter Real LPu
    "Transformer / grid series inductance (pu, LV side)";

  // L_g = LPu + LfPu, R_g = RPu + RfPu are derived below as final parameters


  // ────────────────────────────────────────────────────────────
  // Measurement filter
  // ────────────────────────────────────────────────────────────
  parameter Real k_filter
    "Measurement filter gain";
  parameter Real T_filter
    "Measurement filter time constant (s)";


  // ────────────────────────────────────────────────────────────
  // Inner and outer current controllers (converter control)
  // ────────────────────────────────────────────────────────────
  // Inner current loop gains
  parameter Real k_p_d_current
    "Inner current loop PI: proportional gain on d-axis";
  parameter Real k_i_d_current
    "Inner current loop PI: integral gain on d-axis";
  parameter Real k_p_q_current
    "Inner current loop PI: proportional gain on q-axis";
  parameter Real k_i_q_current
    "Inner current loop PI: integral gain on q-axis";

  // Outer P/Q loop gains
  parameter Real k_p_d_outer
    "Outer loop PI: proportional gain on d-axis (active power)";
  parameter Real k_i_d_outer
    "Outer loop PI: integral gain on d-axis (active power)";
  parameter Real k_p_q_outer
    "Outer loop PI: proportional gain on q-axis (reactive/voltage)";
  parameter Real k_i_q_outer
    "Outer loop PI: integral gain on q-axis (reactive/voltage)";

  parameter Real Imax
    "Maximum converter current magnitude (pu)";
  parameter Boolean PQFlag
    "Priority flag: false = Q-priority, true = P-priority";
  

  // Reactive power boost around voltage thresholds
  parameter Real UboostHigh
    "High-voltage threshold for reactive power boost (pu)";
  parameter Real UboostLow
    "Low-voltage threshold for reactive power boost (pu)";
  parameter Real Kqv
    "Reactive boost gain dIq/dU (pu/pu), 0 to disable";
  parameter Real IqBoostMax
    "Maximum additional Iq boost (pu)";
  parameter Real IqBoostMin
    "Minimum additional Iq boost (pu)";


  // ────────────────────────────────────────────────────────────
  // Plant controller (P–f and Q–U droop and PI loops)
  // ────────────────────────────────────────────────────────────
  parameter Real K_p_q_plant
    "Plant Q/U PI: proportional gain on Q (pu/pu)";
  parameter Real K_i_q_plant
    "Plant Q/U PI: integral gain on Q (pu/pu·s)";

  parameter Real K_p_p_plant
    "Plant P/f PI: proportional gain on P (pu/pu)";
  parameter Real K_i_p_plant
    "Plant P/f PI: integral gain on P (pu/pu·s)";

  parameter Real Lambda
    "Voltage–reactive droop coefficient λ in U + λ·Q (pu U / pu Q)";

  parameter Real Kdroop
    "Frequency droop gain on active power (pu/pu)";

  parameter Real QMaxPu
    "Maximum reactive power reference (pu)";
  parameter Real QMinPu
    "Minimum reactive power reference (pu)";

  parameter Real PMaxPu
    "Maximum active power reference (pu)";
  parameter Real PMinPu
    "Minimum active power reference (pu)";

  parameter Real FEMaxPu
    "Maximum frequency error after droop limiter (pu)";
  parameter Real FEMinPu
    "Minimum frequency error after droop limiter (pu)";

  parameter Real FDbd1Pu
    "Inner frequency deadband limit (pu, lower/first threshold)";
  parameter Real FDbd2Pu
    "Outer frequency deadband limit (pu, upper/second threshold)";

  parameter Real DbdPu
    "Voltage error deadband half-width in U + λ·Q loop (pu)";


  // ────────────────────────────────────────────────────────────
  // PLL parameters
  // ────────────────────────────────────────────────────────────
  parameter Real K_p_pll
    "PLL PI: proportional gain";
  parameter Real K_i_pll
    "PLL PI: integral gain";

  parameter Real OmegaMaxPu
    "Maximum PLL frequency (pu)";
  parameter Real OmegaMinPu
    "Minimum PLL frequency (pu)";

  parameter Real Theta0
    "Initial PLL angle (rad)";


  // ────────────────────────────────────────────────────────────
  // Outer-loop PI slew-rate limits & i_d_ref ramp limiter
  // ────────────────────────────────────────────────────────────
  parameter Real DyMax_pi_d
    "Maximum rate of change of d-axis outer PI output (pu/s)";
  parameter Real DyMax_pi_q
    "Maximum rate of change of q-axis outer PI output (pu/s)";

  parameter Real DuMax_idref
    "Maximum rate of change of i_d_ref (pu/s)";
  parameter Real DuMin_idref
    "Minimum rate of change of i_d_ref (pu/s)";
  parameter Real tS_idref
    "Sample/update time of i_d_ref ramp limiter (s)";

  parameter Real delay_time_plant
    "Time delay between plant controller output and outer loop (s)";

final parameter Complex u0Pu_init =
  Complex(UrPcc0Pu, UiPcc0Pu); 


final parameter Real U0Sq = UrPcc0Pu^2 + UiPcc0Pu^2;
final parameter Real U0Pu = sqrt(U0Sq);
final parameter Real IrPcc0Pu =
  (-P0_pcc*UrPcc0Pu -Q0_pcc*UiPcc0Pu)/U0Sq;

final parameter Real IiPcc0Pu =
  (-P0_pcc*UiPcc0Pu + Q0_pcc*UrPcc0Pu)/U0Sq;




  
  
  final parameter Real L_g= LPu+LfPu "grid inductance (pu)";
  final parameter Real R_g= RPu+RfPu "grid resistance (pu)";


  
final parameter Complex i0Pu_init =
  Complex(IrPcc0Pu, IiPcc0Pu);
  final parameter Real IrConv0Pu =
  IrPcc0Pu - Omega0Pu * omegaNom * CfPu * uFilter0Pu_init.im
  "Initial real part of converter current (pu)";

final parameter Real IiConv0Pu =
  IiPcc0Pu + Omega0Pu * omegaNom * CfPu * uFilter0Pu_init.re
  "Initial imaginary part of converter current (pu)";
  final parameter Real Id_conv_0 =
   IrConv0Pu * cos(Theta0) + IiConv0Pu * sin(Theta0)
  "Initial d-axis converter current (pu)";

final parameter Real Iq_conv_0 =
  -IrConv0Pu * sin(Theta0) + IiConv0Pu * cos(Theta0)
  "Initial q-axis converter current (pu)";
 final parameter Complex Z_f =
  Complex(RfPu, Omega0Pu*LfPu);
 final parameter Complex Z_g =
  Complex(R_g, Omega0Pu*L_g);
  final parameter Real QInj0Pu =-Q0_pcc + L_g*(IrPcc0Pu^2 + IiPcc0Pu^2) "Intial reactive power in pu in gnerator convenction";
  final parameter Real PInj0Pu = -P0_pcc + R_g*(IrPcc0Pu^2 + IiPcc0Pu^2)"Intial reactive power in pu in gnerator convenction";
  final parameter Real V_q_g_0=-u0Pu_init.re * sin(Theta0) + u0Pu_init.im * cos(Theta0);
final parameter Complex uFilter0Pu_init =
  u0Pu_init - i0Pu_init*Z_g;
  final parameter Complex ucap0Pu_init =
  u0Pu_init - i0Pu_init*Z_f;
  final parameter Real Uq0Pu =
   -uFilter0Pu_init.re * sin(Theta0) + uFilter0Pu_init.im * cos(Theta0);
     final parameter Real Ud0Pu =
    uFilter0Pu_init.re * cos(Theta0) + uFilter0Pu_init.im * sin(Theta0);
  // ── Sub-blocks ───────────────────────────────────────────────
GFLControl control_GFL_(
  // Complex initial conditions
  u0Pu       = u0Pu_init,
  i0Pu       = i0Pu_init,
  uFilter0Pu = uFilter0Pu_init,
  P0Pu       = -P0_pcc,
  Q0Pu       = -Q0_pcc,
  Omega0Pu   = Omega0Pu,

  // Inner current loop
  k_p_d_current = k_p_d_current,
  k_i_d_current = k_i_d_current,
  k_p_q_current = k_p_q_current,
  k_i_q_current = k_i_q_current,
  L_g           = L_g,
  R_g           = R_g,

  // Outer P/Q loop
  k_p_d_outer = k_p_d_outer,
  k_i_d_outer = k_i_d_outer,
  k_p_q_outer = k_p_q_outer,
  k_i_q_outer = k_i_q_outer,
  Imax        = Imax,
  PQFlag      = PQFlag,

  // Reactive power boost
  UboostHigh = UboostHigh,
  UboostLow  = UboostLow,
  Kqv        = Kqv,
  IqBoostMax = IqBoostMax,
  IqBoostMin = IqBoostMin,

  // PLL
  K_p_pll    = K_p_pll,
  K_i_pll    = K_i_pll,
  OmegaMaxPu = OmegaMaxPu,
  OmegaMinPu = OmegaMinPu,
  Theta0     = Theta0,

  // Converter-side initial conditions
  PInj0Pu   = PInj0Pu,
  QInj0Pu   = QInj0Pu,
  vd_0      = Ud0Pu,
  vq_0      = Uq0Pu,
  vmd_0     = Ud0Pu,
  vmq_0     = Uq0Pu,
  id_ref_0  = Id_conv_0,
  id_conv_0 = Id_conv_0,
  iq_ref_0  = Iq_conv_0,
  iq_conv_0 = Iq_conv_0,
  PInjPu0   = PInj0Pu,
  QInjPu0   = QInj0Pu,
  U_filter0 = sqrt(uFilter0Pu_init.re^2 + uFilter0Pu_init.im^2),

  // PI output slew-rate limits and i_d_ref ramp limiter (if still used in GFLControl)
  DyMax_pi_d       = DyMax_pi_d,
  DyMax_pi_q       = DyMax_pi_q,
  DuMax_idref      = DuMax_idref,
  DuMin_idref      = DuMin_idref,
  tS_idref         = tS_idref,
  delay_time_plant = delay_time_plant)
annotation(
  Placement(transformation(origin = {-86, 38}, extent = {{-24, -24}, {24, 24}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.VSC_with_pade_delay vsc_converter_delay_pade(
    tVSC      = tVSC,
    UdConv0Pu =  Ud0Pu,
    UqConv0Pu = Uq0Pu) annotation(
    Placement(transformation(origin = {3, 81}, extent = {{-17, -17}, {17, 17}})));
LCDynFilter lCFilter_RI(
  RfPu     = RfPu,
  LfPu     = LfPu,
  CfPu     = CfPu,
  omegaNom = omegaNom,

  // Left-side initial voltage and current (converter side)
  uLeft_rePu0 = uFilter0Pu_init.re,
  uLeft_imPu0 = uFilter0Pu_init.im,
  iLeft_rePu0 = IrConv0Pu,
  iLeft_imPu0 = IiConv0Pu,

  // Frequency initial condition
  omegaPu0    = Omega0Pu,

  // Right-side initial current and voltage (PCC side)
  iRight_rePu0 = IrPcc0Pu,
  iRight_imPu0 = IiPcc0Pu,
  uRight_rePu0 = ucap0Pu_init.re,
  uRight_imPu0 = ucap0Pu_init.im) annotation(
  Placement(transformation(origin = {58, 76}, extent = {{-20, -20}, {20, 20}})));


RLDynTrafo rLTRansformer_RI(
  RPu = RPu,      // oppure RPu_LV se hai separato LV/HV
  LPu = LPu,      // idem per L

  // Initial currents on the right side (towards PCC/grid)
  IrRight0Pu = IrPcc0Pu,
  IiRight0Pu = IiPcc0Pu,

  // Initial voltages on the left side (filter side)
  UrLeft0Pu  = ucap0Pu_init.re,
  UiLeft0Pu  = ucap0Pu_init.im,

  // Initial voltages on the right side (PCC side)
  UrRight0Pu = UrPcc0Pu,
  UiRight0Pu = UiPcc0Pu,

  // Initial frequency
  Omega0Pu   = Omega0Pu) annotation(
  Placement(transformation(origin = {137, 77}, extent = {{-22, -22}, {22, 22}})));

 
  Dynawo.Connectors.ACPower terminal(
    V(re(start = UrPcc0Pu), im(start = UiPcc0Pu)),
    i(re(start = IrPcc0Pu), im(start = IiPcc0Pu))) annotation(
    Placement(transformation(origin = {184, 76}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {319, 43}, extent = {{-17, -17}, {17, 17}})));
MeasurementBlock measurement_block1(
  UrPcc0Pu   = UrPcc0Pu,
  UiPcc0Pu   = UiPcc0Pu,
  IrPcc0Pu   = IrPcc0Pu,
  IiPcc0Pu   = IiPcc0Pu,
  Theta0     = Theta0,
  k_filter   = k_filter,
  T_filter   = T_filter,
  U0_pcc     = U0Pu,
  P0_pcc     = -P0_pcc,
  Q0_pcc     = -Q0_pcc,
  P0_conv    = PInj0Pu,
  Q0_conv    = QInj0Pu,
  U_pcc_q_0  = V_q_g_0,
  V_conv_d_0 = Ud0Pu,
  V_conv_q_0 = Uq0Pu,
  u_filter_re_0 = ucap0Pu_init.re,
  u_filter_im_0 = ucap0Pu_init.im,
  I_conv_d_0 = Id_conv_0,
  I_conv_q_0 = Iq_conv_0,
  I_conv_re_0 = IrConv0Pu,
  I_conv_im_0 = IiConv0Pu
) annotation(
  Placement(transformation(origin = {-85, -91},
                           extent = {{-29, -29}, {29, 29}},
                           rotation = 90)));

 // ── External inputs ──────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput U_ref_pcc_pu (start=U0Pu) "Voltage reference at PCC for plant controller (pu)" annotation(
    Placement(transformation(origin = {-209, 37}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-318, 180}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput omegaRefPu (start=Omega0Pu)
    "Frequency reference (pu)" annotation(
    Placement(transformation(origin = {-68, 94}, extent = {{-10, -10}, {10, 10}}, rotation = -90),
    iconTransformation(origin = {-320, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput PRefPu (start=-P0_pcc)
    "Active power reference (pu)" annotation(
    Placement(transformation(origin = {-208, 56}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-320, -120}, extent = {{-20, -20}, {20, 20}})));
 Plant_controller plant_controller(Kp_q = K_p_q_plant, Ki_q = K_i_q_plant, Kp_p = K_p_p_plant, Ki_p = K_i_p_plant, Lambda = Lambda, Kdroop = Kdroop, QMaxPu = QMaxPu, QMinPu = QMinPu, PMaxPu = PMaxPu, PMinPu = PMinPu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, DbdPu = DbdPu, U0Pu = U0Pu, Q0Pu = -Q0_pcc, P0Pu = -P0_pcc, Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu)  annotation(
    Placement(transformation(origin = {-169, 47}, extent = {{-19, -19}, {19, 19}})));
equation

  // ── Terminal connections ─────────────────────────────────────
  terminal.V.re = rLTRansformer_RI.urRightPu;
  terminal.V.im = rLTRansformer_RI.uiRightPu;

  terminal.i.re = -rLTRansformer_RI.irRightPu;
  terminal.i.im = -rLTRansformer_RI.iiRightPu;

  // ── Measurement block PCC voltage ────────────────────────────
  // Connected directly from terminal to avoid double-binding with transformer
  measurement_block1.V_pcc_re = terminal.V.re;
  measurement_block1.V_pcc_im = terminal.V.im;

  // ── Control → VSC ────────────────────────────────────────────
  connect(control_GFL_.vm_re, vsc_converter_delay_pade.udConvRefPu) annotation(
    Line(points = {{-60, 50}, {-38.5, 50}, {-38.5, 88}, {-16, 88}}, color = {97, 53, 131}, thickness = 0.75));
  connect(control_GFL_.vm_im, vsc_converter_delay_pade.uqConvRefPu) annotation(
    Line(points = {{-60, 40}, {-27.5, 40}, {-27.5, 78}, {-16, 78}}, color = {97, 53, 131}, thickness = 0.75));

  // ── VSC → LC filter ──────────────────────────────────────────






  // ── Measurement block → control ──────────────────────────────

  connect(measurement_block1.theta_pll, control_GFL_.theta_pll) annotation(
    Line(points = {{-59, -59}, {-59, 20}, {-60, 20}, {-60, 21}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(measurement_block1.P_conv, control_GFL_.P_meas) annotation(
    Line(points = {{-108, -59}, {-108, 10.5}, {-106, 10.5}, {-106, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.Q_conv, control_GFL_.Q_meas) annotation(
    Line(points = {{-99.5, -59}, {-99.5, 12.5}, {-98, 12.5}, {-98, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_conv_q, control_GFL_.i_q_meas) annotation(
    Line(points = {{-91, -59}, {-91, 10.75}, {-89, 10.75}, {-89, 10.5}, {-88, 10.5}, {-88, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_conv_d, control_GFL_.i_d_meas) annotation(
    Line(points = {{-84, -59}, {-84, 10.5}, {-80, 10.5}, {-80, 10.25}, {-82, 10.25}, {-82, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.V_d_conv, control_GFL_.V_d_meas) annotation(
    Line(points = {{-76, -59}, {-76, -61.5}, {-77, -61.5}, {-77, 11.25}, {-73, 11.25}, {-73, 9.625}, {-77, 9.625}, {-77, 10.8125}, {-75, 10.8125}, {-75, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.V_q_conv, control_GFL_.V_q_meas) annotation(
    Line(points = {{-68, -59}, {-68, 12.5}, {-69, 12.5}, {-69, 12}}, color = {97, 53, 131}, thickness = 0.75));
// ── LC filter → measurement block ────────────────────────────
  connect(plant_controller.PInjRefPu, control_GFL_.P_ref) annotation(
    Line(points = {{-147, 54}, {-129.5, 54}, {-129.5, 55}, {-112, 55}}, color = {0, 0, 127}));
 connect(control_GFL_.Q_ref, plant_controller.QInjRefPu) annotation(
    Line(points = {{-112, 40}, {-129.5, 40}, {-129.5, 38}, {-147, 38}}, color = {0, 0, 127}));
 connect(PRefPu, plant_controller.PRefPu) annotation(
    Line(points = {{-208, 56}, {-200, 56}, {-200, 56.5}, {-190, 56.5}}, color = {0, 0, 127}));
 connect(plant_controller.omegaPLLPu, control_GFL_.omega_pll_pu_2) annotation(
    Line(points = {{-148, 45}, {-148, 46}, {-112, 46}, {-112, 48}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
 connect(U_ref_pcc_pu, plant_controller.URefPu) annotation(
    Line(points = {{-209, 37}, {-199, 37}, {-199, 38}, {-190, 38}}, color = {0, 0, 127}));
 connect(lCFilter_RI.uLeft_rePu, vsc_converter_delay_pade.ureConvPu) annotation(
    Line(points = {{34, 88}, {22, 88}}, color = {0, 0, 127}));
 connect(vsc_converter_delay_pade.uimConvPu, lCFilter_RI.uLeft_imPu) annotation(
    Line(points = {{22, 78}, {34, 78}}, color = {0, 0, 127}));
 connect(lCFilter_RI.uRight_rePu, rLTRansformer_RI.urLeftPu) annotation(
    Line(points = {{82, 90}, {99.5, 90}, {99.5, 94}, {111, 94}}, color = {0, 0, 127}));
 connect(lCFilter_RI.uRight_imPu, rLTRansformer_RI.uiLeftPu) annotation(
    Line(points = {{82, 80}, {96.5, 80}, {96.5, 82}, {111, 82}}, color = {0, 0, 127}));
 connect(lCFilter_RI.iRight_rePu, rLTRansformer_RI.irRightPu) annotation(
    Line(points = {{82, 69}, {99.5, 69}, {99.5, 68}, {111, 68}}, color = {0, 0, 127}));
 connect(lCFilter_RI.iRight_imPu, rLTRansformer_RI.iiRightPu) annotation(
    Line(points = {{82, 60}, {114, 60}, {114, 59}, {111, 59}}, color = {0, 0, 127}));
 connect(plant_controller.PfiltPu, measurement_block1.P_plant) annotation(
    Line(points = {{-177, 26}, {-173.5, 26}, {-173.5, -94}, {-116, -94}}, color = {0, 0, 127}));
 connect(measurement_block1.U_pcc_pu_abs, plant_controller.UfiltPu) annotation(
    Line(points = {{-116, -78}, {-116, -76}, {-158, -76}, {-158, 26}}, color = {0, 0, 127}));
 connect(control_GFL_.omega_pll_pu, lCFilter_RI.omegaPu) annotation(
    Line(points = {{-60, 31}, {-60, 52}, {46, 52}}, color = {0, 0, 127}));
 connect(rLTRansformer_RI.omegaPu, control_GFL_.omega_pll_pu) annotation(
    Line(points = {{137, 51}, {137, 31}, {-60, 31}}, color = {0, 0, 127}));
 connect(lCFilter_RI.iLeft_rePu, measurement_block1.I_conv_re) annotation(
    Line(points = {{34, 69}, {34, -66}, {-54, -66}, {-54, -64}}, color = {0, 0, 127}));
 connect(measurement_block1.I_conv_im, lCFilter_RI.iLeft_imPu) annotation(
    Line(points = {{-54, -70}, {34, -70}, {34, 60}}, color = {0, 0, 127}));
 connect(lCFilter_RI.uRight_rePu, measurement_block1.u_filter_re) annotation(
    Line(points = {{82, 90}, {59, 90}, {59, -82}, {-54, -82}}, color = {0, 0, 127}));
 connect(measurement_block1.u_filter_im, lCFilter_RI.uRight_imPu) annotation(
    Line(points = {{-54, -90}, {82, -90}, {82, 80}}, color = {0, 0, 127}));
 connect(lCFilter_RI.iRight_rePu, measurement_block1.I_pcc_re) annotation(
    Line(points = {{82, 69}, {82, -96}, {-54, -96}}, color = {0, 0, 127}));
 connect(measurement_block1.I_pcc_im, lCFilter_RI.iRight_imPu) annotation(
    Line(points = {{-54, -104}, {82, -104}, {82, 60}}, color = {0, 0, 127}));
 connect(measurement_block1.Q_plant, plant_controller.QfiltPu) annotation(
    Line(points = {{-116, -86}, {-168, -86}, {-168, 26}}, color = {0, 0, 127}));
 connect(measurement_block1.U_pcc_q, control_GFL_.V_q_grid) annotation(
    Line(points = {{-116, -68}, {-116, 26}, {-112, 26}}, color = {0, 0, 127}));
 connect(omegaRefPu, control_GFL_.omegaRefPU) annotation(
    Line(points = {{-68, 94}, {-68, 64}}, color = {0, 0, 127}));

annotation(
  Diagram(
    coordinateSystem(extent = {{-200, -200}, {200, 200}})),
  uses(Modelica(version = "3.2.3")),
  Icon(
    coordinateSystem(extent = {{-300, -300}, {300, 300}}),
    graphics = {
      Rectangle(extent = {{-300, 300}, {300, -300}}),
      Text(
        origin = {0, 60},
        extent = {{-240, 30}, {240, -30}},
        textString = "GFL Plant Model"),
      Text(
        origin = {0, -20},
        extent = {{-300, 20}, {300, -20}},
        textString = "LC filter + RL trafo + control")
    }));


end GFLModel;