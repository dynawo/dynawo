within Dynawo.Electrical.PEIR.Plants.Average;

model frst_smib_simulation
  /*
     * First SMIB test — GFL converter in weak grid (SCR ~ 2.5)
   
   
     * Grid: Lg_total = Lf + Ltrafo = 0.15 + 0.20 = 0.35 pu  => SCR ~ 2.5
   
     */
  GFLModel gFLModel( // ── Initial PCC conditions ────────────────────────────────
 // U_pcc = 1.0 pu, aligned with d-axis (theta0 = 0)
 // Q0 = 0 for clean initialisation — add reactive power after first test passes
  UrPcc0Pu = 0.97, UiPcc0Pu = 0.0, P0_pcc = -0.8, Q0_pcc =0.7,  // ── VSC Pade delay ────────────────────────────────────────
  tVSC = 0.02,  // ── LC filter ─────────────────────────────────────────────
 // Lf = 0.15 pu: realistic filter inductance
  RfPu = 0.01, LfPu = 0.15, CfPu = 0.02, omegaNom = 2*Modelica.Constants.pi*50, Omega0Pu = 1,  // ── Transformer + grid (weak grid SCR ~ 2.5) ──────────────
 // Lg_total = Lf + LPu = 0.15 + 0.20 = 0.35 pu
  RPu = 0.05, LPu = 0.20,  // ── Measurement filter ────────────────────────────────────
 // T_filter = 0.02 s (50 Hz bandwidth) — realistic PMU-like
  k_filter = 1.0, T_filter = 0.02,  // ── Inner current loop (bandwidth ~127 Hz) ────────────────
 // From table: omega_cc = 800 rad/s => kp = omega_cc*Lg = 800*0.35 = 280
 // Simplified: kp = 2.0, ki = 150 for first test
  k_p_d_current = 2.0, k_i_d_current = 150.0, k_p_q_current = 2.0, k_i_q_current = 150.0,  // ── Outer loop (bandwidth 1-8 Hz — SSO range) ─────────────
 // omega_p = 10 rad/s => slow, inside SSO range
  k_p_d_outer = 0.25, k_i_d_outer = 8.0, k_p_q_outer = 0.20, k_i_q_outer = 5.0, k_q_outer = 1.0,  // ── Current limiter ───────────────────────────────────────
 // Iq boost disabled for first test — enable after validation
  Imax = 1.1, PQFlag = true, UboostStart = 0.9, Kqv = 4, IqBoostMax = 1.1, IqBoostMin = -1.1,  // ── Rate limiters on references ───────────────────────────
  dPrefMaxPu = 0.5, dQrefMaxPu = 0.5,  // ── Plant controller ──────────────────────────────────────
  K_p_q_plant = 0.20, K_i_q_plant = 2.0, K_p_p_plant = 0.20, K_i_p_plant = 2.0, Lambda = 2, Kdroop_p = 0.05, QMaxPu = 0.5, QMinPu = -0.5, PMaxPu = 1.2, PMinPu = 0.0, FEMaxPu = 0.05, FEMinPu = -0.05, FDbd1Pu = 0.005, FDbd2Pu = 0.01, DbdPu = 0.005,  // ── PLL (bandwidth ~49 Hz from table) ─────────────────────
 // From table: omega_n = 200 rad/s, xi = 1
 // Kp = 2*xi*omega_n / U_pcc = 400
 // Ki = omega_n^2 / U_pcc   = 40000
 // Reduced here for first test — increase progressively to see SSO
  K_p_pll = 50.0, K_i_pll = 200.0, OmegaMaxPu = 1.05, OmegaMinPu = 0.95, Theta0 = 0) annotation(
    Placement(transformation(origin = {22, 14}, extent = {{-30, -30}, {30, 30}})));
  // ── Infinite bus ──────────────────────────────────────────────
  // References — keep constant for first test, add step later
  Modelica.Blocks.Sources.Constant UrefPCC(k = 0.97) annotation(
    Placement(transformation(origin = {-58, 62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant UrefConv(k = 1.0) annotation(
    Placement(transformation(origin = {-60, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-58, -8}, extent = {{-10, -10}, {10, 10}})));
  // Step on Pref at t=5 s — observe transient response
  // For SSO study: increase step amplitude or reduce SCR (increase LPu)
  Modelica.Blocks.Sources.Step Pstep(height = 0, offset = 0.8, startTime = 500) annotation(
    Placement(transformation(origin = {-54, -44}, extent = {{-10, -10}, {10, 10}})));
  Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 0.97, UEvtPu = 0.5, omega0Pu = 1, UPhase = 0, tUEvtStart = 10, tUEvtEnd = 14, omegaEvtPu = 1.01, tOmegaEvtStart = 30, tOmegaEvtEnd = 30.5)  annotation(
    Placement(transformation(origin = {72, 16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(UrefPCC.y, gFLModel.U_ref_pcc_pu) annotation(
    Line(points = {{-47, 62}, {-38, 62}, {-38, 32}, {-11, 32}}, color = {0, 0, 127}));
  connect(UrefConv.y, gFLModel.u_ref_conv) annotation(
    Line(points = {{-49, 26}, {-30, 26}, {-30, 20}, {-11, 20}}, color = {0, 0, 127}));
  connect(omegaRef.y, gFLModel.omegaRefPu) annotation(
    Line(points = {{-47, -8}, {-38, -8}, {-38, 8}, {-11, 8}}, color = {0, 0, 127}));
  connect(Pstep.y, gFLModel.PRefu) annotation(
    Line(points = {{-43, -44}, {-24.5, -44}, {-24.5, -4}, {-11, -4}}, color = {0, 0, 127}));
// 0.5 ms — necessary to resolve 50 Hz dynamics
  connect(gFLModel.terminal, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{54.85, 15.35}, {72.85, 15.35}, {72.85, 16}, {72, 16}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-6, Interval = 0.0005));
end frst_smib_simulation;