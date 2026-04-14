within Dynawo.Electrical.PEIR.Plants.Average;

model GFLmodelnodyn
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
  parameter Real RPuHV
    "Transformer / grid series resistance (pu, HV side)";
  parameter Real LPuHV
    "Transformer / grid series inductance (pu, HV side)";
  parameter Real RPuLV
    "Transformer / grid series resistance (pu, LV side)";
  parameter Real LPuLV
    "Transformer / grid series inductance (pu, LV side)";

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
       
  parameter Real voltagefeedforwardflag "If 0 no feedforward pplied, else 1";
final parameter Real P0Pu=-P0_pcc;
final parameter Real Q0Pu=-Q0_pcc;
final parameter Complex u0Pu_init =
  Complex(UrPcc0Pu, UiPcc0Pu); 


final parameter Real U0Sq = UrPcc0Pu^2 + UiPcc0Pu^2;
final parameter Real U0Pu = sqrt(U0Sq);
final parameter Real IrPcc0Pu =
  (-P0_pcc*UrPcc0Pu -Q0_pcc*UiPcc0Pu)/U0Sq;

final parameter Real IiPcc0Pu =
  (-P0_pcc*UiPcc0Pu + Q0_pcc*UrPcc0Pu)/U0Sq;




  
  
  final parameter Real L_g= LfPu +LPuLV "grid inductance (pu)";
  final parameter Real R_g= RfPu +RPuLV"grid resistance (pu)";


  
final parameter Complex i0Pu_init =
  Complex(IrPcc0Pu, IiPcc0Pu);
  final parameter Real IrConv0Pu =
  IrPcc0Pu - Omega0Pu * omegaNom * CfPu * ucaP0Pu_init.im
  "Initial real part of converter current (pu)";

final parameter Real IiConv0Pu =
  IiPcc0Pu + Omega0Pu * omegaNom * CfPu * ucaP0Pu_init.re
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
  Complex(R_g+RPuHV, Omega0Pu*(L_g+LPuHV));
  final parameter Real QInj0Pu =-Q0_pcc + LPuHV*(IrPcc0Pu^2 + IiPcc0Pu^2) "Intial reactive power in pu in gnerator convenction";
  final parameter Real PInj0Pu = -P0_pcc + RPuHV*(IrPcc0Pu^2 + IiPcc0Pu^2)"Intial reactive power in pu in gnerator convenction";
  final parameter Real V_q_g_0=-u0Pu_init.re * sin(Theta0) + u0Pu_init.im * cos(Theta0);
final parameter Complex uconv0Pu_init =
  u0Pu_init - i0Pu_init*Z_g;
  final parameter Complex ucaP0Pu_init =
  u0Pu_init - i0Pu_init*Z_f;
  final parameter Real Uq0Pu =
   -uconv0Pu_init.re * sin(Theta0) + uconv0Pu_init.im * cos(Theta0);
     final parameter Real Ud0Pu =
    uconv0Pu_init.re * cos(Theta0) + uconv0Pu_init.im * sin(Theta0);
    
   final parameter Complex Z_HV =
    Complex(RPuHV, Omega0Pu*LPuHV);

  // Tensione nodo LV iniziale: u_LV = u_PCC + i_PCC * Z_HV
  final parameter Complex uLV0Pu_init =
    u0Pu_init + i0Pu_init * Z_HV;
  Dynawo.Connectors.ACPower terminalInt(
    V(re(start = uLV0Pu_init.re), im(start = uLV0Pu_init.im)),
    i(re(start = IrPcc0Pu),      im(start = IiPcc0Pu))) annotation(
    Placement(transformation(origin = {140, 46}, extent = {{-10, -10}, {10, 10}}),
              iconTransformation(origin = {0, -80}, extent = {{-20, -20}, {20, 20}})));
  GFLControl gFLControl( Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu, id_ref_0 = Id_conv_0, id_conv_0 = Id_conv_0, iq_ref_0 = Iq_conv_0, iq_conv_0 = Iq_conv_0, DyMax_pi_d = DyMax_pi_d, DyMax_pi_q = DyMax_pi_q, DuMax_idref = DuMax_idref, DuMin_idref = DuMin_idref, tS_idref = tS_idref, delay_time_plant = delay_time_plant, k_p_d_current = k_p_d_current, k_i_d_current = k_i_d_current, k_p_q_current = k_p_q_current, k_i_q_current = k_i_q_current, L_g = L_g, R_g = R_g, vd_0 = Ud0Pu, vq_0 = Uq0Pu, vmd_0 = Ud0Pu, vmq_0 = Uq0Pu, k_p_d_outer = k_p_d_outer, k_i_d_outer = k_i_d_outer, k_p_q_outer = k_p_q_outer, k_i_q_outer = k_i_q_outer, Imax = Imax,   PQFlag = PQFlag, UboostHigh = UboostHigh, UboostLow = UboostLow, Kqv = Kqv, IqBoostMax = IqBoostMax, IqBoostMin = IqBoostMin, K_p_pll = K_p_pll, K_i_pll = K_i_pll, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0, voltagefeedforwardflag = voltagefeedforwardflag, vm0 = uconv0Pu_init, U_LV0 = sqrt(uLV0Pu_init.re^2 + uLV0Pu_init.im^2), Uq0Pu = V_q_g_0)  annotation(
    Placement(transformation(origin = {-11, 47}, extent = {{-17, -17}, {17, 17}})));
  Plant_controller plant_controller(Kp_q = K_p_q_plant, Ki_q = K_i_q_plant, Kp_p = K_p_p_plant, Ki_p = K_i_p_plant, Lambda = Lambda, Kdroop = Kdroop, QMaxPu = QMaxPu, QMinPu = QMinPu, PMaxPu = PMaxPu, PMinPu = PMinPu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, DbdPu = DbdPu, U0Pu = U0Pu, Q0Pu = Q0Pu, P0Pu = P0Pu, Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu)  annotation(
    Placement(transformation(origin = {-65, 51}, extent = {{-17, -17}, {17, 17}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu (start=P0Pu)annotation(
    Placement(transformation(origin = {-109, 59}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-118, 72}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput UREfPu (start=U0Pu) annotation(
    Placement(transformation(origin = {-109, 41}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  LCnoDynFilter lCnoDynFilter(uLeft_rePu0 = uconv0Pu_init.re, uLeft_imPu0 = uconv0Pu_init.im, iRight_rePu0 = IrPcc0Pu, iRight_imPu0 = IiPcc0Pu, omegaPu0 = Omega0Pu, RfPu = RfPu, LfPu = LfPu, CfPu = CfPu, iLeft_rePu0 = IrConv0Pu, iLeft_imPu0 = IiConv0Pu, uRight_rePu0 = ucaP0Pu_init.re, uRight_imPu0 = ucaP0Pu_init.im, omegaNom = omegaNom)  annotation(
    Placement(transformation(origin = {66, 66}, extent = {{-10, -10}, {10, 10}})));
  Controls.PEIR.BaseControls.Average.VSC_with_pade_delay vSC_with_pade_delay(tVSC = tVSC, UreConv0Pu = uconv0Pu_init.re, UimConv0Pu = uconv0Pu_init.im)  annotation(
    Placement(transformation(origin = {26, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu (start=Omega0Pu) annotation(
    Placement(transformation(origin = {1, 95}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));
 // ── Internal LV node ──────────────────
  // ── PCC node ───────────────────────
  Dynawo.Connectors.ACPower terminalPCC (V(re(start = UrPcc0Pu), im(start = UiPcc0Pu)), i(re(start = IrPcc0Pu), im(start = IiPcc0Pu))) annotation(
    Placement(transformation(origin = {200, 3}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {122, 8}, extent = {{-20, -20}, {20, 20}})));
  trafoNoDyn trafoLV(RPu = RPuLV, LPu = LPuLV, Omega0Pu = Omega0Pu, IrRight0Pu = IrPcc0Pu, IiRight0Pu = IiPcc0Pu, UrLeft0Pu = ucaP0Pu_init.re, UiLeft0Pu = ucaP0Pu_init.im, UrRight0Pu = uLV0Pu_init.re, UiRight0Pu = uLV0Pu_init.im)  annotation(
    Placement(transformation(origin = {103, 47}, extent = {{-12, -12}, {12, 12}})));
  trafoNoDyn trafoHV(RPu = RPuHV, LPu = LPuHV, UrRight0Pu = UrPcc0Pu, UiRight0Pu = UiPcc0Pu, Omega0Pu = Omega0Pu, UrLeft0Pu = uLV0Pu_init.re, UiLeft0Pu = uLV0Pu_init.im, IrRight0Pu = IrPcc0Pu, IiRight0Pu = IiPcc0Pu)  annotation(
    Placement(transformation(origin = {164, 0}, extent = {{-13, -13}, {13, 13}})));
 MeasurementBlock measurementBlock(UrPcc0Pu = UrPcc0Pu, UiPcc0Pu = UiPcc0Pu, IrPcc0Pu = IrPcc0Pu, IiPcc0Pu = IiPcc0Pu, Theta0 = Theta0, U0_pcc = U0Pu, k_filter = k_filter, T_filter = T_filter, P0_pcc = P0Pu, Q0_pcc = Q0Pu, P0_conv = PInj0Pu, Q0_conv = QInj0Pu, U_pcc_q_0 = V_q_g_0, I_conv_d_0 = Id_conv_0, I_conv_q_0 = Iq_conv_0, V_conv_d_0 = Ud0Pu, V_conv_q_0 = Uq0Pu, I_conv_re_0 = IrConv0Pu, I_conv_im_0 = IiConv0Pu, u_filter_re_0 = uLV0Pu_init.re, u_filter_im_0 = uLV0Pu_init.im)  annotation(
    Placement(transformation(origin = {6, -54}, extent = {{-34, -34}, {34, 34}}, rotation = 90)));
equation
  connect(PRefPu, plant_controller.PRefPu) annotation(
    Line(points = {{-108, 60}, {-86, 60}, {-86, 59.5}, {-84, 59.5}}, color = {0, 0, 127}));
  connect(UREfPu, plant_controller.URefPu) annotation(
    Line(points = {{-108, 42}, {-84, 42}}, color = {0, 0, 127}));
  connect(plant_controller.PInjRefPu, gFLControl.P_ref) annotation(
    Line(points = {{-46, 58}, {-34, 58}, {-34, 59}, {-30, 59}}, color = {0, 0, 127}));
  connect(plant_controller.omegaPLLPu, gFLControl.omega_pll_pu_2) annotation(
    Line(points = {{-46, 50}, {-46, 52}, {-30, 52}, {-30, 54}}, color = {0, 0, 127}));
  connect(gFLControl.Q_ref, plant_controller.QInjRefPu) annotation(
    Line(points = {{-30, 49}, {-30, 46}, {-46, 46}, {-46, 42}}, color = {0, 0, 127}));
  connect(omegaRefPu, gFLControl.omegaRefPU) annotation(
    Line(points = {{1, 95}, {1, 66}}, color = {0, 0, 127}));
  connect(gFLControl.vm_re, vSC_with_pade_delay.uReConvRefPu) annotation(
    Line(points = {{8, 55.5}, {11, 55.5}, {11, 54}, {14, 54}}, color = {0, 0, 127}));
  connect(gFLControl.vm_im, vSC_with_pade_delay.uImConvRefPu) annotation(
    Line(points = {{8, 48}, {8, 46}, {14, 46}, {14, 48}}, color = {0, 0, 127}));
  connect(vSC_with_pade_delay.uReConvPu, lCnoDynFilter.uLeft_rePu) annotation(
    Line(points = {{38, 54}, {44, 54}, {44, 72}, {54, 72}}, color = {0, 0, 127}));
  connect(lCnoDynFilter.uLeft_imPu, vSC_with_pade_delay.uImConvPu) annotation(
    Line(points = {{54, 67}, {44, 67}, {44, 48}, {38, 48}}, color = {0, 0, 127}));
  connect(lCnoDynFilter.uRight_rePu, trafoLV.urLeftPu) annotation(
    Line(points = {{78, 73}, {81.5, 73}, {81.5, 56}, {89, 56}}, color = {0, 0, 127}));
  connect(lCnoDynFilter.uRight_imPu, trafoLV.uiLeftPu) annotation(
    Line(points = {{78, 68}, {81.5, 68}, {81.5, 50}, {89, 50}}, color = {0, 0, 127}));
  connect(lCnoDynFilter.iRight_rePu, trafoLV.irRightPu) annotation(
    Line(points = {{78, 63}, {80.5, 63}, {80.5, 42}, {89, 42}}, color = {0, 0, 127}));
  connect(lCnoDynFilter.iRight_imPu, trafoLV.iiRightPu) annotation(
    Line(points = {{78, 58}, {78, 38}, {88, 38}}, color = {0, 0, 127}));
 connect(gFLControl.omega_pll_pu, lCnoDynFilter.omegaPu) annotation(
    Line(points = {{8, 42}, {58, 42}, {58, 54}, {60, 54}}, color = {0, 0, 127}));
 connect(trafoLV.omegaPu, gFLControl.omega_pll_pu) annotation(
    Line(points = {{104, 32}, {54, 32}, {54, 42}, {8, 42}}, color = {0, 0, 127}));
 connect(trafoHV.omegaPu, gFLControl.omega_pll_pu) annotation(
    Line(points = {{164, -16}, {54, -16}, {54, 42}, {8, 42}}, color = {0, 0, 127}));
 connect(measurementBlock.U_pcc_q, gFLControl.V_q_grid) annotation(
    Line(points = {{-31, -26}, {-31, -25.5}, {-30, -25.5}, {-30, 38.5}}, color = {0, 0, 127}));
 connect(measurementBlock.U_pcc_pu_abs, plant_controller.UfiltPu) annotation(
    Line(points = {{-31, -39}, {-56, -39}, {-56, 32}}, color = {0, 0, 127}));
 connect(measurementBlock.Q_plant, plant_controller.QfiltPu) annotation(
    Line(points = {{-31, -49}, {-64, -49}, {-64, 32}}, color = {0, 0, 127}));
 connect(measurementBlock.P_plant, plant_controller.PfiltPu) annotation(
    Line(points = {{-31, -57}, {-74, -57}, {-74, 32}, {-72, 32}}, color = {0, 0, 127}));
 connect(measurementBlock.P_conv, gFLControl.P_meas) annotation(
    Line(points = {{-21, -17}, {-21, 10.5}, {-25, 10.5}, {-25, 28}}, color = {0, 0, 127}));
 connect(measurementBlock.I_conv_d, gFLControl.i_d_meas) annotation(
    Line(points = {{7, -17}, {7, 17.5}, {-8, 17.5}, {-8, 28}}, color = {0, 0, 127}));
 connect(measurementBlock.V_q_conv, gFLControl.V_q_meas) annotation(
    Line(points = {{26, -17}, {26, 28}, {1, 28}}, color = {0, 0, 127}));
 connect(measurementBlock.I_conv_re, lCnoDynFilter.iLeft_rePu) ;
 connect(measurementBlock.I_conv_im, lCnoDynFilter.iLeft_imPu);
 connect(measurementBlock.u_filter_re, trafoLV.urRightPu) ;
 connect(measurementBlock.u_filter_im, trafoLV.uiRightPu) ;
 connect(measurementBlock.I_pcc_re, trafoHV.irRightPu) ;
 connect(measurementBlock.I_pcc_im, trafoHV.iiRightPu) ;
 connect(measurementBlock.V_pcc_re, trafoHV.urRightPu) ;
 connect(measurementBlock.V_pcc_im, trafoHV.uiRightPu);
// Nodo LV interno: tensione lato right trafoLV = lato left trafoHV
trafoLV.urRightPu = trafoHV.urLeftPu;
trafoLV.uiRightPu = trafoHV.uiLeftPu;

// Terminale LV interno in generator convention
terminalInt.V.re = trafoLV.urRightPu;
terminalInt.V.im = trafoLV.uiRightPu;

terminalInt.i.re = - trafoLV.irRightPu;
terminalInt.i.im = -trafoLV.iiRightPu;
// Terminale PCC in load convention
terminalPCC.V.re = trafoHV.urRightPu;
terminalPCC.V.im = trafoHV.uiRightPu;

// Corrente positiva dal sistema verso l'impianto
terminalPCC.i.re = -trafoHV.irRightPu;
terminalPCC.i.im = -trafoHV.iiRightPu;
 connect(measurementBlock.theta_pll, gFLControl.theta_pll) annotation(
    Line(points = {{36, -16}, {37, -16}, {37, 36}, {8, 36}}, color = {0, 0, 127}));
 connect(measurementBlock.V_d_conv, gFLControl.V_d_meas) annotation(
    Line(points = {{16, -16}, {16, 21}, {-4, 21}, {-4, 28}}, color = {0, 0, 127}));
 connect(measurementBlock.I_conv_q, gFLControl.i_q_meas) annotation(
    Line(points = {{-2, -16}, {-1, -16}, {-1, 12}, {-12, 12}, {-12, 28}}, color = {0, 0, 127}));
 connect(measurementBlock.Q_conv, gFLControl.Q_meas) annotation(
    Line(points = {{-10, -16}, {-11, -16}, {-11, -14}, {-12, -14}, {-12, 4}, {-14, 4}, {-14, 17}, {-20, 17}, {-20, 28}}, color = {0, 0, 127}));

annotation(
    Diagram);
end GFLmodelnodyn;