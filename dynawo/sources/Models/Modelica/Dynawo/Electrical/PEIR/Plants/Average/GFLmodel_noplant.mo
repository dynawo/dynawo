within Dynawo.Electrical.PEIR.Plants.Average;

model GFLmodel_noplant

  /**
     * Author Gaia Bergamaschi
     * Grid-Following (GFL) average converter model.
     *
     * This model represents a voltage-source converter (VSC) plant connected to the
     * grid through an LC filter and a two-stage RL transformer. It includes:
     *   - A PLL-based synchronisation unit
     *   - Inner current controllers (d/q axes)
     *   - Outer P/Q control loops
     *   - A plant-level P–f and Q–U controller with droop
     *   - A VSC Padé delay block
     *   - A measurement/filter block
     *
     * Sign convention: load convention at the PCC (positive = power flowing into converter).
     * Sign convention: generator convention at the GFL (positive = power flowing out of the converter).
     * All electrical quantities are in per-unit on the machine base (UNom, SNom).
     */
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  // ────────────────────────────────────────────────────────────
  // Network initial conditions (PCC, LV side)
  // ────────────────────────────────────────────────────────────
  parameter Real U0Pu "Initial abs voltage at PCC, base UNom Pu";
  parameter Real Uphase "Initial phase of PCC voltage, rad";
  parameter Real P0_pcc "Initial active power at PCC (pu, load convention >0 into converter)";
  parameter Real Q0_pcc "Initial reactive power at PCC (pu, load convention >0 into converter)";
  parameter Real Omega0Pu = Dynawo.Electrical.SystemBase.omega0Pu "Initial per-unit frequency (pu) – nominal operating point";
  // ────────────────────────────────────────────────────────────
  // VSC Padé delay
  // ────────────────────────────────────────────────────────────
  parameter Real tVSC "VSC Pade delay time constant (s)";
  // ────────────────────────────────────────────────────────────
  // LC filter (converter-side output filter)
  // ────────────────────────────────────────────────────────────
  parameter Real RfPu "Filter series resistance R_f (pu, base UNom, SNom)";
  parameter Real LfPu "Filter series inductance L_f (pu, base UNom, SNom)";
  parameter Real CfPu "Filter shunt capacitance C_f (pu, base UNom, SNom)";
  parameter Real omegaNom = Dynawo.Electrical.SystemBase.omegaNom "Nominal angular frequency ω_nom (rad/s) used as base";
  // ────────────────────────────────────────────────────────────
  // RL transformer /  equivalent impedances (referred to LV and HV side)
  // ────────────────────────────────────────────────────────────
  parameter Real RPuHV "Transformer / grid series resistance (pu, base UNom, SNom, HV side)";
  parameter Real LPuHV "Transformer / grid series inductance (pu, base UNom, SNom, HV side)";
  parameter Real RPuLV "Transformer / grid series resistance (pu, base UNom, SNom, LV side)";
  parameter Real LPuLV "Transformer / grid series inductance (pu, base UNom, SNom, LV side)";
  // ────────────────────────────────────────────────────────────
  // Measurement block filter variables
  // ────────────────────────────────────────────────────────────
  parameter Real k_filter "Measurement filter gain";
  parameter Real T_filter "Measurement filter time constant (s)";
  // ────────────────────────────────────────────────────────────
  // Inner  current controllers (converter control)
  // ────────────────────────────────────────────────────────────
  parameter Real k_p_d_current "Inner current loop PI: proportional gain on d-axis";
  parameter Real k_i_d_current "Inner current loop PI: integral gain on d-axis";
  parameter Real k_p_q_current "Inner current loop PI: proportional gain on q-axis";
  parameter Real k_i_q_current "Inner current loop PI: integral gain on q-axis";
  // ────────────────────────────────────────────────────────────
  // Outer P/Q loop control loops (converter control)
  // ────────────────────────────────────────────────────────────
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
  parameter Real Lambda "Voltage–reactive droop coefficient λ in U + λ·Q (pu U / pu Q), (pu, base UNom, SNom)";
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
  final parameter Real Theta0 = Modelica.Math.atan2(ucaP0Pu_init.im, ucaP0Pu_init.re) "Initial PLL angle (rad)";
  // ────────────────────────────────────────────────────────────
  // Outer-loop PI slew-rate limits & i_d_ref ramp limiter
  // ────────────────────────────────────────────────────────────
  parameter Real DyMax_pi_d "Maximum rate of change of d-axis outer PI output (pu/s)";
  parameter Real DyMax_pi_q "Maximum rate of change of q-axis outer PI output (pu/s)";
  parameter Real DuMax_idref "Maximum rate of change of i_d_ref (pu/s)";
  parameter Real DuMin_idref "Minimum rate of change of i_d_ref (pu/s)";
  parameter Real tS_idref "Sample/update time of i_d_ref ramp limiter (s)";
  parameter Real delay_time_plant "Time delay between plant controller output and outer loop (s)";
  parameter Real voltagefeedforwardflag_d "1: apply v_d feed-forward for faster disturbance rejection | 0: PI only";
  parameter Real voltagefeedforwardflag_q "1: apply v_q feed-forward for faster disturbance rejection | 0: PI only";
  // ─────────────────────────────────────────────────────────────────────────
  // Derived initial conditions (computed from the parameters above)
  // ─────────────────────────────────────────────────────────────────────────
  // Sign change: generator convention (injection positive)
  final parameter Real P0Pu = -P0_pcc * SystemBase.SnRef / SNom;
  final parameter Real Q0Pu = -Q0_pcc * SystemBase.SnRef / SNom;
  // PCC voltage phasor and magnitude
  final parameter Complex terminalV     = ComplexMath.fromPolar(U0Pu, Uphase);
  final parameter Real UrPcc0Pu  = terminalV.re;
  final parameter Real UiPcc0Pu  = terminalV.im;
  final parameter Complex u0Pu_init = Complex(UrPcc0Pu, UiPcc0Pu);
  final parameter Real U0Sq = UrPcc0Pu^2 + UiPcc0Pu^2;
  // q-axis component of the PCC voltage in the PLL reference frame
  // (used as PLL initial condition; should be ≈ 0 at steady state)
  final parameter Real V_q_g_0 = -ucaP0Pu_init.re*sin(Theta0) + ucaP0Pu_init.im*cos(Theta0);
  // PCC current phasor (derived from S = U · I*) in re/im coordinates
  final parameter Real IrPcc0Pu = (P0Pu*UrPcc0Pu + Q0Pu*UiPcc0Pu)/U0Sq;
  final parameter Real IiPcc0Pu = (P0Pu*UiPcc0Pu - Q0Pu*UrPcc0Pu)/U0Sq;
  final parameter Complex i0Pu_init = Complex(IrPcc0Pu, IiPcc0Pu);
  // Converter-side current: PCC current corrected for the capacitor branch in re/im e d/q
  // by current drawn by C_f at the filter node
  final parameter Real IrConv0Pu = IrPcc0Pu - Omega0Pu*CfPu*ucaP0Pu_init.im "Initial real part of converter current (pu)";
  final parameter Real IiConv0Pu = IiPcc0Pu + Omega0Pu*CfPu*ucaP0Pu_init.re "Initial imaginary part of converter current (pu)";
  final parameter Real Id_conv_0 = IrConv0Pu*cos(Theta0) + IiConv0Pu*sin(Theta0) "Initial d-axis converter current (pu)";
  final parameter Real Iq_conv_0 = -IrConv0Pu*sin(Theta0) + IiConv0Pu*cos(Theta0) "Initial q-axis converter current (pu)";
  // Initial injected powers at the LV node (generator convention, corrected
  // for ohmic losses in the HV transformer stage)
  final parameter Real QInj0Pu = Q0Pu + LPuHV*(IrPcc0Pu^2 + IiPcc0Pu^2) "Intial reactive power in pu in gnerator convenction";
  final parameter Real PInj0Pu = P0Pu + RPuHV*(IrPcc0Pu^2 + IiPcc0Pu^2) "Intial reactive power in pu in gnerator convenction";
  // Equivalent grid impedance seen from the LV node
  final parameter Real L_g = LfPu + LPuLV "grid inductance (pu)";
  final parameter Real R_g = RfPu + RPuLV "grid resistance (pu)";
  // Impedance of the full series path: LV + HV transformer stages combine
  final parameter Complex Z_f = Complex(RPuHV + RPuLV, Omega0Pu*(LPuHV + LPuLV));
  // Total grid impedance seen from the converter AC terminals
  final parameter Complex Z_g = Complex(R_g + RPuHV, Omega0Pu*(L_g + LPuHV));
  // HV transformer impedance alone (used to locate the internal LV bus)
  final parameter Complex Z_HV = Complex(RPuHV, Omega0Pu*LPuHV);
  // Converter terminal voltage phasor
  final parameter Complex iConv0Pu_init = Complex(IrConv0Pu, IiConv0Pu);
  final parameter Complex Z_filt = Complex(RfPu, Omega0Pu*LfPu);
  final parameter Complex uconv0Pu_init = ucaP0Pu_init + iConv0Pu_init*Z_filt;
  // Converter terminal voltage decomposed into dq components
  final parameter Real Uq0Pu = -uconv0Pu_init.re*sin(Theta0) + uconv0Pu_init.im*cos(Theta0);
  final parameter Real Ud0Pu = uconv0Pu_init.re*cos(Theta0) + uconv0Pu_init.im*sin(Theta0);
  // Voltage at the filter capacitor node: PCC voltage plus the drop across
  // the combined transformer impedance Z_f
  final parameter Complex ucaP0Pu_init = u0Pu_init + i0Pu_init*Z_f;
  // Internal LV bus voltage: PCC voltage plus the voltage drop across Z_HV
  // This is the voltage at the junction between the two transformer stages in re/im e d/q
  final parameter Complex uLV0Pu_init = u0Pu_init + i0Pu_init*Z_HV;
  final parameter Real Ud_LV0Pu = uLV0Pu_init.re*cos(Theta0) + uLV0Pu_init.im*sin(Theta0);
  final parameter Real Uq_LV0Pu = -uLV0Pu_init.re*sin(Theta0) + uLV0Pu_init.im*cos(Theta0);
   parameter Real T_boost
    "Time constant of first-order filter on iq_boost (s) to delay the current boost response. Set 0 to disable";

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 12 – Component declarations
  // ─────────────────────────────────────────────────────────────────────────
  // PCC terminal – AC connector to the external network.
  // Voltage and current are initialised at the computed steady-state values.
  Dynawo.Connectors.ACPower terminalPcc(V(re(start = UrPcc0Pu), im(start = UiPcc0Pu)), i(re(start = -IrPcc0Pu * SNom / SystemBase.SnRef), im(start = -IiPcc0Pu * SNom / SystemBase.SnRef))) annotation(
    Placement(transformation(origin = {104, 54}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {80, 16}, extent = {{-20, -20}, {20, 20}})));
  // GFL converter controller block.
  // Implements: PLL, inner current PI loops, outer P/Q PI loops, current
  // limitation with P/Q priority, and reactive-power boost logic.
  GFLControl gFLControl(Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu, id_ref_0 = Id_conv_0, id_conv_0 = Id_conv_0, iq_ref_0 = Iq_conv_0, iq_conv_0 = Iq_conv_0, DyMax_pi_d = DyMax_pi_d, DyMax_pi_q = DyMax_pi_q, DuMax_idref = DuMax_idref, DuMin_idref = DuMin_idref, tS_idref = tS_idref, delay_time_plant = delay_time_plant, k_p_d_current = k_p_d_current, k_i_d_current = k_i_d_current, k_p_q_current = k_p_q_current, k_i_q_current = k_i_q_current, L_g = L_g, R_g = R_g, vd_0 = Ud0Pu, vq_0 = Uq0Pu, vmd_0 = Ud0Pu, vmq_0 = Uq0Pu, k_p_d_outer = k_p_d_outer, k_i_d_outer = k_i_d_outer, k_p_q_outer = k_p_q_outer, k_i_q_outer = k_i_q_outer, Imax = Imax, PQFlag = PQFlag, UboostHigh = UboostHigh, UboostLow = UboostLow, Kqv = Kqv, IqBoostMax = IqBoostMax, IqBoostMin = IqBoostMin, K_p_pll = K_p_pll, K_i_pll = K_i_pll, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0, vm0 = uconv0Pu_init, U_LV0 = sqrt(uLV0Pu_init.re^2 + uLV0Pu_init.im^2), Uq0Pu = V_q_g_0, voltagefeedforwardflag_d = voltagefeedforwardflag_d, voltagefeedforwardflag_q = voltagefeedforwardflag_q, T_boost = T_boost) annotation(
    Placement(transformation(origin = {-95, 47}, extent = {{-17, -17}, {17, 17}})));
  // Plant-level controller block.
  // Implements: P–f droop, Q–U droop, frequency and voltage deadbands,
  // PI loops for active and reactive power, and output limiter
  // External active power set-point input
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) annotation(
    Placement(transformation(origin = {-209, 61}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-118, 72}, extent = {{-20, -20}, {20, 20}})));
  // External voltage (reactive power) set-point input
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QInj0Pu) annotation(
    Placement(transformation(origin = {-209, 45}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  // Grid angular frequency reference (provided by the network / external bus model)
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) annotation(
    Placement(transformation(origin = {-83, 109}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));
  // VSC switching delay block (first-order Padé approximation).
  // Introduces a realistic delay between the voltage reference computed by the
  // controller and the actual converter output voltage
  Controls.PEIR.BaseControls.Average.VSC_with_pade_delay vSC_with_pade_delay(tVSC = tVSC, UreConv0Pu = uconv0Pu_init.re, UimConv0Pu = uconv0Pu_init.im) annotation(
    Placement(transformation(origin = {-40, 58}, extent = {{-10, -10}, {10, 10}})));
  // Measurement and filtering block.
  // Computes filtered signals for P, Q, U, I fom the PLL angle θ, the
  // instantaneous terminal voltages and currents at the PCC and LV node
  MeasurementBlock measurementBlock(UrPcc0Pu = UrPcc0Pu, UiPcc0Pu = UiPcc0Pu, IrPcc0Pu = IrPcc0Pu, IiPcc0Pu = IiPcc0Pu, Theta0 = Theta0, U0_pcc = U0Pu, k_filter = k_filter, T_filter = T_filter, P0_pcc = P0Pu, Q0_pcc = Q0Pu, U_pcc_q_0 = V_q_g_0, I_conv_d_0 = Id_conv_0, I_conv_q_0 = Iq_conv_0, I_conv_re_0 = IrConv0Pu, I_conv_im_0 = IiConv0Pu, u_LV_re_0 = uLV0Pu_init.re, u_LV_im_0 = uLV0Pu_init.im, P0_LV = PInj0Pu, Q0_LV = QInj0Pu, V_LV_d_0 = Ud_LV0Pu, V_LV_q_0 = Uq_LV0Pu) annotation(
    Placement(transformation(origin = {-90, -106}, extent = {{-26, -26}, {26, 26}}, rotation = 90)));
  // LC dynamic filter block
  LCDynFilter lCDynFilter(uLeft_rePu0 = uconv0Pu_init.re, uLeft_imPu0 = uconv0Pu_init.im, iRight_rePu0 = IrPcc0Pu*SNom/SystemBase.SnRef, iRight_imPu0 = IiPcc0Pu* SNom / SystemBase.SnRef, omegaPu0 = Omega0Pu, iLeft_rePu0 = IrConv0Pu, iLeft_imPu0 = IiConv0Pu, uRight_rePu0 = ucaP0Pu_init.re, uRight_imPu0 = ucaP0Pu_init.im, RfPu = RfPu, LfPu = LfPu, CfPu = CfPu, omegaNom = omegaNom, SNom = SNom) annotation(
    Placement(transformation(origin = {3, 55}, extent = {{-11, -11}, {11, 11}})));
  // Combined LV+HV transformer RL stage.
  // Models the two winding leakage impedances (LV and HV) as a single lumped
  // dynamic RL element (R = RPuLV+RPuHV, L = LPuLV+LPuHV). The two stages are
  // strictly in series with nothing tapped at their junction, so their branch
  // currents are identical at every instant (Kirchhoff's current law) and a
  // second dynamic state there would be a redundant alias, not an independent
  // degree of freedom. The internal LV-bus voltage (junction between the two
  // stages, used by the MeasurementBlock) is instead recovered algebraically
  // below from this single current and the HV-leg impedance alone.
  RLDynTrafo Trafo(RPu = (RPuLV + RPuHV)*SystemBase.SnRef/SNom, LPu = (LPuLV + LPuHV)*SystemBase.SnRef/SNom, Omega0Pu = Omega0Pu, Ir0Pu = IrPcc0Pu*SNom/SystemBase.SnRef, Ii0Pu = IiPcc0Pu*SNom/SystemBase.SnRef) annotation(
    Placement(transformation(origin = {57, 54}, extent = {{-10, -10}, {10, 10}})));

equation

// ──────────────────────────────────────────────────────────────────────────
// SECTION 13 – Signal connections
//
// The connections are grouped by functional path to aid readability.
// ──────────────────────────────────────────────────────────────────────────
// ── 13.1  External references → plant controller ─────────────────────────
// Active power set-point from the dispatcher to the plant controller
// Voltage / reactive power set-point to the plant controller
  connect(omegaRefPu, gFLControl.omegaRefPU) annotation(
    Line(points = {{-83, 109}, {-83, 66}}, color = {220, 138, 221}, thickness = 0.75));
// Network frequency reference fed directly to the GFL converter controller
// ── 13.2  Plant controller ↔ GFL converter controller ────────────────────
// Active power reference from plant controller to GFL outer loop
// PLL frequency fed back from plant controller to GFL controller (dashed = feedback)
// Reactive power reference from GFL controller back to plant controller
// ── 13.3  GFL controller → VSC Padé delay ────────────────────────────────
  connect(gFLControl.vm_re, vSC_with_pade_delay.uReConvRefPu) annotation(
    Line(points = {{-76, 55.5}, {-61.5, 55.5}, {-61.5, 62}, {-51, 62}}, color = {38, 162, 105}, thickness = 0.75));
// Real part of the modulation voltage reference → VSC delay input
  connect(gFLControl.vm_im, vSC_with_pade_delay.uImConvRefPu) annotation(
    Line(points = {{-76, 48}, {-55.5, 48}, {-55.5, 56}, {-51, 56}}, color = {38, 162, 105}, thickness = 0.75));
// Imaginary part of the modulation voltage reference → VSC delay input
// ── 13.4  Measurement block → GFL converter controller ───────────────────
  connect(measurementBlock.theta_pll, gFLControl.theta_pll) annotation(
    Line(points = {{-72, -77}, {-72, 35}, {-76, 35}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
// PLL angle θ → used to transform signals between αβ and dq frames
  connect(measurementBlock.U_filter_q, gFLControl.V_q_grid) annotation(
    Line(points = {{-118, -85}, {-118, -23.25}, {-114, -23.25}, {-114, 38.5}}, color = {220, 138, 221}, thickness = 0.75));
// q-axis PCC voltage → PLL error signal input
  connect(measurementBlock.P_LV, gFLControl.P_meas) annotation(
    Line(points = {{-111, -77}, {-111, -24.5}, {-109, -24.5}, {-109, 28}}, color = {255, 120, 0}, thickness = 0.75));
// Filtered active power at LV node → outer loop feedback
  connect(measurementBlock.Q_LV, gFLControl.Q_meas) annotation(
    Line(points = {{-104, -77}, {-104, 28}, {-103, 28}}, color = {255, 120, 0}, thickness = 0.75));
// Filtered reactive power at LV node → outer loop feedback
  connect(measurementBlock.I_conv_q, gFLControl.i_q_meas) annotation(
    Line(points = {{-98, -77}, {-98, 29}, {-96, 29}, {-96, 28}}, color = {38, 162, 105}, thickness = 0.75));
// q-axis converter current → inner current loop feedback
  connect(measurementBlock.I_conv_d, gFLControl.i_d_meas) annotation(
    Line(points = {{-92, -77}, {-92, -78}, {-91, -78}, {-91, 27}, {-92, 27}, {-92, 28}}, color = {38, 162, 105}, thickness = 0.75));
// d-axis converter current → inner current loop feedback
  connect(measurementBlock.V_LV_d, gFLControl.V_d_meas) annotation(
    Line(points = {{-85, -77}, {-85, 29.875}, {-88, 29.875}, {-88, 28}, {-87, 28}}, color = {255, 120, 0}, thickness = 0.75));
// d-axis LV node voltage → feed-forward / outer loop
  connect(measurementBlock.V_LV_q, gFLControl.V_q_meas) annotation(
    Line(points = {{-79, -77}, {-79, 28}, {-83, 28}}, color = {255, 120, 0}, thickness = 0.75));
// q-axis LV node voltage → feed-forward / outer loop
// ── 13.5  Measurement block → plant controller ────────────────────────────
// Filtered PCC voltage magnitude → Q–U droop and PI in plant controller
// Filtered plant-level reactive power → Q–U PI in plant controller
// Filtered plant-level active power → P–f PI in plant controller
// ── 13.6  VSC delay → LC filter ───────────────────────────────────────────
  connect(vSC_with_pade_delay.uReConvPu, lCDynFilter.uLeft_rePu) annotation(
    Line(points = {{-29, 62}, {-10, 62}}, color = {38, 162, 105}, thickness = 0.75));
// Delayed real part of converter voltage → LC filter left port
  connect(vSC_with_pade_delay.uImConvPu, lCDynFilter.uLeft_imPu) annotation(
    Line(points = {{-29, 56}, {-10, 56}}, color = {38, 162, 105}, thickness = 0.75));
// Delayed imaginary part of converter voltage → LC filter left port
// ── 13.7  PLL frequency shared across all dynamic electrical elements ──────
  connect(lCDynFilter.omegaPu, gFLControl.omega_pll_pu) annotation(
    Line(points = {{-4, 42}, {-76, 42}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
// LC filter feeds back PLL frequency to the GFL controller
  connect(Trafo.omegaPu, gFLControl.omega_pll_pu) annotation(
    Line(points = {{58, 42}, {-76, 42}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
// Trafo receives PLL frequency for dq-frame inductance voltage terms
// ── 13.8  Electrical power path: converter → filter → transformer → PCC ──
  connect(lCDynFilter.terminalRight, Trafo.left) annotation(
    Line(points = {{14, 55}, {47, 55}}, color = {0, 0, 255}));
// LC filter right port → transformer input
// Transformer output → PCC terminal (connection to external network)
// ── 13.9  Converter current feedback to the LC filter ─────────────────────
  connect(measurementBlock.I_conv_re, lCDynFilter.iLeft_rePu) annotation(
    Line(points = {{-66, -83}, {-66, -82.625}, {-27, -82.625}, {-27, 51.75}, {-10, 51.75}, {-10, 51}}, color = {38, 162, 105}, thickness = 0.75));
// Real part of converter current (from measurement block) → LC filter state
  connect(measurementBlock.I_conv_im, lCDynFilter.iLeft_imPu) annotation(
    Line(points = {{-66, -88}, {-12, -88}, {-12, 46}, {-10, 46}}, color = {38, 162, 105}, thickness = 0.75));
// Imaginary part of converter current → LC filter state
// ── 13.10  Algebraic assignments: terminal quantities → measurement block ──
// Internal LV bus voltage (junction between the LV and HV transformer stages).
// Recovered algebraically from the single branch current and the HV-leg
// impedance alone (no dynamic state at the junction, see Trafo declaration).
  measurementBlock.u_LV_re = terminalPcc.V.re + Trafo.iRe*SystemBase.SnRef/SNom*RPuHV - Trafo.iIm*SystemBase.SnRef/SNom*Trafo.omegaPu*LPuHV;
// real part of LV node voltage
  measurementBlock.u_LV_im = terminalPcc.V.im + Trafo.iRe*SystemBase.SnRef/SNom*Trafo.omegaPu*LPuHV + Trafo.iIm*SystemBase.SnRef/SNom*RPuHV;

// imaginary part of LV node voltage
// PCC voltage (from the external network connector)
  measurementBlock.V_pcc_re = terminalPcc.V.re;
// real part of PCC voltage
  measurementBlock.V_pcc_im = terminalPcc.V.im;
  measurementBlock.v_filt_re=lCDynFilter.terminalRight.V.re;
   measurementBlock.v_filt_im=lCDynFilter.terminalRight.V.im;

// imaginary part of PCC voltage
// PCC current with sign reversal: terminalPcc uses load convention (i > 0 into network),
// while the measurement block uses generator convention (i > 0 out of converter).
  measurementBlock.I_pcc_re = -terminalPcc.i.re * SystemBase.SnRef / SNom;
  measurementBlock.I_pcc_im = -terminalPcc.i.im * SystemBase.SnRef / SNom;
  connect(Trafo.right, terminalPcc) annotation(
    Line(points = {{68, 54}, {104, 54}}, color = {0, 0, 255}));
  connect(PRefPu, gFLControl.P_ref) annotation(
    Line(points = {{-208, 62}, {-114, 62}, {-114, 58}}, color = {0, 0, 127}));
  connect(QRefPu, gFLControl.Q_ref) annotation(
    Line(points = {{-208, 46}, {-114, 46}, {-114, 48}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-18, 16},extent = {{-80, 20}, {80, -20}}, textString = "GFL")}),
    Diagram(coordinateSystem(extent = {{-200, -200}, {100, 100}}), graphics = {Ellipse(extent = {{-100, 52}, {-100, 52}})}));


end GFLmodel_noplant;
