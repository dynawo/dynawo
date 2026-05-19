within Dynawo.Electrical.PEIR.Plants.Average;

model p_step_simulation


  /*
   * SMIB test — GFL converter
   * Operating point: P = 0.6 pu, Q ~ 0 pu, U_pcc = 1.0047 pu
   *
   * Tuning strategy (bandwidth separation):
   *   - Inner current loop : omega_cc  = 300 rad/s  (~48 Hz)
   *       k_p = omega_cc * L_g = 300 * 0.009 = 2.7
   *       k_i = (omega_cc/10) * k_p = 30 * 2.7 = 81
   *   - Outer loop         : omega_out =  30 rad/s  (~5 Hz)
   *       k_p = 0.3,  k_i = 1.0
   *   - PLL                : omega_pll =  10 rad/s  (~1.6 Hz)
   *       k_p = 10,   k_i = 25
   *   - Plant controller   : omega_plt ~  2 rad/s
   *       k_p = 0.05, k_i = 0.5
   */

  GFLmodel gFLmodelnodyn(
    // ── Initial conditions — PCC node ────────────────────────
   SNom=100,
    UrPcc0Pu = Ur,
    UiPcc0Pu = Ui,
    P0_pcc   = -0.7,
    Q0_pcc   = -0.1966753431984517475,
    Omega0Pu = 1.0,

    // ── VSC Pade delay ────────────────────────────────────────
    tVSC = 1e-100,

    // ── LC filter ─────────────────────────────────────────────
    RfPu     = 0.00001,
    LfPu     = 0.001,
    CfPu     = 1e-4,
    omegaNom = 2 * Modelica.Constants.pi * 50,

    // ── LV transformer (filter → LV node) ────────────────────
    RPuLV = 0.005,
    LPuLV = 0.008,

    // ── HV transformer (LV node → PCC) ───────────────────────
    RPuHV = 0.001,
    LPuHV = 0.005,

    // ── Measurement filter ────────────────────────────────────
    k_filter = 1,
    T_filter = 1e-2,

    // ── Inner current loop ────────────────────────────────────
    k_p_d_current = 10.8,
    k_i_d_current = 1296.0,
    k_p_q_current = 10.8,
    k_i_q_current = 1296.0,

    // ── Outer loop ────────────────────────────────────────────
    // omega_out = 30 rad/s (10x below current loop)
  k_p_d_outer = 0.3,
k_i_d_outer = 10.0,
k_p_q_outer = 0.3,
k_i_q_outer = 6.0,

    // ── Current limiter ───────────────────────────────────────
    UboostHigh = 1.1,
    UboostLow  = 0.9,
    Kqv        = 0.3,
    Imax       = 8,
    PQFlag     = false,
    IqBoostMax = 0.5,
    IqBoostMin = -0.5,

    // ── Plant controller ──────────────────────────────────────
    // omega_plt ~ 2 rad/s (very slow, well below outer loop)
    K_p_q_plant = 0.1,
    K_i_q_plant = 1,
    K_p_p_plant = 0.5,
    K_i_p_plant = 2,

    Lambda      = 0.28,
    Kdroop      = 0.03,
    QMaxPu      = 0.5,
    QMinPu      = -0.5,
    PMaxPu      = 23,
    PMinPu      = 0,
    FEMaxPu     = 0.05,
    FEMinPu     = -0.05,
    FDbd1Pu     = 0.005,
    FDbd2Pu     = 0.01,
    DbdPu       = 0.005,

    // ── PLL ───────────────────────────────────────────────────
    // omega_pll = 10 rad/s (3x below outer loop)
    K_p_pll    = 10.0,
    K_i_pll    = 25.0,
    OmegaMaxPu = 1.05,
    OmegaMinPu = 0.95,
    Theta0     = Uphase,

    // ── Rate limiters and delays ──────────────────────────────
    DyMax_pi_d       = 10000.0,
    DyMax_pi_q       = 100000.0,
    DuMax_idref      = 10.0,
    DuMin_idref      = -10.0,
    tS_idref         = 1e-4,
    delay_time_plant = 1e-3,

    // ── Voltage feedforward ───────────────────────────────────
    voltagefeedforwardflag = 1) annotation(
    Placement(transformation(origin = {42, 8}, extent = {{-28, -28}, {28, 28}})));

  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-64, -34}, extent = {{-10, -10}, {10, 10}})));

 final parameter Real U0Pu = 1.037213742957;//Modelica.ComplexMath.'abs'(Complex(0.9712,0.211317));
  final parameter Real Uphase = 0.204890124;//Modelica.ComplexMath.arg(Complex(0.9712,0.211317));
  final parameter Real URef0Pu =  U0Pu -gFLmodelnodyn.Lambda * gFLmodelnodyn.Q0_pcc;
  final parameter Complex terminalV     = ComplexMath.fromPolar(U0Pu, Uphase);
  final parameter Real Ur = terminalV.re;
  final parameter Real Ui = terminalV.im;

  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.7, startTime = 10) annotation(
    Placement(transformation(origin = {-66, 42}, extent = {{-10, -10}, {10, 10}})));
  Lines.Line line(RPu = 0, XPu = 0.3, GPu = 0, BPu = 0)  annotation(
    Placement(transformation(origin = {42, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Step step1(offset = URef0Pu, startTime = 10000, height = 0)  annotation(
    Placement(transformation(origin = {-66, 8}, extent = {{-10, -10}, {10, 10}})));
  Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 0.55, omega0Pu = 1, omegaEvtPu = 1, UPhase = 0, tUEvtStart = 100, tUEvtEnd = 140, tOmegaEvtStart = 10000, tOmegaEvtEnd = 10001)  annotation(
    Placement(transformation(origin = {42, -76}, extent = {{-22, -22}, {22, 22}})));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(omegaRef.y, gFLmodelnodyn.omegaRefPu) annotation(
    Line(points = {{-53, -34}, {-35, -34}, {-35, -9}, {8, -9}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.PRefPu, step.y) annotation(
    Line(points = {{8, 28}, {-54, 28}, {-54, 42}}, color = {0, 0, 127}));
  connect(line.terminal1, gFLmodelnodyn.terminalPcc) annotation(
    Line(points = {{42, -26}, {42, -14}}, color = {0, 0, 255}));
  connect(step1.y, gFLmodelnodyn.UREfPu) annotation(
    Line(points = {{-55, 8}, {8, 8}}, color = {0, 0, 127}));
  connect(infiniteBusWithVariations.terminal, line.terminal2) annotation(
    Line(points = {{42, -76}, {42, -46}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(
      StartTime = 0,
      StopTime  = 5,
      Tolerance = 1e-6,
      Interval  = 0.0005));


end p_step_simulation;