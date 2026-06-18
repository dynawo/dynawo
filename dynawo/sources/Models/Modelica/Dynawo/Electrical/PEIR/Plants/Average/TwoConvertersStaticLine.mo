within Dynawo.Electrical.PEIR.Plants.Average;

model TwoConvertersStaticLine
  /*
   * Author: Gaia Bergamaschi
   *
   * Two‑converter test — grid‑following (GFL) converters with static line
   *
   * Purpose:
   *   Recreate the two‑converter EMT simulation performed at RTE last year,
   *   with two grid‑following VSCs connected through a static transmission
   *   corridor and an infinite bus at the remote end.
   *
   * Description:
   *   - Two GFL converters (gFLmodel, gFLmodel1) connected to a common AC bus.
   *   - Each converter has its own L‑filter and LV/HV transformer impedances.
   *   - The common bus is linked to an infinite bus via a two‑segment line
   *     (line2 and line3), with line3 opened at t = 51.5 s to emulate a
   *     topology change / line outage.
   *   - Controllers include:
   *       * Inner d‑q current loop
   *       * Outer P/Q control loop
   *       * SRF‑PLL
   *       * Slow plant (power) controller with droop
   *   - All powers and voltages are in per‑unit on each converter base.
   *
   * Operating point (initial conditions):
   *   - Converter 1 (gFLmodel):
   *       SNom   = 1000 MVA
   *       U0Pu   = 1.091230 pu
   *       P0_pcc = -5.010676 pu
   *       Q0_pcc = -0.21 pu
   *       Uphase = 0.063246 rad
   *
   *   - Converter 2 (gFLmodel1):
   *       SNom   = 1000 MVA
   *       U0Pu   = 1.086638 pu
   *       P0_pcc =  4.989324 pu
   *       Q0_pcc = -0.21 pu
   *       Uphase = -0.063421 rad
   *
   *   - Infinite bus (infiniteBusWithVariations):
   *       U0Pu     = 1.10 pu
   *       UPhase   = -0.001082 rad
   *       omega0Pu = 1.0 pu
   *       Voltage event: dip to 0.5 pu at t = 15.1 s (instantaneous)
   *
   * ── Controller tuning overview ─────────────────────────────────
   *
   *   Shared target bandwidths (for both converters):
   *     - Inner current loop:      Ω_cc       = 1200 rad/s
   *     - Outer P/Q control loop:  ω_cc_outer = 10   rad/s
   *     - Plant controller:        ω_cc_plant = 2    rad/s
   *     - PLL:                     Ω_PLL      = 100  rad/s
   *     - Measurement LPF:         Ω_LPF      = 300  rad/s
   *
   *   Inner current loop (d/q identical):
   *     - Effective impedances include filter + LV transformer:
   *         Rf_i = R_filter_i + R_LV_i
   *         Lf_i = L_filter_i + L_LV_i
   *     - PI gains for each converter i = 1,2:
   *         k_p_cc_i = Lf_i · Ω_cc / ω_nom
   *         k_i_cc_i = Rf_i · Ω_cc
   *
   *   Outer P/Q loop:
   *     - Simple bandwidth assignment:
   *         k_p_outer_i = ω_cc_outer / Ω_LPF
   *         k_i_outer_i = ω_cc_outer
   *     - Same structure on d‑ and q‑axis:
   *         k_p_d_outer = k_p_q_outer = k_p_outer_i
   *         k_i_d_outer = k_i_q_outer = k_i_outer_i
   *
   *   PLL (synchronous reference frame PLL):
   *     - Target bandwidth:
   *         Ω_PLL = 100 rad/s
   *     - Damping ratio:
   *         ζ_PLL = 1.0
   *     - SRF‑PLL formulas (per unit on ω_nom):
   *         k_p_pll_i = 2 ζ_PLL Ω_PLL / ω_nom
   *         k_i_pll_i = Ω_PLL² / ω_nom
   *     - Frequency limits:
   *         OmegaMinPu = 0.9 pu
   *         OmegaMaxPu = 1.1 pu
   *
   *   Plant (slow power) controller:
   *     - Target bandwidth:
   *         ω_cc_plant = 2 rad/s
   *     - PI gains (same for P and Q channels):
   *         K_p_plant_i = ω_cc_plant / ω_cc_outer
   *         K_i_plant_i = ω_cc_plant
   *     - Voltage‑reactive power coupling and droop:
   *         Lambda = 0.417
   *         Kdroop = 15
   *
   * ── Filter and delay design ────────────────────────────────────
   *
   *   Voltage / measurement low‑pass filter:
   *     - Cutoff:
   *         Ω_LPF   = 300 rad/s
   *         T_filter = 1 / Ω_LPF
   *
   *   Control delay:
   *     - Equivalent plant→outer‑loop delay:
   *         delay_time_plant = 0.02 s
   *
   * ── Network topology ───────────────────────────────────────────
   *
   *   - gFLmodel  → line  → common bus → line2+line3 → infinite bus
   *   - gFLmodel1 → line1 → common bus
   *   - All line parameters are given in per‑unit (R, X, B, G).
   *   - line3 is opened at t = 51.5 s to emulate a line trip.
   *
   * ── Simulation setup ───────────────────────────────────────────
   *
   *   - Time span:        0 s → 70 s
   *   - Fixed output step: 0.0005 s
   *   - Tolerance:        1e‑5
   *   - Active power references:
   *       * gFLmodel:  step at t = 50 s, from 0.5 pu to 0.6 pu
   *       * gFLmodel1: step at t = 50 s, from −0.5 pu to −0.4 pu
   *   - Voltage reference:
   *       * gFLmodel: step at t = 480 s (outside main window here)
   *       * gFLmodel1: constant URef0Pu1
   *
   */

  // ═══════════════════════════════════════════════════════════════
  // Target bandwidths — edit only these high‑level settings
  // ═══════════════════════════════════════════════════════════════
  parameter Real OmegaCC          = 1200  "Inner current loop bandwidth [rad/s]";
  parameter Real w_cc_outer       = 10    "Outer P/Q loop bandwidth [rad/s]";
  parameter Real w_cc_plant       = 2     "Plant (power) controller bandwidth [rad/s]";
  parameter Real OmegaPLL         = 100   "PLL bandwidth [rad/s]";
  parameter Real KsiPLL           = 1.0   "PLL damping ratio [-]";
  parameter Real OmegaLPF         = 300   "Measurement low‑pass filter cutoff [rad/s]";
  parameter Real delay_time_plant = 0.02  "Equivalent delay from plant to outer loop [s]";
  final parameter Real T_filter   = 1.0 / OmegaLPF "Measurement filter time constant [s]";

  // ═══════════════════════════════════════════════════════════════
  // Effective impedances (filters + LV transformers)
  // Used for current controller design and equivalent L/R
  // ═══════════════════════════════════════════════════════════════
  final parameter Real Rf1 = gFLmodel.RfPu  + gFLmodel.RPuLV;
  final parameter Real Lf1 = gFLmodel.LfPu  + gFLmodel.LPuLV;
  final parameter Real Rf2 = gFLmodel1.RfPu + gFLmodel1.RPuLV;
  final parameter Real Lf2 = gFLmodel1.LfPu + gFLmodel1.LPuLV;

  // ═══════════════════════════════════════════════════════════════
  // Controller gains for Converter 1 (GFL1)
  // Computed from high‑level bandwidth targets above
  // ═══════════════════════════════════════════════════════════════
  final parameter Real kp_cc_1    = Lf1 * OmegaCC / SystemBase.omegaNom;
  final parameter Real ki_cc_1    = Rf1 * OmegaCC;
  final parameter Real kp_outer_1 = w_cc_outer / OmegaLPF;
  final parameter Real ki_outer_1 = w_cc_outer;
  final parameter Real kp_pll_1   = 2.0 * KsiPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real ki_pll_1   = OmegaPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real kp_plant_1 = w_cc_plant / w_cc_outer;
  final parameter Real ki_plant_1 = w_cc_plant;

  // ═══════════════════════════════════════════════════════════════
  // Controller gains for Converter 2 (GFL2)
  // Same structure as GFL1; impedances differ, so gains differ
  // ═══════════════════════════════════════════════════════════════
  final parameter Real kp_cc_2    = Lf2 * OmegaCC / SystemBase.omegaNom;
  final parameter Real ki_cc_2    = Rf2 * OmegaCC;
  final parameter Real kp_outer_2 = w_cc_outer / OmegaLPF;
  final parameter Real ki_outer_2 = w_cc_outer;
  final parameter Real kp_pll_2   = 2.0 * KsiPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real ki_pll_2   = OmegaPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real kp_plant_2 = w_cc_plant / w_cc_outer;
  final parameter Real ki_plant_2 = w_cc_plant;

  // ═══════════════════════════════════════════════════════════════
  // Converter 1: grid‑following VSC (GFL1)
  // Includes inner/outer loops, PLL, droop and plant controller
  // ═══════════════════════════════════════════════════════════════
  GFLmodel gFLmodel(
    SNom = 1000,
    U0Pu = 1.091230,
    Uphase = 0.063246,
    P0_pcc = -5.010676,
    Q0_pcc = -0.21,
    Omega0Pu = 1.0,
    tVSC = 1e-3,

    // Filter and transformer impedances (per unit)
    RfPu = 0.003,
    LfPu = 0.1,
    CfPu = 1e-5,
    omegaNom = 2 * Modelica.Constants.pi * 50,
    RPuLV = 0.001,
    LPuLV = 0.025,
    RPuHV = 0.001,
    LPuHV = 0.025,

    // Measurement filter
    k_filter = 1,
    T_filter = T_filter,

    // Inner d‑axis current controller
    k_p_d_current = kp_cc_1,
    k_i_d_current = ki_cc_1,

    // Inner q‑axis current controller (same as d‑axis)
    k_p_q_current = kp_cc_1,
    k_i_q_current = ki_cc_1,

    // Outer d‑axis controller (P / voltage loop)
    k_p_d_outer = kp_outer_1,
    k_i_d_outer = ki_outer_1,

    // Outer q‑axis controller (Q / voltage loop)
    k_p_q_outer = kp_outer_1,
    k_i_q_outer = ki_outer_1,

    // Voltage support and reactive power behaviour
    UboostHigh = 1.1,
    UboostLow = 0.9,
    Kqv = 0,

    // Current limits and operation mode
    Imax = 20,
    PQFlag = false,
    IqBoostMax = 0.5,
    IqBoostMin = -0.5,

    // Plant controller for Q
    K_p_q_plant = kp_plant_1,
    K_i_q_plant = ki_plant_1,

    // Plant controller for P
    K_p_p_plant = kp_plant_1,
    K_i_p_plant = ki_plant_1,

    // Droop and voltage‑Q coupling
    Lambda = 0.417,
    Kdroop = 15,

    // Reactive power limits
    QMaxPu = 0.3,
    QMinPu = -0.3,

    // Active power limits
    PMaxPu = 2,
    PMinPu = 0,

    // Frequency / angle limits
    FEMaxPu = 999,
    FEMinPu = -999,
    FDbd1Pu = 0.005,
    FDbd2Pu = 0.1,
    DbdPu = 0.0001,

    // PLL gains and limits
    K_p_pll = kp_pll_1,
    K_i_pll = ki_pll_1,
    OmegaMaxPu = 1.1,
    OmegaMinPu = 0.9,

    // Anti‑windup / rate limiting
    DyMax_pi_d = 10000.0,
    DyMax_pi_q = 100000.0,
    DuMax_idref = 10.0,
    DuMin_idref = -10.0,

    // Active power reference sampling time
    tS_idref = 1e-4,

    // Equivalent delay between plant and outer loop
    delay_time_plant = delay_time_plant,

    // Enable voltage feed‑forward on both d and q axis
    voltagefeedforwardflag_d = 0,
    voltagefeedforwardflag_q = 0
  ) annotation(
    Placement(transformation(origin = {-80, 16}, extent = {{-20, -20}, {20, 20}})));

  // ═══════════════════════════════════════════════════════════════
  // Converter 2: grid‑following VSC (GFL2)
  // Similar controller structure, different ratings and limits
  // ═══════════════════════════════════════════════════════════════
  GFLmodel gFLmodel1(
    SNom = 1000,
    U0Pu = 1.086638,
    Uphase = -0.063421,
    P0_pcc = 4.989324,
    Q0_pcc = -0.21,
    Omega0Pu = 1.0,
    tVSC = 1e-3,

    // Filter and transformer impedances (per unit)
    RfPu = 0.003,
    LfPu = 0.1,
    CfPu = 1e-5,
    omegaNom = 2 * Modelica.Constants.pi * 50,
    RPuLV = 0.001,
    LPuLV = 0.025,
    RPuHV = 0.001,
    LPuHV = 0.025,

    // Measurement filter
    k_filter = 1,
    T_filter = T_filter,

    // Inner d‑axis current controller
    k_p_d_current = kp_cc_2,
    k_i_d_current = ki_cc_2,

    // Inner q‑axis current controller
    k_p_q_current = kp_cc_2,
    k_i_q_current = ki_cc_2,

    // Outer d‑axis controller
    k_p_d_outer = kp_outer_2,
    k_i_d_outer = ki_outer_2,

    // Outer q‑axis controller
    k_p_q_outer = kp_outer_2,
    k_i_q_outer = ki_outer_2,

    // Voltage support and reactive power behaviour
    UboostHigh = 1.1,
    UboostLow = 0.9,
    Kqv = 0,

    // Current limits and operation mode
    Imax = 2,
    PQFlag = false,
    IqBoostMax = 0.5,
    IqBoostMin = -0.5,

    // Plant controller for Q
    K_p_q_plant = kp_plant_2,
    K_i_q_plant = ki_plant_2,

    // Plant controller for P
    K_p_p_plant = kp_plant_2,
    K_i_p_plant = ki_plant_2,

    // Droop and voltage‑Q coupling
    Lambda = 0.417,
    Kdroop = 15,

    // Reactive power limits
    QMaxPu = 0.3,
    QMinPu = -0.3,

    // Active power limits (note inversion of sign)
    PMaxPu = 0,
    PMinPu = -2,

    // Frequency / angle limits
    FEMaxPu = 999,
    FEMinPu = -999,
    FDbd1Pu = 0.005,
    FDbd2Pu = 0.1,
    DbdPu = 0.0001,

    // PLL gains and limits
    K_p_pll = kp_pll_2,
    K_i_pll = ki_pll_2,
    OmegaMaxPu = 1.1,
    OmegaMinPu = 0.9,

    // Anti‑windup / rate limiting
    DyMax_pi_d = 10000.0,
    DyMax_pi_q = 100000.0,
    DuMax_idref = 100000.0,
    DuMin_idref = -10000.0,

    // Active power reference sampling time
    tS_idref = 1e-4,

    // Equivalent delay between plant and outer loop
    delay_time_plant = delay_time_plant,

    // Enable voltage feed‑forward on both d and q axis
    voltagefeedforwardflag_d = 0,
    voltagefeedforwardflag_q = 0
  ) annotation(
    Placement(transformation(origin = {80, 24}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // ═══════════════════════════════════════════════════════════════
  // Network elements (transmission lines and buses)
  // All parameters in per unit on the system base
  // ═══════════════════════════════════════════════════════════════
  Lines.Line line(
    RPu = 0.00144,
    XPu = 0.0144,
    BPu = 0,
    GPu = 0) annotation(
    Placement(transformation(origin = {-34, 20}, extent = {{-10, -10}, {10, 10}})));

  Lines.Line line1(
    RPu = 0.00144,
    XPu = 0.0144,
    BPu = 0,
    GPu = 0) annotation(
    Placement(transformation(origin = {26, 20}, extent = {{-10, -10}, {10, 10}})));

  // Vertical line to infinite bus (segment 1)
  Lines.Line line2(
    RPu = 0.01,
    XPu = 0.07,
    BPu = 0,
    GPu = 0) annotation(
    Placement(transformation(origin = {-4, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Parallel / additional segment, which will be opened during the simulation
  Lines.Line line3(
    RPu = 0.0077775,
    XPu = 0.077775,
    GPu = 0,
    BPu = 0) annotation(
    Placement(transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Main AC bus connecting the two converters and the line to the infinite bus
  Buses.Bus bus annotation(
    Placement(transformation(origin = {-4, 20}, extent = {{-10, -10}, {10, 10}})));

  // Infinite bus with voltage and frequency variations
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(
    U0Pu = 1.100000,
    UPhase = -0.001082,
    omega0Pu = 1.0,
    // Voltage event (dip)
    UEvtPu = 0.5,
    tUEvtStart = 15.1,
    tUEvtEnd = 15.1,
    // No frequency event in this scenario
    omegaEvtPu = 1.0,
    tOmegaEvtStart = 1e6,
    tOmegaEvtEnd = 1e6) annotation(
    Placement(transformation(origin = {-4, -74}, extent = {{-10, -10}, {10, 10}})));

  // ═══════════════════════════════════════════════════════════════
  // Setpoints and reference signals for converters
  // ═══════════════════════════════════════════════════════════════

  // Frequency reference (per unit) for gFLmodel
  Modelica.Blocks.Sources.Constant omegaRefPu(
    k = 1.0) annotation(
    Placement(transformation(origin = {-130, -38}, extent = {{-10, -10}, {10, 10}})));

  // Frequency reference (per unit) for gFLmodel1
  Modelica.Blocks.Sources.Constant omegaRefPu1(
    k = 1.0) annotation(
    Placement(transformation(origin = {132, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  // Active power reference for gFLmodel:
  // PRef: step from 0.5 pu to 0.6 pu at t = 50 s
  Modelica.Blocks.Sources.Step step(
    offset = 0.5,
    height = 0.1,
    startTime = 50) annotation(
    Placement(transformation(origin = {-162, 68}, extent = {{-10, -10}, {10, 10}})));

  // Voltage reference for gFLmodel:
  // Step of +10% relative to URef0Pu at t = 480 s (outside main window)
  Modelica.Blocks.Sources.Step step1(
    height = 0.1 * URef0Pu,
    offset = URef0Pu,
    startTime = 480) annotation(
    Placement(transformation(origin = {-178, 16}, extent = {{-10, -10}, {10, 10}})));

  // Active power reference for gFLmodel1:
  // PRef: step from -0.5 pu to -0.4 pu at t = 50 s
  Modelica.Blocks.Sources.Step step2(
    height = 0.1,
    offset = -0.5,
    startTime = 50) annotation(
    Placement(transformation(origin = {130, -56}, extent = {{-10, -10}, {10, 10}})));

  // Constant voltage reference for gFLmodel1
  Modelica.Blocks.Sources.Constant UrefPu1(
    k = URef0Pu1) annotation(
    Placement(transformation(origin = {152, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  // Steady‑state voltage reference values based on Lambda and Q0
  final parameter Real URef0Pu  = gFLmodel.U0Pu  - gFLmodel.Lambda  * gFLmodel.Q0_pcc  * SystemBase.SnRef / gFLmodel.SNom;
  final parameter Real URef0Pu1 = gFLmodel1.U0Pu - gFLmodel1.Lambda * gFLmodel1.Q0_pcc * SystemBase.SnRef / gFLmodel1.SNom;

equation
  // ═══════════════════════════════════════════════════════════════
  // Line and converter switch logic
  // (all lines and converters initially in service,
  //  except line3, which opens at t = 51.5 s)
  // ═══════════════════════════════════════════════════════════════
  line.switchOffSignal1.value  = false;
  line.switchOffSignal2.value  = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;

  // line3 opens on side 1 at t = 51.5 s (line trip event)
  line3.switchOffSignal1.value = if time >= 51.5 then true else false;
  line3.switchOffSignal2.value = false;

  // Keep both converters online during the whole simulation
  gFLmodel.switchOffSignal1.value  = false;
  gFLmodel.switchOffSignal2.value  = false;
  gFLmodel.switchOffSignal3.value  = false;
  gFLmodel1.switchOffSignal1.value = false;
  gFLmodel1.switchOffSignal2.value = false;
  gFLmodel1.switchOffSignal3.value = false;

  // ═══════════════════════════════════════════════════════════════
  // Electrical connections (network topology)
  // ═══════════════════════════════════════════════════════════════
  connect(gFLmodel.terminalPcc, line.terminal1) annotation(
    Line(points = {{-64, 19}, {-64, 20}, {-44, 20}}, color = {0, 0, 255}));
  connect(line.terminal2, bus.terminal) annotation(
    Line(points = {{-24, 20}, {-4, 20}}, color = {0, 0, 255}));
  connect(bus.terminal, line1.terminal1) annotation(
    Line(points = {{-4, 20}, {16, 20}}, color = {0, 0, 255}));
  connect(line1.terminal2, gFLmodel1.terminalPcc) annotation(
    Line(points = {{36, 20}, {64, 21}}, color = {0, 0, 255}));
  connect(bus.terminal, line2.terminal1) annotation(
    Line(points = {{-4, 20}, {-4, -18}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{-4, -38}, {-4, -74}}, color = {0, 0, 255}));
  connect(line3.terminal2, line2.terminal2) annotation(
    Line(points = {{-40, -40}, {-4, -40}, {-4, -38}}, color = {0, 0, 255}));
  connect(line3.terminal1, line2.terminal1) annotation(
    Line(points = {{-40, -20}, {-4, -20}, {-4, -18}}, color = {0, 0, 255}));

  // ═══════════════════════════════════════════════════════════════
  // Connections of setpoints to converter control inputs
  // ═══════════════════════════════════════════════════════════════
  // Frequency references
  connect(omegaRefPu.y, gFLmodel.omegaRefPu) annotation(
    Line(points = {{-119, -38}, {-119, 4}, {-104, 4}}, color = {0, 0, 127}));
  connect(omegaRefPu1.y, gFLmodel1.omegaRefPu) annotation(
    Line(points = {{121, 84}, {121, 36}, {104, 36}}, color = {0, 0, 127}));

  // Active power references
  connect(step.y, gFLmodel.PRefPu) annotation(
    Line(points = {{-151, 68}, {-151, 30}, {-104, 30}}, color = {0, 0, 127}));
  connect(step2.y, gFLmodel1.PRefPu) annotation(
    Line(points = {{141, -56}, {141, 10}, {104, 10}}, color = {0, 0, 127}));

  // Voltage references
  connect(step1.y, gFLmodel.UREfPu) annotation(
    Line(points = {{-167, 16}, {-104, 16}}, color = {0, 0, 127}));
  connect(UrefPu1.y, gFLmodel1.UREfPu) annotation(
    Line(points = {{141, 34}, {120.5, 34}, {120.5, 24}, {104, 24}}, color = {0, 0, 127}));

  // ═══════════════════════════════════════════════════════════════
  // Simulation settings (Dynawo experiment annotation)
  // ═══════════════════════════════════════════════════════════════
  annotation(
    experiment(
      StartTime = 0,
      StopTime = 70,
      Tolerance = 1e-5,
      Interval = 0.0005),
    preferredView = "diagram",
  Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}));

end TwoConvertersStaticLine;