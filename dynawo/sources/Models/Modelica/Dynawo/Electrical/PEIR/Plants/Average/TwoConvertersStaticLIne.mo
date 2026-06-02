within Dynawo.Electrical.PEIR.Plants.Average;

model TwoConvertersStaticLIne
  GFLmodel gFLmodel(
    // ── Punto iniziale PCC (lato GFL1) ──
    SNom        = 100,
    U0Pu        = 1.1072,
    Uphase      = 0.098,
    P0_pcc      = -0.50,   
    Q0_pcc      = -0.021,
    Omega0Pu    = 1.0,
    // ── VSC delay ──
    tVSC        = 1e-100,
    // ── LC filter ──
    RfPu        = 0.003,
    LfPu        = 0.1,
    CfPu        = 1e-4,
    omegaNom    = 2 * Modelica.Constants.pi * 50,
    // ── Trasformatore LV ──
    RPuLV       = 0.001,
    LPuLV       = 0.025,
    // ── Trasformatore HV ──
    RPuHV       = 0.001,
    LPuHV       = 0.025,
    // ── Filtro misura  (ωc = 100 rad/s) ──
    k_filter    = 1.0,
    T_filter    = 1e-2,
    // ── Inner current loop  (ωc = 2000 rad/s) ──
    k_p_d_current  = 200.0,
    k_i_d_current  = 20000.0,
    k_p_q_current  = 200.0,
    k_i_q_current  = 20000.0,
    // ── Outer loop  (ωc = 200 rad/s) ──
    k_p_d_outer = 0.1,
    k_i_d_outer = 20.0,
    k_p_q_outer = 0.1,
    k_i_q_outer = 20.0,
    // ── Limiti corrente ──
    Imax        = 1.2,
    PQFlag      = false,
    UboostHigh  = 1.1,
    UboostLow   = 0.9,
    Kqv         = 0.0,
    IqBoostMax  = 0.4,
    IqBoostMin  = -0.4,
    // ── Plant controller  (ωc = 2 rad/s) ──
    K_p_p_plant = 0.1,
    K_i_p_plant = 1.0,
    K_p_q_plant = 0.1,
    K_i_q_plant = 1.0,
    Lambda      = 0.0,
    Kdroop      = 0.0,
    QMaxPu      =  0.5,
    QMinPu      = -0.5,
    PMaxPu      =  6.0,
    PMinPu      =  0.0,
    FEMaxPu     =  999,
    FEMinPu     = -999,
    FDbd1Pu     =  0.0,
    FDbd2Pu     =  0.0,
    DbdPu       =  0.0,
    // ── PLL  (ωc = 20 rad/s) ──
    K_p_pll     = 0.13,
    K_i_pll     = 1.27,
    OmegaMaxPu  = 1.1,
    OmegaMinPu  = 0.9,
    // ── Rate limiter / delay ──
    DyMax_pi_d      = 10000.0,
    DyMax_pi_q      = 100000.0,
    DuMax_idref     =  10.0,
    DuMin_idref     = -10.0,
    tS_idref        =  1e-4,
    delay_time_plant=  1e-3,
    voltagefeedforwardflag = 1
  ) annotation(Placement(transformation(origin = {-80, 20},
      extent = {{-20,-20},{20,20}})));

  GFLmodel gFLmodel1(
    SNom        = 100,
    U0Pu        = 1.0847,
    Uphase      =-0.18,
    P0_pcc      =  0.50,    
    Q0_pcc      = 0.021,
    Omega0Pu    = 1.0,
    tVSC        = 1e-100,
    RfPu        = 0.003,
    LfPu        = 0.1,
    CfPu        = 1e-4,
    omegaNom    = 2 * Modelica.Constants.pi * 50,
    RPuLV       = 0.001,
    LPuLV       = 0.025,
    RPuHV       = 0.001,
    LPuHV       = 0.025,
    k_filter    = 1.0,
    T_filter    = 1e-2,
    k_p_d_current  = 200.0,
    k_i_d_current  = 200000.0,
    k_p_q_current  = 200.0,
    k_i_q_current  = 200000.0,
    k_p_d_outer = 0.1,
    k_i_d_outer = 20.0,
    k_p_q_outer = 0.1,
    k_i_q_outer = 20.0,
    Imax        = 1.2,
    PQFlag      = true,
    UboostHigh  = 1.1,
    UboostLow   = 0.9,
    Kqv         = 0.0,
    IqBoostMax  = 0.4,
    IqBoostMin  = -0.4,
    K_p_p_plant = 0.1,
    K_i_p_plant = 1.0,
    K_p_q_plant = 0.1,
    K_i_q_plant = 1.0,
    Lambda      = 0.0,
    Kdroop      = 0.0,
    QMaxPu      =  0.5,
    QMinPu      = -0.5,
    PMaxPu      =  6.0,
    PMinPu      =  0.0,
    FEMaxPu     =  999,
    FEMinPu     = -999,
    FDbd1Pu     =  0.0,
    FDbd2Pu     =  0.0,
    DbdPu       =  0.0,
    K_p_pll     = 0.13,
    K_i_pll     = 1.27,
    OmegaMaxPu  = 1.1,
    OmegaMinPu  = 0.9,
    DyMax_pi_d      = 10000.0,
    DyMax_pi_q      = 100000.0,
    DuMax_idref     =  10.0,
    DuMin_idref     = -10.0,
    tS_idref        =  1e-4,
    delay_time_plant=  1e-3,
    voltagefeedforwardflag = 1
  ) annotation(Placement(transformation(origin = {80, 20},
      extent = {{-20,-20},{20,20}}, rotation = 180)));

  // ── Linee statiche (XPu = omegaNom * LPu) ───────────────────────────────
  // line:  GFL1 → Bus  (R=0.00144, L=0.0144 → X = 314.16*0.0144 ≈ 0.0144·ωnom)
  // Nota: se Lines.Line usa XPu direttamente in pu, usa i valori sotto
  Lines.Line line(
    RPu = 0.00005 + 0.0001875,  XPu = 0.00005 + 0.0001875,  BPu = 0,  GPu = 0
  ) annotation(Placement(transformation(origin = {-34, 20},
      extent = {{-10,-10},{10,10}})));

  // line1: Bus → GFL2
  Lines.Line line1(
    RPu = 0.00005 + 0.0001875,  XPu = 0.00005 + 0.0001875,  BPu = 0,  GPu = 0
  ) annotation(Placement(transformation(origin = {26, 20},
      extent = {{-10,-10},{10,10}})));

  // line2: Bus → InfiniteBus  (linea di connessione alla rete)
  Lines.Line line2(
    RPu = 0.005,   XPu = 0.05,    BPu = 0,  GPu = 0
  ) annotation(Placement(transformation(origin = {-4, -28},
      extent = {{-10,-10},{10,10}}, rotation = -90)));

  Buses.Bus bus annotation(
    Placement(transformation(origin = {-4, 20}, extent = {{-10,-10},{10,10}})));

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(
    U0Pu           = 1.1,
    UPhase         = -0.04,
    omega0Pu       = 1.0,
    UEvtPu         = 1.1,      // nessun evento attivo
    omegaEvtPu     = 1.0,
    tOmegaEvtStart = 1e6,
    tOmegaEvtEnd   = 1e6,
    tUEvtStart     = 1e6,
    tUEvtEnd       = 1e6
  ) annotation(Placement(transformation(origin = {-4, -74},
      extent = {{-10,-10},{10,10}})));
 final parameter Real URef0Pu = gFLmodel.U0Pu - gFLmodel.Lambda*gFLmodel.Q0_pcc;
  final parameter Real URef0Pu1 = gFLmodel1.U0Pu - gFLmodel1.Lambda*gFLmodel1.Q0_pcc;
  // ── Setpoint in steady-state (height=0 → costanti) ──────────────────────
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1.0) annotation(
    Placement(transformation(origin = {-138, -10}, extent = {{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu1(k = 1.0) annotation(
    Placement(transformation(origin = {142, -32},
      extent = {{-10,-10},{10,10}}, rotation = 180)));

  // GFL1: P = 5 pu (gen conv → PRef = 5), URef = U0Pu (Lambda=0)
  Modelica.Blocks.Sources.Constant PrefPu(k = 0.5) annotation(
    Placement(transformation(origin = {-142, 58}, extent = {{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant UrefPu(k = URef0Pu) annotation(
    Placement(transformation(origin = {-138, 22}, extent = {{-10,-10},{10,10}})));

  // GFL2: P = -5 pu (gen conv → importa), URef = U0Pu
  Modelica.Blocks.Sources.Constant PrefPu1(k = -0.5) annotation(
    Placement(transformation(origin = {148, 58},
      extent = {{-10,-10},{10,10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant UrefPu1(k = URef0Pu1) annotation(
    Placement(transformation(origin = {148, 20},
      extent = {{-10,-10},{10,10}}, rotation = 180)));
equation
  // No switch-off of the lines
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
// No switch off of the converters
  gFLmodel.switchOffSignal1.value=false; 
  gFLmodel.switchOffSignal2.value=false; 
  gFLmodel.switchOffSignal3.value=false;     
  gFLmodel1.switchOffSignal1.value=false; 
  gFLmodel1.switchOffSignal2.value=false; 
  gFLmodel1.switchOffSignal3.value=false;
  connect(gFLmodel.terminalPcc, line.terminal1) annotation(
    Line(points = {{-64, 23}, {-64, 20.5}, {-44, 20.5}, {-44, 20}}, color = {0, 0, 255}));
  connect(gFLmodel1.terminalPcc, line1.terminal2) annotation(
    Line(points = {{64, 17}, {64, 19}, {36, 19}, {36, 20}}, color = {0, 0, 255}));
  connect(line1.terminal1, bus.terminal) annotation(
    Line(points = {{16, 20}, {-4, 20}}, color = {0, 0, 255}));
  connect(line.terminal2, bus.terminal) annotation(
    Line(points = {{-24, 20}, {-4, 20}}, color = {0, 0, 255}));
  connect(line2.terminal1, bus.terminal) annotation(
    Line(points = {{-4, -18}, {-4, 20}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{-4, -38}, {-4, -74}}, color = {0, 0, 255}));
  connect(gFLmodel.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{-104, 8}, {-116.5, 8}, {-116.5, -10}, {-127, -10}}, color = {0, 0, 127}));
 
  connect(gFLmodel1.UREfPu, UrefPu1.y) annotation(
    Line(points = {{104, 20}, {137, 20}}, color = {0, 0, 127}));
  connect(gFLmodel.UREfPu, UrefPu.y) annotation(
    Line(points = {{-104, 20}, {-126, 20}, {-126, 22}}, color = {0, 0, 127}));
  connect(gFLmodel.PRefPu, PrefPu.y) annotation(
    Line(points = {{-104, 34}, {-130, 34}, {-130, 58}, {-131, 58}}, color = {0, 0, 127}));
 connect(PrefPu1.y, gFLmodel1.PRefPu) annotation(
    Line(points = {{140, -18}, {104, -18}, {104, 6}}, color = {0, 0, 127}));
 connect(gFLmodel1.omegaRefPu, omegaRefPu1.y) annotation(
    Line(points = {{104, 32}, {132, 32}, {132, 64}, {138, 64}}, color = {0, 0, 127}));
end TwoConvertersStaticLIne;