within Dynawo.Electrical.PEIR.Plants.Average;

model GFLmodel
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
  parameter Real tVSC "VSC  delay time constant (s)";
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
  parameter Real KFilter "Measurement filter gain";
  parameter Real tFilter "Measurement filter time constant (s)";
  // ────────────────────────────────────────────────────────────
  // Inner  current controllers (converter control)
  // ────────────────────────────────────────────────────────────
  parameter Real KpdCurrent "Inner current loop PI: proportional gain on d-axis";
  parameter Real KidCurrent "Inner current loop PI: integral gain on d-axis";
  parameter Real KpqCurrent "Inner current loop PI: proportional gain on q-axis";
  parameter Real KiqCurrent "Inner current loop PI: integral gain on q-axis";
  // ────────────────────────────────────────────────────────────
  // Outer P/Q loop control loops (converter control)
  // ────────────────────────────────────────────────────────────
  parameter Real KpdOuter "Outer loop PI: proportional gain on d-axis (active power)";
  parameter Real KidOuter "Outer loop PI: integral gain on d-axis (active power)";
  parameter Real KpqOuter "Outer loop PI: proportional gain on q-axis (reactive/voltage)";
  parameter Real KiqOuter "Outer loop PI: integral gain on q-axis (reactive/voltage)";
  parameter Real IMaxPu "Maximum converter current magnitude (pu)";
  parameter Boolean PQFlag "Priority flag: false = Q-priority, true = P-priority";
  // Reactive power boost around voltage thresholds
  parameter Real UBoostHighPu "High-voltage threshold for reactive power boost (pu)";
  parameter Real UBoostLowPu "Low-voltage threshold for reactive power boost (pu)";
  parameter Real Kqv "Reactive boost gain dIq/dU (pu/pu), 0 to disable";
  parameter Real IqBoostMaxPu "Maximum additional Iq boost (pu)";
  parameter Real IqBoostMinPu "Minimum additional Iq boost (pu)";
  parameter Boolean PControlFlag "true: bypass P PI, use idRefPu = PRefPu/UMeasPu | false: use PI regulator (default)";
  parameter Boolean QControlFlag "true: bypass Q PI, use i_q_ref = QRefPu/UMeasPu | false: use PI regulator (default)";
  // ────────────────────────────────────────────────────────────
  // Plant controller (P–f and Q–U droop and PI loops)
  // ────────────────────────────────────────────────────────────
  parameter Types.VoltageModulePu DbdPu "Voltage error deadband half-width in U + λ·Q loop in pu (base UNom)";
  parameter Types.AngularVelocityPu FDbd1Pu "Frequency deadband lower threshold in pu (base omegaNom)(positive value)";
  parameter Types.AngularVelocityPu FDbd2Pu "Frequency deadband upper threshold in pu (base omegaNom) (positive value)";
  parameter Types.AngularVelocityPu FEMaxPu "Maximum frequency error after droop limiter in pu (base omegaNom)";
  parameter Types.AngularVelocityPu FEMinPu "Minimum frequency error after droop limiter in pu (base omegaNom)";
  parameter Types.PerUnit KDroop "Frequency droop gain on active power (pu/pu)";
  parameter Types.PerUnit LambdaPu "Voltage droop gain in u + lambdaQ control";
  parameter Types.PerUnit Kiq "PI integral gain - voltage/Q loop";
  parameter Types.PerUnit Kpp "PI proportional gain - active power loop";
  parameter Types.PerUnit Kip "PI integral gain - active power loop";
  parameter Types.PerUnit Kpq "PI proportional gain - voltage/Q loop";
  parameter Types.ActivePowerPu PMaxPu "Maximum active power reference in pu (base SNom)";
  parameter Types.ActivePowerPu PMinPu "Minimum active power reference in pu (base SNom)";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power reference in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power reference in pu (base SNom)";
  // ────────────────────────────────────────────────────────────
  // PLL parameters
  // ────────────────────────────────────────────────────────────
  parameter Real KpPLL "PLL PI: proportional gain";
  parameter Real KiPLL "PLL PI: integral gain";
  parameter Real OmegaMaxPu "Maximum PLL frequency (pu)";
  parameter Real OmegaMinPu "Minimum PLL frequency (pu)";
  final parameter Real Theta0 = Modelica.Math.atan2(ucaP0Pu_init.im, ucaP0Pu_init.re) "Initial PLL angle (rad)";
  // ────────────────────────────────────────────────────────────
  // Outer-loop PI slew-rate limits & idRefPu ramp limiter
  // ────────────────────────────────────────────────────────────
  parameter Real DidMax "Maximum rate of change of idRefPu (pu/s)";
  parameter Real DidMin "Minimum rate of change of idRefPu (pu/s)";
  parameter Real tSid "Sample/update time of idRefPu ramp limiter (s)";
  parameter Real tPlant "Time delay between plant controller output and outer loop (s)";
  parameter Real Kfd "1: apply v_d feed-forward for faster disturbance rejection | 0: PI only";
  parameter Real Kfq "1: apply v_q feed-forward for faster disturbance rejection | 0: PI only";
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
  final parameter Real Lg = LfPu + LPuLV "grid inductance (pu)";
  final parameter Real Rg = RfPu + RPuLV "grid resistance (pu)";
  // Impedance of the full series path: LV + HV transformer stages combine
  final parameter Complex Z_f = Complex(RPuHV + RPuLV, Omega0Pu*(LPuHV + LPuLV));
  // Total grid impedance seen from the converter AC terminals
  final parameter Complex Z_g = Complex(Rg + RPuHV, Omega0Pu*(Lg + LPuHV));
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
   parameter Real tBoost
    "Time constant of first-order filter on iqBoostPu (s) to delay the current boost response. Set 0 to disable";

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 12 – Component declarations
  // ─────────────────────────────────────────────────────────────────────────
  // PCC terminal – AC connector to the external network.
  // Voltage and current are initialised at the computed steady-state values.
  Dynawo.Connectors.ACPower terminal(V(re(start = UrPcc0Pu), im(start = UiPcc0Pu)), i(re(start = -IrPcc0Pu * SNom / SystemBase.SnRef), im(start = -IiPcc0Pu * SNom / SystemBase.SnRef))) annotation(
    Placement(transformation(origin = {140, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {80, 16}, extent = {{-20, -20}, {20, 20}})));
  // GFL converter controller block.
  // Implements: PLL, inner current PI loops, outer P/Q PI loops, current
  // limitation with P/Q priority, and reactive-power boost logic.
  Dynawo.Electrical.PEIR.Plants.Average.BaseClasses.GFLControl gFLControl(
    Omega0Pu = Omega0Pu,
    QInj0Pu = QInj0Pu,
    PInj0Pu = PInj0Pu,
    idRef0Pu = Id_conv_0,
    IdConv0Pu = Id_conv_0,
    iqRef0Pu = Iq_conv_0,
    IqConv0Pu = Iq_conv_0,
    DidMax = DidMax,
    DidMin = DidMin,
    tSid = tSid,
    tPlant = tPlant,
    KpdCurrent = KpdCurrent,
    KidCurrent = KidCurrent,
    KpqCurrent = KpqCurrent,
    KiqCurrent = KiqCurrent,
    Lg = Lg,
    Rg = Rg,
    vd_0 = Ud0Pu,
    vq_0 = Uq0Pu,
    vmd_0 = Ud0Pu,
    vmq_0 = Uq0Pu,
    KpdOuter = KpdOuter,
    KidOuter = KidOuter,
    KpqOuter = KpqOuter,
    KiqOuter = KiqOuter,
    IMaxPu = IMaxPu,
    PQFlag = PQFlag,
    UBoostHighPu = UBoostHighPu,
    UBoostLowPu = UBoostLowPu,
    Kqv = Kqv,
    IqBoostMaxPu = IqBoostMaxPu,
    IqBoostMinPu = IqBoostMinPu,
    KpPLL = KpPLL,
    KiPLL = KiPLL,
    OmegaMaxPu = OmegaMaxPu,
    OmegaMinPu = OmegaMinPu,
    Theta0 = Theta0,
    vm0 = uconv0Pu_init,
    U_LV0 = sqrt(uLV0Pu_init.re^2 + uLV0Pu_init.im^2),
    Uq0Pu = V_q_g_0,
    Kfd = Kfd,
    Kfq = Kfq,
    tBoost = tBoost,
    PControlFlag = PControlFlag,
    QControlFlag = QControlFlag) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}})));

  // Plant-level controller block.
  // Implements: P–f droop, Q–U droop, frequency and voltage deadbands,
  // PI loops for active and reactive power, and output limiter
  BaseClasses.PlantController plantController(Kpq = Kpq, Kiq = Kiq, Kpp = Kpp, Kip = Kip, LambdaPu = LambdaPu, KDroop = KDroop, QMaxPu = QMaxPu, QMinPu = QMinPu, PMaxPu = PMaxPu, PMinPu = PMinPu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, DbdPu = DbdPu, U0Pu = U0Pu, Q0Pu = Q0Pu, P0Pu = P0Pu, Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu) annotation(
    Placement(transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}})));
  // External active power set-point input
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) annotation(
    Placement(transformation(origin = {-220, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-118, 72}, extent = {{-20, -20}, {20, 20}})));
  // External voltage (reactive power) set-point input
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) annotation(
    Placement(transformation(origin = {-220, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
    final parameter Real URef0Pu = U0Pu + LambdaPu*Q0Pu;
  // Grid angular frequency reference (provided by the network / external bus model)
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) annotation(
    Placement(transformation(origin = {-83, 59}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));
  // VSC switching delay block (first-order Padé approximation).
  // Introduces a realistic delay between the voltage reference computed by the
  // controller and the actual converter output voltage
  BaseClasses.VSC_with_first_order_delay vSC_delay(tVSC = tVSC, UreConv0Pu = uconv0Pu_init.re, UimConv0Pu = uconv0Pu_init.im) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}})));
  // Measurement and filtering block.
  // Computes filtered signals for P, Q, U, I fom the PLL angle θ, the
  // instantaneous terminal voltages and currents at the PCC and LV node
  Controls.Utilities.Average.MeasurementBlock measurementBlock(UrPcc0Pu = UrPcc0Pu, UiPcc0Pu = UiPcc0Pu, IrPcc0Pu = IrPcc0Pu, IiPcc0Pu = IiPcc0Pu, Theta0 = Theta0, U0_pcc = U0Pu, KFilter = KFilter, tFilter = tFilter, P0_pcc = P0Pu, Q0_pcc = Q0Pu, U_pcc_q_0 = V_q_g_0, idConvPu_0 = Id_conv_0, iqConvPu_0 = Iq_conv_0, I_conv_re_0 = IrConv0Pu, I_conv_im_0 = IiConv0Pu, u_LV_re_0 = uLV0Pu_init.re, u_LV_im_0 = uLV0Pu_init.im, P0_LV = PInj0Pu, Q0_LV = QInj0Pu, udLVPu_0 = Ud_LV0Pu, uqLVPu_0 = Uq_LV0Pu) annotation(
    Placement(transformation(origin = {-100, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  // LC dynamic filter block
  BaseClasses.LCDynFilter lCDynFilter(uLeft_rePu0 = uconv0Pu_init.re, uLeft_imPu0 = uconv0Pu_init.im, iRight_rePu0 = IrPcc0Pu*SNom/SystemBase.SnRef, iRight_imPu0 = IiPcc0Pu* SNom / SystemBase.SnRef, omegaPu0 = Omega0Pu, iLeft_rePu0 = IrConv0Pu, iLeft_imPu0 = IiConv0Pu, uRight_rePu0 = ucaP0Pu_init.re, uRight_imPu0 = ucaP0Pu_init.im, RfPu = RfPu, LfPu = LfPu, CfPu = CfPu, omegaNom = omegaNom, SNom = SNom) annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}})));
  // Combined LV+HV transformer RL stage.
  // Models the two winding leakage impedances (LV and HV) as a single lumped
  // dynamic RL element (R = RPuLV+RPuHV, L = LPuLV+LPuHV). The two stages are
  // strictly in series with nothing tapped at their junction, so their branch
  // currents are identical at every instant (Kirchhoff's current law) and a
  // second dynamic state there would be a redundant alias, not an independent
  // degree of freedom. The internal LV-bus voltage (junction between the two
  // stages, used by the MeasurementBlock) is instead recovered algebraically
  // below from this single current and the HV-leg impedance alone.
  BaseClasses.RLDynTrafo Trafo(RPu = (RPuLV + RPuHV)*SystemBase.SnRef/SNom, LPu = (LPuLV + LPuHV)*SystemBase.SnRef/SNom, Omega0Pu = Omega0Pu, Ir0Pu = IrPcc0Pu*SNom/SystemBase.SnRef, Ii0Pu = IiPcc0Pu*SNom/SystemBase.SnRef) annotation(
    Placement(transformation(origin = {79, 0}, extent = {{-20, -20}, {20, 20}})));
equation

// ──────────────────────────────────────────────────────────────────────────
// SECTION 13 – Signal connections
//
// The connections are grouped by functional path to aid readability.
// ──────────────────────────────────────────────────────────────────────────
// ── 13.1  External references → plant controller ─────────────────────────
  connect(PRefPu, plantController.PRefPu) annotation(
    Line(points = {{-220, 20}, {-201, 20}, {-201, 10}, {-182, 10}}, color = {220, 138, 221}, thickness = 0.75));
// Active power set-point from the dispatcher to the plant controller
  connect(URefPu, plantController.URefPu) annotation(
    Line(points = {{-220, -20}, {-216, -20}, {-216, -10}, {-182, -10}}, color = {220, 138, 221}, thickness = 0.75));
// Voltage / reactive power set-point to the plant controller
  connect(omegaRefPu, gFLControl.omegaRefPu) annotation(
    Line(points = {{-83, 59}, {-83, 37.5}, {-86, 37.5}, {-86, 22}}, color = {220, 138, 221}, thickness = 0.75));
// Network frequency reference fed directly to the GFL converter controller
// ── 13.2  Plant controller ↔ GFL converter controller ────────────────────
// Active power reference from plant controller to GFL outer loop
  connect(plantController.omegaPLLPu, gFLControl.omegaPLLPu) annotation(
    Line(points = {{-138, -2}, {-138, 2.97}, {-78, 2.97}, {-78, -6}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
// PLL frequency fed back from plant controller to GFL controller (dashed = feedback)
// Reactive power reference from GFL controller back to plant controller
// ── 13.3  GFL controller → VSC Padé delay ────────────────────────────────
  connect(gFLControl.vm_re, vSC_delay.uReConvRefPu) annotation(
    Line(points = {{-78, 10}, {-70, 10}, {-70, 8}, {-63, 8}}, color = {38, 162, 105}, thickness = 0.75));
// Real part of the modulation voltage reference → VSC delay input
  connect(gFLControl.vm_im, vSC_delay.uImConvRefPu) annotation(
    Line(points = {{-78, 2}, {-63.5, 2}, {-63.5, -4}, {-63, -4}}, color = {38, 162, 105}, thickness = 0.75));
// Imaginary part of the modulation voltage reference → VSC delay input
// ── 13.4  Measurement block → GFL converter controller ───────────────────
  connect(measurementBlock.thetaPLL, gFLControl.thetaPLL) annotation(
    Line(points = {{-86, -118}, {-86, -65.5}, {-78, -65.5}, {-78, -14}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
// PLL angle θ → used to transform signals between αβ and dq frames
  connect(measurementBlock.uqFilterPu, gFLControl.uqFilterPu) annotation(
    Line(points = {{-122, -124}, {-122, -10}}, color = {220, 138, 221}, thickness = 0.75));
// q-axis PCC voltage → PLL error signal input
  connect(measurementBlock.PLVPu, gFLControl.PLVPu) annotation(
    Line(points = {{-116, -118}, {-116, -70}, {-117, -70}, {-117, -22}}, color = {255, 120, 0}, thickness = 0.75));
// Filtered active power at LV node → outer loop feedback
  connect(measurementBlock.QLVPu, gFLControl.QLVPu) annotation(
    Line(points = {{-111, -118}, {-111, -70}, {-110, -70}, {-110, -22}}, color = {255, 120, 0}, thickness = 0.75));
// Filtered reactive power at LV node → outer loop feedback
  connect(measurementBlock.iqConvPu, gFLControl.iqConvPu) annotation(
    Line(points = {{-106, -118}, {-106, -72}, {-102, -72}, {-102, -22}}, color = {38, 162, 105}, thickness = 0.75));
// q-axis converter current → inner current loop feedback
  connect(measurementBlock.idConvPu, gFLControl.idConvPu) annotation(
    Line(points = {{-101, -118}, {-101, -128.4}, {-90.8909, -128.4}, {-90.8909, -23.4}, {-96, -23.4}, {-96, -22}}, color = {38, 162, 105}, thickness = 0.75));
// d-axis converter current → inner current loop feedback
  connect(measurementBlock.udLVPu, gFLControl.udLVPu) annotation(
    Line(points = {{-96, -118}, {-96, -20.525}, {-88.2727, -20.525}, {-88.2727, -22}, {-91, -22}}, color = {255, 120, 0}, thickness = 0.75));
// d-axis LV node voltage → feed-forward / outer loop
  connect(measurementBlock.uqLVPu, gFLControl.uqLVPu) annotation(
    Line(points = {{-91, -118}, {-91, -70}, {-86, -70}, {-86, -22}}, color = {255, 120, 0}, thickness = 0.75));
// q-axis LV node voltage → feed-forward / outer loop
// ── 13.5  Measurement block → plant controller ────────────────────────────
  connect(measurementBlock.UPccPu, plantController.UFiltPu) annotation(
    Line(points = {{-122, -131}, {-122, -144.06}, {-142.364, -144.06}, {-142.364, -22}, {-149, -22}}, color = {220, 138, 221}, thickness = 0.75));
// Filtered PCC voltage magnitude → Q–U droop and PI in plant controller
  connect(measurementBlock.QFilteredPccPu, plantController.QFiltPu) annotation(
    Line(points = {{-122, -137}, {-122, -149.84}, {-158, -149.84}, {-158, -22}}, color = {220, 138, 221}, thickness = 0.75));
// Filtered plant-level reactive power → Q–U PI in plant controller
  connect(measurementBlock.PFilteredPccPu, plantController.PFiltPu) annotation(
    Line(points = {{-122, -142}, {-122, -157.6}, {-168, -157.6}, {-168, -22}}, color = {220, 138, 221}, thickness = 0.75));
// Filtered plant-level active power → P–f PI in plant controller
// ── 13.6  VSC delay → LC filter ───────────────────────────────────────────
  connect(vSC_delay.uReConvPu, lCDynFilter.uLeft_rePu) annotation(
    Line(points = {{-17, 8}, {-9.5, 8}, {-9.5, 12}, {-4, 12}}, color = {38, 162, 105}, thickness = 0.75));
// Delayed real part of converter voltage → LC filter left port
  connect(vSC_delay.uImConvPu, lCDynFilter.uLeft_imPu) annotation(
    Line(points = {{-17, -4}, {-16, -4}, {-16, 2}, {-4, 2}}, color = {38, 162, 105}, thickness = 0.75));
// Delayed imaginary part of converter voltage → LC filter left port
// ── 13.7  PLL frequency shared across all dynamic electrical elements ──────
  connect(lCDynFilter.omegaPu, gFLControl.omegaPLLPu) annotation(
    Line(points = {{8, -24}, {-36.5, -24}, {-36.5, -6}, {-78, -6}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
// LC filter feeds back PLL frequency to the GFL controller
  connect(Trafo.omegaPu, gFLControl.omegaPLLPu) annotation(
    Line(points = {{79, -22}, {-9, -22}, {-9, -6}, {-78, -6}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
// Trafo receives PLL frequency for dq-frame inductance voltage terms
// ── 13.8  Electrical power path: converter → filter → transformer → PCC ──
  connect(lCDynFilter.terminalRight, Trafo.left) annotation(
    Line(points = {{40, 0}, {59, 0}}, color = {0, 0, 255}));
// LC filter right port → transformer input
// Transformer output → PCC terminal (connection to external network)
// ── 13.9  Converter current feedback to the LC filter ─────────────────────
  connect(measurementBlock.iConvPu, lCDynFilter.iLeftPu) annotation(
    Line(points = {{-82, -122}, {-82, -132.225}, {-5.3636, -132.225}, {-5.3636, -9.85}, {-4, -9.85}, {-4, -7}}, color = {38, 162, 105}, thickness = 0.75));
// Real part of converter current (from measurement block) → LC filter state

 // Imaginary part of converter current → LC filter state
// ── 13.10  Algebraic assignments: terminal quantities → measurement block ──
// Internal LV bus voltage (junction between the LV and HV transformer stages).
// Recovered algebraically from the single branch current and the HV-leg
// impedance alone (no dynamic state at the junction, see Trafo declaration).
  measurementBlock.uLVPu.re = terminal.V.re + Trafo.iRe*SystemBase.SnRef/SNom*RPuHV - Trafo.iIm*SystemBase.SnRef/SNom*Trafo.omegaPu*LPuHV;
// real part of LV node voltage
  measurementBlock.uLVPu.im = terminal.V.im + Trafo.iRe*SystemBase.SnRef/SNom*Trafo.omegaPu*LPuHV + Trafo.iIm*SystemBase.SnRef/SNom*RPuHV;

// imaginary part of LV node voltage
// PCC voltage (from the external network connector)

// PCC current with sign reversal: terminal uses load convention (i > 0 into network),
// while the measurement block uses generator convention (i > 0 out of converter).
  measurementBlock.iPccPu = -terminal.i * SystemBase.SnRef / SNom;
  measurementBlock.uPccPu = terminal.V;

  measurementBlock.uFiltPu=lCDynFilter.terminalRight.V;


  connect(Trafo.right, terminal) annotation(
    Line(points = {{99, 0}, {140, 0}}, color = {0, 0, 255}));
  connect(plantController.QInjRefPu, gFLControl.QRefPu) annotation(
    Line(points = {{-137, -10}, {-130.5, -10}, {-130.5, 2}, {-122, 2}}, color = {0, 0, 127}));
  connect(plantController.PInjRefPu, gFLControl.PRefPu) annotation(
    Line(points = {{-137, 8}, {-131.5, 8}, {-131.5, 14}, {-122, 14}}, color = {0, 0, 127}));
  connect(measurementBlock.ULVPu, gFLControl.ULVPu) annotation(
    Line(points = {{-122, -150}, {-132, -150}, {-132, -16}, {-122, -16}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-18, 16},extent = {{-80, 20}, {80, -20}}, textString = "GFL")}),
    Diagram(coordinateSystem(extent = {{-200, -200}, {100, 100}}), graphics = {Ellipse(extent = {{-100, 52}, {-100, 52}})}));
end GFLmodel;
