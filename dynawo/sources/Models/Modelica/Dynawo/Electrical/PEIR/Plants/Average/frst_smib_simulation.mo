within Dynawo.Electrical.PEIR.Plants.Average;

model frst_smib_simulation
  /*
     * First SMIB test — GFL converter in weak grid (SCR ~ 2.5)
   
   
     * Grid: Lg_total = Lf + Ltrafo = 0.15 + 0.20 = 0.35 pu  => SCR ~ 2.5
   
     */
 GFLModel gFLModel(
  // ── Initial PCC conditions ────────────────────────────────
  UrPcc0Pu = 1.18,
  UiPcc0Pu = 0.0,
  P0_pcc   = -0.72,
  Q0_pcc   = -0.749,
  Omega0Pu = 1.0,

  // ── VSC Pade delay ────────────────────────────────────────
  tVSC     =0.02,

  // ── LC filter ─────────────────────────────────────────────
  RfPu     = 0.01,
  LfPu     = 0.15,
  CfPu     = 0.02,
  omegaNom = 2*Modelica.Constants.pi*50,

  // ── Transformer + grid (weak grid) ───────────────────────
  RPu      = 0.05,
  LPu      = 0.20,

  // ── Measurement filter ────────────────────────────────────
  k_filter = 1.0,
  T_filter = 0.02,

  // ── Inner current loop (più forte) ────────────────────────
  // rispetto a 2/150: più smorzamento e meno integratore puro
  k_p_d_current = 3.0,
  k_i_d_current = 80.0,
  k_p_q_current = 3.0,
  k_i_q_current = 80.0,

  // ── Outer P/Q loop (più strong ma non folle) ──────────────
  k_p_d_outer = 0.35,
  k_i_d_outer = 10.0,
  k_p_q_outer = 0.30,
  k_i_q_outer = 7.0,

  // ── Current limiter / reactive boost ──────────────────────
  Imax        = 1.1,
  PQFlag      = true,
  UboostHigh  = 1.1,
  UboostLow   = 0.9,
  // per ora disabilita boost per evitare U > 1.2
  Kqv         = 0.0,
  IqBoostMax  = 0.0,
  IqBoostMin  = 0.0,

  // ── Plant controller (moderato) ───────────────────────────
  K_p_q_plant = 0.10,
  K_i_q_plant = 1.0,
  K_p_p_plant = 0.10,
  K_i_p_plant = 1.0,
  Lambda      = 1.0,
  Kdroop      = 0.03,
  QMaxPu      = 0.5,
  QMinPu      = -0.5,
  PMaxPu      = 1.2,
  PMinPu      = 0.0,
  FEMaxPu     = 0.05,
  FEMinPu     = -0.05,
  FDbd1Pu     = 0.005,
  FDbd2Pu     = 0.01,
  DbdPu       = 0.005,

  // ── PLL (più “duro” ma meno estremo di 50/200) ────────────
  K_p_pll    = 30.0,
  K_i_pll    = 120.0,
  OmegaMaxPu = 1.05,
  OmegaMinPu = 0.95,
  Theta0     = 0.0,

  // ── Outer-loop slew-rate & ramp limiter ───────────────────
  DyMax_pi_d       = 10.0,
  DyMax_pi_q       = 10.0,
  DuMax_idref      = 10.0,
  DuMin_idref      = -10.0,
  tS_idref         = 1e-4,
  delay_time_plant = 1e-3);

  // ── Infinite bus ──────────────────────────────────────────────
  // References — keep constant for first test, add step later
  Modelica.Blocks.Sources.Constant UrefPCC(k = 1.18) annotation(
    Placement(transformation(origin = {-56, 38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-86, 18}, extent = {{-10, -10}, {10, 10}})));
  // Step on Pref at t=5 s — observe transient response
  // For SSO study: increase step amplitude or reduce SCR (increase LPu)
  Modelica.Blocks.Sources.Step Pstep(height = 0, offset = 0.8, startTime = 500) annotation(
    Placement(transformation(origin = {-48, 2}, extent = {{-10, -10}, {10, 10}})));
  Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.18, UEvtPu = 0.5, omega0Pu = 1, UPhase = 0, tUEvtStart = 1000, tUEvtEnd = 1400, omegaEvtPu = 1.01, tOmegaEvtStart = 3000, tOmegaEvtEnd = 3000.5) annotation(
    Placement(transformation(origin = {74, 18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
// 0.5 ms — necessary to resolve 50 Hz dynamics
  connect(gFLModel.terminal, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{54, 18}, {74, 18}}, color = {0, 0, 255}));
  connect(UrefPCC.y, gFLModel.U_ref_pcc_pu) annotation(
    Line(points = {{-45, 38}, {-29.5, 38}, {-29.5, 32}, {-10, 32}}, color = {0, 0, 127}));
  connect(gFLModel.omegaRefPu, omegaRef.y) annotation(
    Line(points = {{-10, 18}, {-75, 18}}, color = {0, 0, 127}));
  connect(Pstep.y, gFLModel.PRefPu) annotation(
    Line(points = {{-36, 2}, {-10, 2}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-6, Interval = 0.0005));
end frst_smib_simulation;