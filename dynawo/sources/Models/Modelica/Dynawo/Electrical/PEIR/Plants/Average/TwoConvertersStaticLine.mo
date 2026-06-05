within Dynawo.Electrical.PEIR.Plants.Average;

model TwoConvertersStaticLine
  /*
   * Author: Gaia Bergamaschi
   * Two GFL converters connected back-to-back through a weak grid.
   *
   * Topology:
   *   GFL1 ──line──► BUS ◄──line1── GFL2
   *                   │
   *                 line2
   *                   │
   *               InfiniteBus (slack: U=1.0 pu, θ=0 rad)
   *
   * Operating point (@ nodo LV, misurato dal plant controller):
   *   GFL1: P = +0.5 pu, Q = +0.021 pu  (inietta P e Q)
   *   GFL2: P = -0.5 pu, Q = +0.021 pu  (assorbe P, inietta Q)
   *
   * Load flow (calcolato con trasformatori e filtro LC inclusi):
   *   GFL1 PCC: U = 1.00791 pu,  θ = +0.866°
   *   GFL2 PCC: U = 1.00555 pu,  θ = -1.042°
   *   BUS     : U = 1.00637 pu,  θ = -0.084°
   *   InfBus  : U = 1.00000 pu,  θ =  0.000°  ← slack
   *
   * Controller bandwidth hierarchy:
   *   Inner current loop : ωc = 2000 rad/s
   *   Outer P/Q loop     : ωc =  200 rad/s
   *   PLL                : ωc =   20 rad/s
   *   Plant controller   : ωc =    2 rad/s
   *
   * SCR ≈ 2.0  (griglia debole, Xg = 0.5 pu)
   *
   * Simulation: StopTime = 10 s, Interval = 0.5 ms, Tolerance = 1e-6
   * Perturbazione attivabile su PrefPu / UrefPu (vedi commenti sotto)
   */

  // ════════════════════════════════════════════════════════════════
  // GFL1 — generatore (P=+0.5 pu, Q=+0.021 pu)
  // ════════════════════════════════════════════════════════════════
  GFLmodel gFLmodel(
    // ── Punto iniziale PCC (da load flow con filtro LC) ───────────
    SNom        = 100,
    U0Pu        = 1.0079064480,
    Uphase      = 0.0151210646,    // +0.866 deg
    P0_pcc      = -0.4997539320,   // load conv: negativo = iniezione
    Q0_pcc      = -0.0148482991,   // load conv: negativo = iniezione Q
    Omega0Pu    = 1.0,
    // ── VSC delay ─────────────────────────────────────────────────
    tVSC        = 1e-100,
    // ── LC filter ─────────────────────────────────────────────────
    RfPu        = 0.003,
    LfPu        = 0.1,
    CfPu        = 1e-4,
    omegaNom    = 2 * Modelica.Constants.pi * 50,
    // ── Trasformatore LV ──────────────────────────────────────────
    RPuLV       = 0.001,
    LPuLV       = 0.025,
    // ── Trasformatore HV ──────────────────────────────────────────
    RPuHV       = 0.001,
    LPuHV       = 0.025,
    // ── Filtro misura (ωc = 100 rad/s) ───────────────────────────
    k_filter    = 1.0,
    T_filter    = 1e-2,
    // ── Inner current loop (ωc = 2000 rad/s) ─────────────────────
    // kp = ωc * Lf = 2000 * 0.1 = 200
    // ki = ωc^2 * Lf / 2 = 2000^2 * 0.1 / 2 = 200000
    k_p_d_current  = 200.0,
    k_i_d_current  = 200000.0,
    k_p_q_current  = 200.0,
    k_i_q_current  = 200000.0,
    // ── Outer P/Q loop (ωc = 200 rad/s) ──────────────────────────
    k_p_d_outer = 0.1,
    k_i_d_outer = 20.0,
    k_p_q_outer = 0.1,
    k_i_q_outer = 20.0,
    // ── Limiti corrente ───────────────────────────────────────────
    Imax        = 1.2,
    PQFlag      = false,         // Q-priority
    UboostHigh  = 1.1,
    UboostLow   = 0.9,
    Kqv         = 0.0,
    IqBoostMax  = 0.4,
    IqBoostMin  = -0.4,
    // ── Plant controller (ωc = 2 rad/s) ──────────────────────────
    K_p_p_plant = 0.1,
    K_i_p_plant = 1.0,
    K_p_q_plant = 0.1,
    K_i_q_plant = 1.0,
    Lambda      = 0.0,
    Kdroop      = 0.0,
    QMaxPu      =  0.5,
    QMinPu      = -0.5,
    PMaxPu      =  1.0,
    PMinPu      = -1.0,
    FEMaxPu     =  999,
    FEMinPu     = -999,
    FDbd1Pu     =  0.0,
    FDbd2Pu     =  0.0,
    DbdPu       =  0.0,
    // ── PLL (ωc = 20 rad/s, weak-grid tuning) ────────────────────
    // kp = 2*zeta*ωc / ωnom = 2*1*20/314.16 = 0.13
    // ki = ωc^2 / ωnom = 400/314.16 = 1.27
    K_p_pll     = 0.13,
    K_i_pll     = 1.27,
    OmegaMaxPu  = 1.1,
    OmegaMinPu  = 0.9,
    // ── Rate limiter / delay ──────────────────────────────────────
    DyMax_pi_d       = 10000.0,
    DyMax_pi_q       = 100000.0,
    DuMax_idref      = 10.0,
    DuMin_idref      = -10.0,
    tS_idref         = 1e-4,
    delay_time_plant = 1e-3,
    voltagefeedforwardflag = 1
  ) annotation(Placement(transformation(origin = {-80, 18},
      extent = {{-20,-20},{20,20}})));

  // ════════════════════════════════════════════════════════════════
  // GFL2 — carico attivo + compensatore Q (P=-0.5 pu, Q=+0.021 pu)
  // ════════════════════════════════════════════════════════════════
  GFLmodel gFLmodel1(
    // ── Punto iniziale PCC ────────────────────────────────────────
    SNom        = 100,
    U0Pu        = 1.0055449981,
    Uphase      = -0.0181928890,   // -1.042 deg
    P0_pcc      =  0.5002477123,   // load conv: positivo = assorbe P
    Q0_pcc      = -0.0148071930,   // load conv: negativo = inietta Q
    Omega0Pu    = 1.0,
    // ── VSC delay ─────────────────────────────────────────────────
    tVSC        = 1e-100,
    // ── LC filter ─────────────────────────────────────────────────
    RfPu        = 0.003,
    LfPu        = 0.1,
    CfPu        = 1e-4,
    omegaNom    = 2 * Modelica.Constants.pi * 50,
    // ── Trasformatore LV ──────────────────────────────────────────
    RPuLV       = 0.001,
    LPuLV       = 0.025,
    // ── Trasformatore HV ──────────────────────────────────────────
    RPuHV       = 0.001,
    LPuHV       = 0.025,
    // ── Filtro misura ─────────────────────────────────────────────
    k_filter    = 1.0,
    T_filter    = 1e-2,
    // ── Inner current loop ────────────────────────────────────────
    k_p_d_current  = 200.0,
    k_i_d_current  = 200000.0,
    k_p_q_current  = 200.0,
    k_i_q_current  = 200000.0,
    // ── Outer P/Q loop ────────────────────────────────────────────
    k_p_d_outer = 0.1,
    k_i_d_outer = 20.0,
    k_p_q_outer = 0.1,
    k_i_q_outer = 20.0,
    // ── Limiti corrente ───────────────────────────────────────────
    Imax        = 1.2,
    PQFlag      = false,
    UboostHigh  = 1.1,
    UboostLow   = 0.9,
    Kqv         = 0.0,
    IqBoostMax  = 0.4,
    IqBoostMin  = -0.4,
    // ── Plant controller ──────────────────────────────────────────
    K_p_p_plant = 0.1,
    K_i_p_plant = 1.0,
    K_p_q_plant = 0.1,
    K_i_q_plant = 1.0,
    Lambda      = 0.0,
    Kdroop      = 0.0,
    QMaxPu      =  0.5,
    QMinPu      = -0.5,
    PMaxPu      =  1.0,
    PMinPu      = -1.0,
    FEMaxPu     =  999,
    FEMinPu     = -999,
    FDbd1Pu     =  0.0,
    FDbd2Pu     =  0.0,
    DbdPu       =  0.0,
    // ── PLL ───────────────────────────────────────────────────────
    K_p_pll     = 0.13,
    K_i_pll     = 1.27,
    OmegaMaxPu  = 1.1,
    OmegaMinPu  = 0.9,
    // ── Rate limiter / delay ──────────────────────────────────────
    DyMax_pi_d       = 10000.0,
    DyMax_pi_q       = 100000.0,
    DuMax_idref      = 10.0,
    DuMin_idref      = -10.0,
    tS_idref         = 1e-4,
    delay_time_plant = 1e-3,
    voltagefeedforwardflag = 1
  ) annotation(Placement(transformation(origin = {80, 24},
      extent = {{-20,-20},{20,20}}, rotation = 180)));

  // ════════════════════════════════════════════════════════════════
  // Linee statiche
  // ════════════════════════════════════════════════════════════════
  // line:  GFL1 ── BUS
  Lines.Line line(
    RPu = 0.0005 + 0.001875,
    XPu = 0.015  + 0.01875,
    BPu = 0,
    GPu = 0
  ) annotation(Placement(transformation(origin = {-34, 20},
      extent = {{-10,-10},{10,10}})));

  // line1: BUS ── GFL2
  Lines.Line line1(
    RPu = 0.0005 + 0.001875,
    XPu = 0.015  + 0.01875,
    BPu = 0,
    GPu = 0
  ) annotation(Placement(transformation(origin = {26, 20},
      extent = {{-10,-10},{10,10}})));

  // line2: BUS ── InfiniteBus  (griglia debole: Xg=0.5 → SCR≈2)
  Lines.Line line2(
    RPu = 0.05,
    XPu = 0.5,
    BPu = 0,
    GPu = 0
  ) annotation(Placement(transformation(origin = {-4, -28},
      extent = {{-10,-10},{10,10}}, rotation = -90)));

  Buses.Bus bus annotation(
    Placement(transformation(origin = {-4, 20},
      extent = {{-10,-10},{10,10}})));

  // ════════════════════════════════════════════════════════════════
  // InfiniteBus — slack
  // Per attivare fault: modifica tUEvtStart/tUEvtEnd e UEvtPu
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(
    U0Pu           = 1.0,
    UPhase         = 0.0,
    omega0Pu       = 1.0,
    // ── Fault tensione (attivabile) ────────────────────────────────
    // Per un dip al 70%: UEvtPu=0.7, tUEvtStart=5.0, tUEvtEnd=5.15
    UEvtPu         = 0.7,
    tUEvtStart     = 1e6,    // inattivo — cambia a 5.0 per attivare
    tUEvtEnd       = 1e6,
    // ── Variazione frequenza (attivabile) ─────────────────────────
    // Per step freq: omegaEvtPu=1.02, tOmegaEvtStart=5.0, tOmegaEvtEnd=5.5
    omegaEvtPu     = 1.0,
    tOmegaEvtStart = 1e6,    // inattivo
    tOmegaEvtEnd   = 1e6
  ) annotation(Placement(transformation(origin = {-4, -74},
      extent = {{-10,-10},{10,10}})));

  // ════════════════════════════════════════════════════════════════
  // Setpoint — costanti in steady-state
  // Per perturbazioni: sostituisci Constant con Step
  // ════════════════════════════════════════════════════════════════

  // GFL1 — omega ref
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1.0) annotation(
    Placement(transformation(origin = {-130, -38},
      extent = {{-10,-10},{10,10}})));

  // GFL2 — omega ref
  Modelica.Blocks.Sources.Constant omegaRefPu1(k = 1.0) annotation(
    Placement(transformation(origin = {132, 74},
      extent = {{-10,-10},{10,10}}, rotation = 180)));

  // GFL1 — P ref
  // Per step attivo: Modelica.Blocks.Sources.Step PrefPu(offset=0.5, height=-0.2, startTime=5.0)
  Modelica.Blocks.Sources.Constant PrefPu(k = 0.5) annotation(
    Placement(transformation(origin = {-132, 58},
      extent = {{-10,-10},{10,10}})));

  // GFL1 — U ref (Lambda=0 → URef = U0Pu)
  Modelica.Blocks.Sources.Constant UrefPu(k = 1.00790645) annotation(
    Placement(transformation(origin = {-140, 18},
      extent = {{-10,-10},{10,10}})));

  // GFL2 — P ref (negativo = assorbe)
  Modelica.Blocks.Sources.Constant PrefPu1(k = -0.5) annotation(
    Placement(transformation(origin = {148, -28},
      extent = {{-10,-10},{10,10}}, rotation = 180)));

  // GFL2 — U ref
  Modelica.Blocks.Sources.Constant UrefPu1(k = 1.00554500) annotation(
    Placement(transformation(origin = {148, 20},
      extent = {{-10,-10},{10,10}}, rotation = 180)));

equation
  // ── Switch-off disabilitati ──────────────────────────────────────
  line.switchOffSignal1.value  = false;
  line.switchOffSignal2.value  = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  gFLmodel.switchOffSignal1.value  = false;
  gFLmodel.switchOffSignal2.value  = false;
  gFLmodel.switchOffSignal3.value  = false;
  gFLmodel1.switchOffSignal1.value = false;
  gFLmodel1.switchOffSignal2.value = false;
  gFLmodel1.switchOffSignal3.value = false;

  // ── Connessioni elettriche ───────────────────────────────────────
  connect(gFLmodel.terminalPcc,  line.terminal1) annotation(
    Line(points = {{-64, 21}, {-64, 20},{-44, 20}}, color = {0,0,255}));
  connect(line.terminal2,        bus.terminal) annotation(
    Line(points = {{-24, 20},{-4, 20}},  color = {0,0,255}));
  connect(bus.terminal,          line1.terminal1) annotation(
    Line(points = {{-4, 20},{16, 20}},   color = {0,0,255}));
  connect(line1.terminal2,       gFLmodel1.terminalPcc) annotation(
    Line(points = {{36, 20},{36, 21}, {64, 21}},   color = {0,0,255}));
  connect(bus.terminal,          line2.terminal1) annotation(
    Line(points = {{-4, 20},{-4, -18}},  color = {0,0,255}));
  connect(line2.terminal2,       infiniteBusWithVariations.terminal) annotation(
    Line(points = {{-4, -38},{-4, -74}}, color = {0,0,255}));

  // ── Connessioni segnali GFL1 ─────────────────────────────────────
  connect(omegaRefPu.y,  gFLmodel.omegaRefPu) annotation(
    Line(points = {{-119, -38}, {-119, 6},{-104,6}},  color = {0,0,127}));
  connect(PrefPu.y,      gFLmodel.PRefPu) annotation(
    Line(points = {{-121, 58}, {-121, 32},{-104,32}},  color = {0,0,127}));
  connect(UrefPu.y,      gFLmodel.UREfPu) annotation(
    Line(points = {{-129, 18}, {-104, 18}},  color = {0,0,127}));


  // ── Connessioni segnali GFL2 ─────────────────────────────────────
  connect(omegaRefPu1.y, gFLmodel1.omegaRefPu) annotation(
    Line(points = {{121, 74}, {121, 36},{104,36}},   color = {0,0,127}));
  connect(PrefPu1.y,     gFLmodel1.PRefPu) annotation(
    Line(points = {{137, -28}, {125.5, -28}, {125.5, 10},{104,10}},     color = {0,0,127}));
  connect(UrefPu1.y,     gFLmodel1.UREfPu) annotation(
    Line(points = {{137,20},{120.5, 20}, {120.5, 24}, {104, 24}},    color = {0,0,127}));
  annotation(
    experiment(
      StartTime = 0,
      StopTime  = 10,
      Tolerance = 1e-6,
      Interval  = 0.0005),
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>
      <h3>TwoConvertersStaticLine</h3>
      <p><b>Operating point:</b> GFL1 injects P=+0.5, Q=+0.021 pu;
         GFL2 absorbs P=-0.5, injects Q=+0.021 pu (@ LV node).</p>
      <p><b>Grid:</b> SCR ≈ 2.0 (Xg = 0.5 pu, weak grid).</p>
      <p><b>To activate voltage dip:</b> set tUEvtStart=5.0, tUEvtEnd=5.15 in infiniteBusWithVariations.</p>
      <p><b>To activate P step:</b> replace PrefPu Constant with Step(offset=0.5, height=-0.2, startTime=5.0).</p>
    </body></html>"));

end TwoConvertersStaticLine;