within Dynawo.Electrical.PEIR.Plants.Average;

model GFLModel

  // ── Initial conditions ───────────────────────────────────────
  // PCC voltage and current (real/imaginary parts)
  parameter Real UrPcc0Pu "Initial real part of PCC voltage (pu)";
  parameter Real UiPcc0Pu "Initial imaginary part of PCC voltage (pu)";

  // ── Power initial conditions ─────────────────────────────────
  parameter Real P0_pcc  "Initial active power at PCC (pu)";
  parameter Real Q0_pcc  "Initial reactive power at PCC (pu)";



final parameter Real U0Sq = UrPcc0Pu^2 + UiPcc0Pu^2;
final parameter Real U0Pu = sqrt(U0Sq);
final parameter Real IrPcc0Pu =
  (P0_pcc*UrPcc0Pu + Q0_pcc*UiPcc0Pu)/U0Sq;

final parameter Real IiPcc0Pu =
  (P0_pcc*UiPcc0Pu - Q0_pcc*UrPcc0Pu)/U0Sq;
  parameter Real Omega0Pu  "Initial frequency (pu) — nominal";



  // ── VSC delay ────────────────────────────────────────────────
  parameter Real tVSC       "VSC Pade delay time constant (s)";


  // ── LC filter (Thevenin equivalent of filter) ────────────────
  // R_f and L_f are the filter resistance and inductance
  // C_f is the filter capacitance
  parameter Real RfPu    "Filter resistance (pu)";
  parameter Real LfPu    "Filter inductance (pu)";
  parameter Real CfPu    "Filter capacitance (pu)";
  parameter Real omegaNom "Nominal angular frequency (rad/s)";
  

  // ── RL transformer (Thevenin equivalent of grid inductance) ──
  // R and L are the transformer/line resistance and inductance
  parameter Real RPu "Transformer resistance (pu)";
  parameter Real LPu "Transformer inductance (pu)";
  
  final parameter Real L_g=LfPu+LPu "grid inductance (pu)";
  final parameter Real   R_g=RfPu+RPu "grid resistance (pu)";

  // ── Measurement filter ───────────────────────────────────────
  parameter Real k_filter "Measurement filter gain";
  parameter Real T_filter "Measurement filter time constant (s)";
  // ── Control Parameters ───────────────────────────────────────
  parameter Real k_p_d_current "Current Loop Proportional gain PI d axis";
  parameter Real k_i_d_current "Current Loop Integral gain PI d axis";
  parameter Real k_p_q_current "Current Loop Proportional gain PI q axis";
  parameter Real k_i_q_current "Current Loop Integral gain PI q axis";
  parameter Real k_p_d_outer "Current Loop Proportional gain PI d axis";
  parameter Real k_i_d_outer "Current Loop Integral gain PI d axis";
  parameter Real k_p_q_outer "Current Loop Proportional gain PI q axis";
  parameter Real k_i_q_outer "Current Loop Integral gain PI q axis";
  parameter Real Imax "Maximum current (pu)";
  parameter Boolean PQFlag "Qfalse, P true priority";
  parameter Real k_q_outer "Outer loop Q/V gain";
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
  final  parameter Complex u0Pu_init =
  Complex(UrPcc0Pu, UiPcc0Pu);

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
  final parameter Real QInj0Pu =-Q0_pcc + L_g*sqrt(IrPcc0Pu^2 + IiPcc0Pu^2) "Intial reactive power in pu in gnerator convenction";
  final parameter Real PInj0Pu = -P0_pcc + R_g*sqrt(IrPcc0Pu^2 + IiPcc0Pu^2)"Intial reactive power in pu in gnerator convenction";
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
  GFLControl control_GFL_ (u0Pu= u0Pu_init, i0Pu=i0Pu_init, uFilter0Pu=uFilter0Pu_init, P0Pu=-P0_pcc, Q0Pu=-Q0_pcc, Omega0Pu=Omega0Pu, k_p_d_current=k_p_d_current,k_i_d_current=k_i_d_current, k_p_q_current=k_p_q_current, k_i_q_current=k_i_q_current, L_g=L_g, R_g=R_g,  k_p_d_outer=k_p_d_outer,k_i_d_outer=k_i_d_outer, k_p_q_outer=k_p_q_outer, k_i_q_outer=k_i_q_outer, Imax=Imax, PQFlag=PQFlag, k_q_outer = k_q_outer, UboostStart = UboostStart, Kqv = Kqv, IqBoostMax = IqBoostMax, IqBoostMin = IqBoostMin, dPrefMaxPu = dPrefMaxPu, dQrefMaxPu = dQrefMaxPu, K_p_q_plant = K_p_q_plant, K_i_q_plant = K_i_q_plant, K_p_p_plant = K_p_p_plant, K_i_p_plant = K_i_p_plant, Lambda = Lambda, Kdroop_p = Kdroop_p, QMaxPu = QMaxPu, QMinPu = QMinPu, PMaxPu = PMaxPu, PMinPu = PMinPu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, DbdPu = DbdPu, U0Pu = U0Pu, Q0Pu_param = -Q0_pcc, P0Pu_param = -P0_pcc, K_p_pll = K_p_pll, K_i_pll = K_i_pll, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, vd_0 = Ud0Pu, vq_0 = Uq0Pu, vmd_0 = Ud0Pu, vmq_0 = Uq0Pu, id_ref_0 = Id_conv_0, id_conv_0 = Id_conv_0, iq_ref_0 = Iq_conv_0, iq_conv_0 = Iq_conv_0, PInjPu0 = PInj0Pu, QInjPu0 = QInj0Pu, U_filter0 = sqrt(uFilter0Pu_init.re^2 + uFilter0Pu_init.im^2)) annotation(
    Placement(transformation(origin = {-88, 38}, extent = {{-24, -24}, {24, 24}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.VSC_with_pade_delay vsc_converter_delay_pade(
    tVSC      = tVSC,
    UdConv0Pu =  Ud0Pu,
    UqConv0Pu = Uq0Pu) annotation(
    Placement(transformation(origin = {3, 81}, extent = {{-17, -17}, {17, 17}})));

  LCDynFilter lCFilter_RI(
    RfPu    = RfPu,
    LfPu    = LfPu,
    CfPu    = CfPu,
    omegaNom = omegaNom, urConvPu0 = uFilter0Pu_init.re, uiConvPu0 = uFilter0Pu_init.im, iConv_rePu0 = IrConv0Pu, iConv_imPu0 = IiConv0Pu, omegaPu0 = Omega0Pu, iPcc_rePu0 = IrPcc0Pu, iPcc_imPu0 = IiPcc0Pu, uFilt_rePu0 = ucap0Pu_init.re, uFilt_imPu0 = ucap0Pu_init.im) annotation(
    Placement(transformation(origin = {64, 76}, extent = {{-20, -20}, {20, 20}})));

  RLDynTrafo rLTRansformer_RI(
    RPu       = RPu,
    LPu       = LPu,
    IrPcc0Pu  = IrPcc0Pu,
    IiPcc0Pu  = IiPcc0Pu,
    UrPcc0Pu  = UrPcc0Pu,
    UiPcc0Pu  = UiPcc0Pu,
    Omega0Pu  = Omega0Pu, UrFilter0Pu = ucap0Pu_init.re, UiFilter0Pu = ucap0Pu_init.im) annotation(
    Placement(transformation(origin = {159, 75}, extent = {{-22, -22}, {22, 22}})));

  Dynawo.Connectors.ACPower terminal(
    V(re(start = UrPcc0Pu), im(start = UiPcc0Pu)),
    i(re(start = IrPcc0Pu), im(start = IiPcc0Pu))) annotation(
    Placement(transformation(origin = {210, 78}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {219, 9}, extent = {{-17, -17}, {17, 17}})));

  MeasurementBlock measurement_block1(
    UrPcc0Pu=UrPcc0Pu,
    UiPcc0Pu=UiPcc0Pu,
    IrPcc0Pu=IrPcc0Pu,
    IiPcc0Pu=IiPcc0Pu,
    Theta0=Theta0,
    k_filter = k_filter,
    T_filter = T_filter,
    U0_pcc = U0Pu,    
    P0_pcc   = -P0_pcc,
    Q0_pcc   = -Q0_pcc,
    P0_conv  = PInj0Pu,
    Q0_conv  = QInj0Pu,
    U_pcc_q_0=V_q_g_0,
    V_conv_d_0=Ud0Pu,
    V_conv_q_0=Uq0Pu,
    u_filter_re_0=uFilter0Pu_init.re,
    u_filter_im_0=uFilter0Pu_init.im,
    I_conv_d_0 = Id_conv_0,
    I_conv_q_0 = Iq_conv_0,
    I_conv_re_0 = IrConv0Pu,
    I_conv_im_0 = IiConv0Pu
    ) annotation(
    Placement(transformation(origin = {-85, -31}, extent = {{-29, -29}, {29, 29}}, rotation = 90)));

  // ── External inputs ──────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput u_ref_conv
    "Voltage reference for converter inner loop (pu)" annotation(
    Placement(transformation(origin = {-118, 96}, extent = {{-12, -12}, {12, 12}}, rotation = -90),
    iconTransformation(origin = {-220, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput U_ref_pcc_pu
    "Voltage reference at PCC for plant controller (pu)" annotation(
    Placement(transformation(origin = {-81, 95}, extent = {{-9, -9}, {9, 9}}, rotation = -90),
    iconTransformation(origin = {-220, 122}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput omegaRefPu
    "Frequency reference (pu)" annotation(
    Placement(transformation(origin = {-54, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 180),
    iconTransformation(origin = {-220, -42}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput PRefu
    "Active power reference (pu)" annotation(
    Placement(transformation(origin = {-98, 92}, extent = {{-10, -10}, {10, 10}}, rotation = -90),
    iconTransformation(origin = {-222, -122}, extent = {{-20, -20}, {20, 20}})));

equation

  // ── Terminal connections ─────────────────────────────────────
  rLTRansformer_RI.urPccPu = terminal.V.re;
  rLTRansformer_RI.uiPccPu = terminal.V.im;
  terminal.i.re = -rLTRansformer_RI.irPccPu;
  terminal.i.im = -rLTRansformer_RI.iiPccPu;

  // ── Measurement block PCC voltage ────────────────────────────
  // Connected directly from terminal to avoid double-binding with transformer
  measurement_block1.V_pcc_re = terminal.V.re;
  measurement_block1.V_pcc_im = terminal.V.im;

  // ── Control → VSC ────────────────────────────────────────────
  connect(control_GFL_.vm_re, vsc_converter_delay_pade.udConvRefPu) annotation(
    Line(points = {{-62, 50}, {-38.5, 50}, {-38.5, 88}, {-16, 88}}, color = {97, 53, 131}, thickness = 0.75));
  connect(control_GFL_.vm_im, vsc_converter_delay_pade.uqConvRefPu) annotation(
    Line(points = {{-62, 40}, {-27.5, 40}, {-27.5, 78}, {-16, 78}}, color = {97, 53, 131}, thickness = 0.75));

  // ── VSC → LC filter ──────────────────────────────────────────
  connect(lCFilter_RI.urConvPu, vsc_converter_delay_pade.ureConvPu) annotation(
    Line(points = {{40, 88}, {22, 88}}, color = {97, 53, 131}, pattern = LinePattern.Dash));
  connect(vsc_converter_delay_pade.uimConvPu, lCFilter_RI.uiConvPu) annotation(
    Line(points = {{22, 78}, {40, 78}}, color = {97, 53, 131}, pattern = LinePattern.Dash, thickness = 0.75));

  // ── Omega PLL → LC filter and transformer ────────────────────
  connect(control_GFL_.omega_pll_pu, lCFilter_RI.omegaPu) annotation(
    Line(points = {{-62, 31}, {51.5, 31}, {51.5, 52}, {52, 52}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(rLTRansformer_RI.omegaPu, control_GFL_.omega_pll_pu) annotation(
    Line(points = {{159, 49}, {159, 30}, {-62, 30}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));

  // ── LC filter → RL transformer ───────────────────────────────
  connect(lCFilter_RI.iPcc_rePu, rLTRansformer_RI.irPccPu) annotation(
    Line(points = {{88, 69}, {107.5, 69}, {107.5, 66}, {133, 66}}, color = {38, 162, 105}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(lCFilter_RI.uFilt_rePu, rLTRansformer_RI.urFilterPu) annotation(
    Line(points = {{88, 90}, {109.5, 90}, {109.5, 92}, {133, 92}}, color = {38, 162, 105}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(lCFilter_RI.uFilt_imPu, rLTRansformer_RI.uiFilterPu) annotation(
    Line(points = {{88, 80}, {133, 80}}, color = {38, 162, 105}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(lCFilter_RI.iPcc_imPu, rLTRansformer_RI.iiPccPu) annotation(
    Line(points = {{88, 60}, {111, 60}, {111, 57}, {133, 57}}, color = {38, 162, 105}, pattern = LinePattern.Dash, thickness = 0.75));

  // ── External references → control ────────────────────────────
  connect(u_ref_conv, control_GFL_.U_ref_pu) annotation(
    Line(points = {{-118, 96}, {-118, 78}, {-102, 78}, {-102, 64}}, color = {97, 53, 131}, thickness = 0.75));
  connect(U_ref_pcc_pu, control_GFL_.U_ref_pcc_pu) annotation(
    Line(points = {{-80, 96}, {-80, 64}}, color = {38, 162, 105}, thickness = 0.75));
  connect(omegaRefPu, control_GFL_.omegaRefPU) annotation(
    Line(points = {{-54, 90}, {-70, 90}, {-70, 64}}, color = {38, 162, 105}, thickness = 0.75));
  connect(control_GFL_.P_ref_pu, PRefu) annotation(
    Line(points = {{-92, 64}, {-98, 64}, {-98, 92}}, color = {99, 69, 44}, thickness = 0.75));


  // ── Measurement block → control ──────────────────────────────
  connect(measurement_block1.U_pcc_pu_abs, control_GFL_.U_pu_plant_c) annotation(
    Line(points = {{-117, -11}, {-117, 22}, {-114, 22}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.U_pcc_q, control_GFL_.V_q_grid) annotation(
    Line(points = {{-117, -19}, {-126, -19}, {-126, 32}, {-114, 32}, {-114, 30}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.Q_plant, control_GFL_.Q_plant_pu) annotation(
    Line(points = {{-117, -26}, {-136, -26}, {-136, 41.875}, {-114, 41.875}, {-114, 40}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.P_plant, control_GFL_.P_plant_c) annotation(
    Line(points = {{-117, -34}, {-146, -34}, {-146, 50}, {-114, 50}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.theta_pll, control_GFL_.theta_pll) annotation(
    Line(points = {{-59, 1}, {-59, 20}, {-62, 20}, {-62, 22}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(measurement_block1.P_conv, control_GFL_.P_meas) annotation(
    Line(points = {{-108, 1}, {-108, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.Q_conv, control_GFL_.Q_meas) annotation(
    Line(points = {{-99.5, 1}, {-99.5, 2.5}, {-100, 2.5}, {-100, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_conv_q, control_GFL_.i_q_meas) annotation(
    Line(points = {{-91, 1}, {-91, 2.5}, {-90, 2.5}, {-90, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_conv_d, control_GFL_.i_d_meas) annotation(
    Line(points = {{-84, 1}, {-84, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.V_d_conv, control_GFL_.V_d_meas) annotation(
    Line(points = {{-76, 1}, {-76, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.V_q_conv, control_GFL_.V_q_meas) annotation(
    Line(points = {{-68, 1}, {-68, 6.5}, {-70, 6.5}, {-70, 12}}, color = {97, 53, 131}, thickness = 0.75));

  // ── LC filter → measurement block ────────────────────────────
  connect(measurement_block1.I_conv_re, lCFilter_RI.iConv_rePu) annotation(
    Line(points = {{-53, -5}, {34, -5}, {34, 69.5}, {40, 69.5}, {40, 70}}, color = {97, 53, 131}, thickness = 0.75));
  connect(lCFilter_RI.iConv_imPu, measurement_block1.I_conv_im) annotation(
    Line(points = {{40, 60}, {41, 60}, {41, -11}, {-53, -11}}, color = {97, 53, 131}, thickness = 0.75));
  connect(lCFilter_RI.uFilt_rePu, measurement_block1.u_filter_re) annotation(
    Line(points = {{88, 90}, {81.25, 90}, {81.25, -22}, {-53, -22}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.u_filter_im, lCFilter_RI.uFilt_imPu) annotation(
    Line(points = {{-53, -29}, {90, -29}, {90, 80}, {88, 80}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_pcc_re, lCFilter_RI.iPcc_rePu) annotation(
    Line(points = {{-53, -37}, {100, -37}, {100, 68}, {88, 68}, {88, 70}}, color = {38, 162, 105}, thickness = 0.75));
  connect(lCFilter_RI.iPcc_imPu, measurement_block1.I_pcc_im) annotation(
    Line(points = {{88, 60}, {91.125, 60}, {91.125, 50}, {106.5, 50}, {106.5, -44}, {-53, -44}}, color = {38, 162, 105}, thickness = 0.75));
  annotation(
    Diagram(
      coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}),
      graphics = {
        Rectangle(extent = {{-200, 200}, {200, -200}}),
        Text(origin = {0, 30}, extent = {{-160, 30}, {160, -30}},
             textString = "GFL Plant Model"),
        Text(origin = {0, -20}, extent = {{-160, 20}, {160, -20}},
             textString = "LC filter + RL trafo + control")}));

end GFLModel;