within Dynawo.Electrical.PEIR.Plants.Average;

model TwoConvertersDynamicLine

  // ═══════════════════════════════════════════════════════════════
  // Frequenze di taglio target — modifica solo questi
  // NOTA: questo blocco resta come "dead code" rispetto ai guadagni
  // hardcoded nei due GFLmodel sotto (vedi discussione precedente).
  // Non l'ho collegato per non introdurre cambi non richiesti.
  // ═══════════════════════════════════════════════════════════════
  parameter Real OmegaCC          = 1200;  // inner current loop  [rad/s]
  parameter Real w_cc_outer       = 10;    // outer P/Q loop      [rad/s]
  parameter Real w_cc_plant       = 2;     // plant controller    [rad/s]
  parameter Real OmegaPLL         = 100;    // PLL                 [rad/s]
  parameter Real KsiPLL           = 1;   // PLL
  parameter Real OmegaLPF         = 300;   // filter    [rad/s]
  parameter Real delay_time_plant = 0.02;  // delay plant→outer [s]
  final parameter Real T_filter   = 1.0 / OmegaLPF;

  // ═══════════════════════════════════════════════════════════════
  // Impedenze effettive
  // ═══════════════════════════════════════════════════════════════
  final parameter Real Rf1 = gFLmodel.RfPu  + gFLmodel.RPuLV;
  final parameter Real Lf1 = gFLmodel.LfPu  + gFLmodel.LPuLV;
  final parameter Real Rf2 = gFLmodel1.RfPu + gFLmodel1.RPuLV;
  final parameter Real Lf2 = gFLmodel1.LfPu + gFLmodel1.LPuLV;

  // ═══════════════════════════════════════════════════════════════
  // Guadagni GFL1
  // ═══════════════════════════════════════════════════════════════
  final parameter Real kp_cc_1    = Lf1 * OmegaCC / SystemBase.omegaNom;
  final parameter Real ki_cc_1    = Rf1 * OmegaCC;
  final parameter Real kp_outer_1 = w_cc_outer / OmegaLPF;
  final parameter Real ki_outer_1 = w_cc_outer;
  final parameter Real kp_pll_1   = 2.0 * KsiPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real ki_pll_1   = OmegaPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real kp_plant_1 = w_cc_plant / w_cc_outer;
  final parameter Real ki_plant_1 =  w_cc_plant;

  // ═══════════════════════════════════════════════════════════════
  // Guadagni GFL2
  // ═══════════════════════════════════════════════════════════════
  final parameter Real kp_cc_2    = Lf2 * OmegaCC / SystemBase.omegaNom;
  final parameter Real ki_cc_2    = Rf2 * OmegaCC;
  final parameter Real kp_outer_2 = w_cc_outer / OmegaLPF;
  final parameter Real ki_outer_2 = w_cc_outer;
  final parameter Real kp_pll_2   = 2.0 * KsiPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real ki_pll_2   = OmegaPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real kp_plant_2 = w_cc_plant / w_cc_outer;
  final parameter Real ki_plant_2 =  w_cc_plant;

  // ═══════════════════════════════════════════════════════════════
  // GFL1
  // CAMBI vs originale: Kqv 0 -> 1/300 ; tVSC 0.00001 -> 0 ;
  //   k_p_q_current 3.6 -> 0.3819 ; k_i_q_current 0.3819 -> 3.60
  //   (asse q allineato all'asse d, come in file 1 dove Kpc/Kic sono unici)
  // ═══════════════════════════════════════════════════════════════
  GFLmodel gFLmodel(
    SNom = 1000, U0Pu = 1.091230, Uphase = 0.063246,
    P0_pcc = -4.99, Q0_pcc = -0.21, Omega0Pu = 1.0,
   tVSC = 0,
    RfPu = 0.003, LfPu = 0.1, CfPu = 1e-5,
    omegaNom = 2 * Modelica.Constants.pi * 50,
    RPuLV = 0.001, LPuLV = 0.025,
    RPuHV = 0.001, LPuHV = 0.025,
    k_filter = 1, T_filter = T_filter,
    k_i_d_current = 3.60, k_p_d_current = 0.3819,
    k_p_q_current = 0.3819, k_i_q_current = 3.60,
    k_p_d_outer = 0.033, k_i_d_outer = 10,
    k_p_q_outer = 0.033, k_i_q_outer = 10,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 1/300,
    Imax = 10, PQFlag = true,
    IqBoostMax = 0.5, IqBoostMin = -0.5,
    K_p_q_plant = kp_plant_1, K_i_q_plant = ki_plant_1,
    K_p_p_plant = kp_plant_1, K_i_p_plant = ki_plant_1,
    Lambda = 0.417, Kdroop = 15,
    QMaxPu = 0.3, QMinPu = -0.3,
    PMaxPu = 2,   PMinPu = 0,
    FEMaxPu = 999, FEMinPu = -999,
    FDbd1Pu = 0.005, FDbd2Pu = 0.1,
    DbdPu = 0.0001,
    K_p_pll =0.318, K_i_pll = 7.95,
    OmegaMaxPu = 10, OmegaMinPu = 0,
    DyMax_pi_d = 10000.0, DyMax_pi_q = 100000.0,
    DuMax_idref = 10.0,   DuMin_idref = -10.0,
    tS_idref = 1e-4,
    delay_time_plant = delay_time_plant,
    voltagefeedforwardflag_d =0, voltagefeedforwardflag_q = 0, T_boost = 1e-4
  ) annotation(
    Placement(transformation(origin = {-80, 16}, extent = {{-20, -20}, {20, 20}})));

  // ═══════════════════════════════════════════════════════════════
  // GFL2
  // Stessi cambi di GFL1: Kqv, tVSC, asse q current loop
  // NOTA: K_p/K_i_*_plant usano ancora i coefficienti "_1" come
  // nell'originale (kp_plant_1/ki_plant_1) — non l'ho toccato perché
  // numericamente identico a "_2" (stessa formula, nessuna dipendenza
  // da parametri del convertitore). Segnalato in precedenza come
  // copy-paste da eventualmente sistemare per chiarezza.
  // ═══════════════════════════════════════════════════════════════
  GFLmodel gFLmodel1(
    SNom = 1000, U0Pu = 1.086638, Uphase = -0.063421,
    P0_pcc = 4.989324, Q0_pcc = -0.21, Omega0Pu = 1.0,
    tVSC = 0,
    RfPu = 0.003, LfPu = 0.1, CfPu = 1e-5,
    omegaNom = 2 * Modelica.Constants.pi * 50,
    RPuLV = 0.001, LPuLV = 0.025,
    RPuHV = 0.001, LPuHV = 0.025,
    k_filter = 1, T_filter = T_filter,
    k_i_d_current = 3.60, k_p_d_current = 0.3819,
    k_p_q_current = 0.3819, k_i_q_current = 3.60,
    k_p_d_outer = 0.033, k_i_d_outer = 10,
    k_p_q_outer = 0.033, k_i_q_outer = 10,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 1/300,
    Imax = 10, PQFlag = true,
    IqBoostMax = 0.5, IqBoostMin = -0.5,
    K_p_q_plant = kp_plant_1, K_i_q_plant = ki_plant_1,
    K_p_p_plant = kp_plant_1, K_i_p_plant = ki_plant_1,
    Lambda = 0.417, Kdroop = 15,
    QMaxPu = 0.3, QMinPu = -0.3,
    PMaxPu = 0,   PMinPu = -2,
    FEMaxPu = 999, FEMinPu = -999,
    FDbd1Pu = 0.005, FDbd2Pu = 0.1,
    DbdPu = 0.0001,
    K_p_pll =0.318, K_i_pll = 7.95,
    OmegaMaxPu = 10, OmegaMinPu = 0,
    DyMax_pi_d = 10000.0, DyMax_pi_q = 100000.0,
    DuMax_idref = 10.0,   DuMin_idref = -10.0,
    tS_idref = 1e-4,
    delay_time_plant = delay_time_plant,
    voltagefeedforwardflag_d =0, voltagefeedforwardflag_q = 0, T_boost = 1e-4
  ) annotation(
    Placement(transformation(origin = {80, 24}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // ═══════════════════════════════════════════════════════════════
  // Rete
  // ═══════════════════════════════════════════════════════════════
  Buses.Bus bus annotation(
    Placement(transformation(origin = {-4, 20}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(
    U0Pu = 1.100000, UPhase = -0.001082, omega0Pu = 1.0,
    UEvtPu = 0.5, tUEvtStart = 15.1, tUEvtEnd = 15.1,
    omegaEvtPu = 1.0, tOmegaEvtStart = 1e6, tOmegaEvtEnd = 1e6) annotation(
    Placement(transformation(origin = {-4, -74}, extent = {{-10, -10}, {10, 10}})));

  // ═══════════════════════════════════════════════════════════════
  // Setpoint
  // ═══════════════════════════════════════════════════════════════
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1.0) annotation(
    Placement(transformation(origin = {-130, -38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu1(k = 1.0) annotation(
    Placement(transformation(origin = {132, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step step(offset = 0.5, height = 0.1, startTime = 500) annotation(
    Placement(transformation(origin = {-162, 68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(height = 0.1*URef0Pu, offset = URef0Pu, startTime = 480) annotation(
    Placement(transformation(origin = {-178, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step2(height = -0.1, offset = -0.5, startTime = 500) annotation(
    Placement(transformation(origin = {130, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant UrefPu1(k = URef0Pu1) annotation(
    Placement(transformation(origin = {152, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  final parameter Real URef0Pu  = gFLmodel.U0Pu  - gFLmodel.Lambda  * gFLmodel.Q0_pcc  * SystemBase.SnRef / gFLmodel.SNom;
  final parameter Real URef0Pu1 = gFLmodel1.U0Pu - gFLmodel1.Lambda * gFLmodel1.Q0_pcc * SystemBase.SnRef / gFLmodel1.SNom;

  // ═══════════════════════════════════════════════════════════════
  // dynLine (GFL1 -> bus)
  // Copiata da ZGFL1 in file 1, STESSO orientamento
  // (ZGFL1.terminal1->GFL1, terminal2->Bus  ==
  //  dynLine.terminal1->gFLmodel, terminal2->bus)
  // ═══════════════════════════════════════════════════════════════
  DynLine dynLine(
    RPu = 0.00144, LPu = 0.0144,
    U01Pu = 1.01925978, UPhase01 = -11.490041 * 3.14 / 180,
    P01Pu = -5,          Q01Pu = 0.21,
    U02Pu = 1.03733331,  UPhase02 = -2.278818 * 3.14 / 180,
    P02Pu = 5.05725313,  Q02Pu = 0.60359717) annotation(
    Placement(transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}})));

  // ═══════════════════════════════════════════════════════════════
  // dynLine1 (bus -> GFL2)
  // Copiata da ZGFL2, ma ORIENTAMENTO INVERTITO rispetto a ZGFL2:
  // ZGFL2.terminal1->GFL2, terminal2->Bus  ==
  // dynLine1.terminal1->bus, terminal2->gFLmodel1  => scambiati 1<->2
  // NOTA: uso UPhase02 = -2.278818*3.14/180 (versione corretta),
  // non il refuso "*180/3.14" presente nell'originale ZGFL2.UPhase02
  // ═══════════════════════════════════════════════════════════════
  DynLine dynLine1(
    RPu = 0.00144, LPu = 0.0144,
    U01Pu = 1.03733331, UPhase01 = -2.278818 * 3.14 / 180,
    P01Pu = -4.94531238, Q01Pu = 0.56713991,
    U02Pu = 1.04289359,  UPhase02 = 6.668423 * 3.14 / 180,
    P02Pu = 5,            Q02Pu = 0.21) annotation(
    Placement(transformation(origin = {28, 20}, extent = {{-10, -10}, {10, 10}})));

  // ═══════════════════════════════════════════════════════════════
  // dynLine2 (bus -> infiniteBus)
  // Copiata da Zgrid1, ORIENTAMENTO INVERTITO rispetto a Zgrid1:
  // Zgrid1.terminal1->infiniteBus, terminal2->Bus  ==
  // dynLine2.terminal1->bus, terminal2->infiniteBus => scambiati 1<->2
  // ═══════════════════════════════════════════════════════════════
  DynLine dynLine2(
    RPu = 0.003, LPu = 0.03,
    U01Pu = 1.03733331, UPhase01 = -2.278818 * 3.14 / 180,
    P01Pu = -0.11194076, Q01Pu = -1.17073708,
    U02Pu = 1.1,          UPhase02 = -0.04,
    P02Pu = 0.11901040,   Q02Pu = 1.24143346) annotation(
    Placement(transformation(origin = {-4, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // ═══════════════════════════════════════════════════════════════
  // dynLine3 (ramo parallelo, commutato da idealSwitch)
  // Copiata da Zgrid2, STESSO orientamento di Zgrid2
  // (terminal1 lato infiniteBus, terminal2 lato bus/switch)
  // ═══════════════════════════════════════════════════════════════
  DynLine dynLine3(
    RPu = 0.00388, LPu = 0.0388,
    U01Pu = 1.1,          UPhase01 = -0.04,
    P01Pu = 0.11901040,   Q01Pu = 1.24143346,
    U02Pu = 1.03733331,   UPhase02 = -2.278818 * 3.14 / 180,
    P02Pu = -0.11194076,  Q02Pu = -1.17073708) annotation(
    Placement(transformation(origin = {-52, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  IdealSwitch idealSwitch annotation(
    Placement(transformation(origin = {-30, -16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanTable booleanTable(table = {0, 51.5}, startValue = true)  annotation(
    Placement(transformation(origin = {42, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  dynLine.switchOffSignal1 = false;
  dynLine.switchOffSignal2 = false;
  dynLine1.switchOffSignal1 = false;
  dynLine1.switchOffSignal2 = false;
  dynLine2.switchOffSignal1 = false;
  dynLine2.switchOffSignal2 = false;
  dynLine3.switchOffSignal1 = if time >= 51.5 then false else false;
  dynLine3.switchOffSignal2 = false;
  gFLmodel.switchOffSignal1 = false;
  gFLmodel.switchOffSignal2 = false;
  gFLmodel.switchOffSignal3= false;
  gFLmodel1.switchOffSignal1= false;
  gFLmodel1.switchOffSignal2 = false;
  gFLmodel1.switchOffSignal3 = false;
  dynLine.omegaPu = 1;
  dynLine1.omegaPu = 1;
  dynLine2.omegaPu = 1;
  dynLine3.omegaPu = 1;
  connect(omegaRefPu.y, gFLmodel.omegaRefPu) annotation(
    Line(points = {{-119, -38}, {-119, 4}, {-104, 4}}, color = {0, 0, 127}));
  connect(step.y, gFLmodel.PRefPu) annotation(
    Line(points = {{-151, 68}, {-151, 30}, {-104, 30}}, color = {0, 0, 127}));
  connect(step1.y, gFLmodel.UREfPu) annotation(
    Line(points = {{-167, 16}, {-104, 16}}, color = {0, 0, 127}));
  connect(omegaRefPu1.y, gFLmodel1.omegaRefPu) annotation(
    Line(points = {{121, 84}, {121, 36}, {104, 36}}, color = {0, 0, 127}));
  connect(UrefPu1.y, gFLmodel1.UREfPu) annotation(
    Line(points = {{141, 34}, {120.5, 34}, {120.5, 24}, {104, 24}}, color = {0, 0, 127}));
  connect(step2.y, gFLmodel1.PRefPu) annotation(
    Line(points = {{141, -56}, {141, 10}, {104, 10}}, color = {0, 0, 127}));
  connect(gFLmodel.terminalPcc, dynLine.terminal1) annotation(
    Line(points = {{-64, 20}, {-50, 20}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, bus.terminal) annotation(
    Line(points = {{-30, 20}, {-4, 20}}, color = {0, 0, 255}));
  connect(bus.terminal, dynLine1.terminal1) annotation(
    Line(points = {{-4, 20}, {18, 20}}, color = {0, 0, 255}));
  connect(dynLine1.terminal2, gFLmodel1.terminalPcc) annotation(
    Line(points = {{38, 20}, {64, 20}}, color = {0, 0, 255}));
  connect(dynLine2.terminal1, bus.terminal) annotation(
    Line(points = {{-4, -22}, {-4, 20}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, dynLine2.terminal2) annotation(
    Line(points = {{-4, -74}, {-4, -42}}, color = {0, 0, 255}));
  connect(dynLine3.terminal1, dynLine2.terminal2) annotation(
    Line(points = {{-52, -42}, {-4, -42}}, color = {0, 0, 255}));
  connect(dynLine3.terminal2, idealSwitch.terminal1) annotation(
    Line(points = {{-52, -22}, {-40, -22}, {-40, -12}}, color = {0, 0, 255}));
  connect(idealSwitch.terminal2, dynLine2.terminal1) annotation(
    Line(points = {{-20, -12}, {-20, -22}, {-4, -22}}, color = {0, 0, 255}));
  connect(idealSwitch.control, booleanTable.y) annotation(
    Line(points = {{-30, -4}, {-2.5, -4}, {-2.5, -14}, {31, -14}}, color = {255, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 70, Tolerance = 1e-5, Interval = 0.0005),
    preferredView = "diagram",
  Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}));

end TwoConvertersDynamicLine;
