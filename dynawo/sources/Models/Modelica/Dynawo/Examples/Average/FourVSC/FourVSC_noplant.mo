within Dynawo.Examples.Average.FourVSC;

model FourVSC_noplant

/*
 * After the fault, oscillations at approximately 20 Hz appear, consistently
 * with the oscillatory behavior observed in EMTP and reported in Gaia
 * Bergamaschi's thesis. These oscillations are damped over time.
 * The limit on Qinjref is reached
 *
 */


  // ═══════════════════════════════════════════════════════════════
  // HVDC1 converter - Bus A - SNom = 1200 MVA
  // Electrically closest converter to the fault at Bus A: this is the
  // unit expected to reach its current limiter (Imax = 1.1 pu) first
  // and most severely during the disturbance.
  // ═══════════════════════════════════════════════════════════════


    Dynawo.Electrical.PEIR.Converters.Average.GFLmodel_noplant gFL_HVDC1(
    SNom = 1200, U0Pu = 1.016485, Uphase = 0.210724, P0_pcc = -11.445, Q0_pcc = 0.536945,
    Omega0Pu = 1.0, tVSC = 1e-3,
    RfPu = 0.005, LfPu = 0.15, CfPu = 1e-9, omegaNom = 2*Modelica.Constants.pi*50,
    RPuLV = 1e-5, LPuLV = 1e-5, RPuHV = 1e-5, LPuHV = 1e-5,
    k_filter = 1, T_filter = 0.0033,
    k_p_d_current = 0.5730, k_i_d_current = 6,
    k_p_q_current = 0.5730, k_i_q_current = 6,
    k_p_d_outer = 0.0333, k_i_d_outer = 10,
    k_p_q_outer = 0.1667, k_i_q_outer = 50,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 0,
    Imax = 1.1, PQFlag = false, IqBoostMax = 2, IqBoostMin = -2,
    K_p_pll = 0.31831, K_i_pll = 7.95775, OmegaMaxPu = 1.5, OmegaMinPu = 0.5,
    DyMax_pi_d = 5, DyMax_pi_q = 5, DuMax_idref = 0.5, DuMin_idref = -999,
    tS_idref = 1e-4,
    voltagefeedforwardflag_d = 1, voltagefeedforwardflag_q = 0, T_boost = 1e-3)
    annotation(Placement(transformation(origin = {-222, 102}, extent = {{-20, -20}, {20, 20}})));

  // ═══════════════════════════════════════════════════════════════
  // HVDC2 converter - Bus B - SNom = 1700 MVA
  // Electrically farther from the fault (via lines AB1/AB2, or the
  // longer AC/BC paths); expected to see a shallower voltage dip and
  // correspondingly less (or no) current-limiter engagement than
  // gFL_HVDC1.
  // ═══════════════════════════════════════════════════════════════
   Dynawo.Electrical.PEIR.Converters.Average.GFLmodel_noplant gFL_HVDC2(
    SNom = 1700, U0Pu = 1.018446, Uphase = 0.216682, P0_pcc =  -13.94108, Q0_pcc = -5.04,
    Omega0Pu = 1.0, tVSC = 1e-3,
    RfPu = 0.005, LfPu = 0.15, CfPu = 1e-9, omegaNom = 2*Modelica.Constants.pi*50,
    RPuLV = 1e-5, LPuLV = 1e-5, RPuHV = 1e-5, LPuHV = 1e-5,
    k_filter = 1, T_filter = 0.0033,
    k_p_d_current = 0.5730, k_i_d_current = 6,
    k_p_q_current = 0.5730, k_i_q_current = 6,
    k_p_d_outer = 0.1667, k_i_d_outer = 50,
    k_p_q_outer = 0.1667, k_i_q_outer = 50,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 0,
    Imax = 1.1, PQFlag = false, IqBoostMax = 2, IqBoostMin = -2,
    K_p_pll = 0.31831, K_i_pll = 7.95775, OmegaMaxPu = 1.5, OmegaMinPu = 0.5,
    DyMax_pi_d = 5, DyMax_pi_q = 5, DuMax_idref = 0.5, DuMin_idref = -999,
    tS_idref = 1e-4,
    voltagefeedforwardflag_d = 1, voltagefeedforwardflag_q = 0, T_boost = 1e-3)
    annotation(Placement(transformation(origin = {198, 102}, extent = {{20, -20}, {-20, 20}})));

  // ═══════════════════════════════════════════════════════════════
  // WP1 converter (wind park) - Bus E - SNom = 2400 MVA
  // Connected radially through Bus A2/lineA2E, one transformer removed
  // from the faulted Bus A: sees an attenuated but still significant
  // voltage dip during the fault.
  // ═══════════════════════════════════════════════════════════════
   Dynawo.Electrical.PEIR.Converters.Average.GFLmodel_noplant gFL_WP1(
    SNom = 2400, U0Pu =  1.06870, Uphase = 0.352335, P0_pcc = -19.916, Q0_pcc = 1.594,
    Omega0Pu = 1.0, tVSC = 1e-3,
    RfPu = 0.005, LfPu = 0.12, CfPu = 1e-9, omegaNom = 2*Modelica.Constants.pi*50,
    RPuLV = 1e-5, LPuLV = 1e-5, RPuHV = 1e-5, LPuHV = 1e-5,
    k_filter = 1, T_filter = 0.0333,
    k_p_d_current = 0.4584, k_i_d_current = 6,
    k_p_q_current = 0.4584, k_i_q_current = 6,
    k_p_d_outer = 0.0333, k_i_d_outer = 10,
    k_p_q_outer = 0.033, k_i_q_outer = 10,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 0,
    Imax = 1, PQFlag = false, IqBoostMax = 2, IqBoostMin = -2,
    K_p_pll = 0.31831, K_i_pll = 7.95775, OmegaMaxPu = 1.5, OmegaMinPu = 0.5,
    DyMax_pi_d = 5, DyMax_pi_q = 5, DuMax_idref = 0.5, DuMin_idref = -999,
    tS_idref = 1e-4,
    voltagefeedforwardflag_d = 1, voltagefeedforwardflag_q = 0, T_boost = 1e-3)
    annotation(Placement(transformation(origin = {-236, -154}, extent = {{-20, -20}, {20, 20}})));

  // ═══════════════════════════════════════════════════════════════
  // WP2 converter (wind park) - Bus F - SNom = 2400 MVA
  // Symmetric counterpart of WP1 on the Bus B side of the network;
  // farthest electrically from the fault at Bus A and therefore the
  // least perturbed converter, useful as a "quiet" reference trace
  // when checking that only the current limiter (not an oscillatory
  // instability) explains the transients seen elsewhere.
  // ═══════════════════════════════════════════════════════════════
   Dynawo.Electrical.PEIR.Converters.Average.GFLmodel_noplant gFL_WP2(
    SNom = 2400, U0Pu = 1.037386, Uphase = 0.366498, P0_pcc = -19.917, Q0_pcc = 7.368258,
    Omega0Pu = 1.0, tVSC = 1e-3,
    RfPu = 0.005, LfPu = 0.12, CfPu = 1e-9, omegaNom = 2*Modelica.Constants.pi*50,
    RPuLV = 1e-5, LPuLV = 1e-5, RPuHV = 1e-5, LPuHV = 1e-5,
    k_filter = 1, T_filter = 0.0033,
    k_p_d_current = 0.4584, k_i_d_current = 6,
    k_p_q_current = 0.4584, k_i_q_current = 6,
    k_p_d_outer = 0.0333, k_i_d_outer = 10,
    k_p_q_outer = 0.1667, k_i_q_outer = 50,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 0,
    Imax = 1.1, PQFlag = false, IqBoostMax = 2, IqBoostMin = -2,
    K_p_pll = 0.31831, K_i_pll = 7.95775, OmegaMaxPu = 1.5, OmegaMinPu = 0.5,
    DyMax_pi_d = 5, DyMax_pi_q = 5, DuMax_idref = 0.5, DuMin_idref = -999,
    tS_idref = 1e-4,
    voltagefeedforwardflag_d = 1, voltagefeedforwardflag_q = 0, T_boost = 1e-3)
    annotation(Placement(transformation(origin = {230, -146}, extent = {{20, -20}, {-20, 20}})));
  // ═══════════════════════════════════════════════════════════════
  // Lines (per-unit impedances, base SnRef=100MVA)
  //   Zbase400 = 400^2/100 = 1600 ohm ; Zbase225 = 225^2/100 = 506.25 ohm
  //   BPu here = (b1+b2)*Zbase, i.e. the total line susceptance (the
  //    Dynawo.Electrical.Lines.Line block splits it internally between the two ends)
  // ═══════════════════════════════════════════════════════════════
// A-B (Line1/Line2 nel dump, valori identici sui due circuiti paralleli)
 Dynawo.Electrical.Lines.Line lineAB1(RPu = 0.00031875, XPu = 0.0064, BPu = 0.1536/2, GPu = 0)
    annotation(Placement(transformation(origin = {0, 82}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Lines.Line lineAB2(RPu = 0.00031875, XPu = 0.0064, BPu = 0.1536/2, GPu = 0)
    annotation(Placement(transformation(origin = {2, 30}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Lines.Line lineAC1(RPu = 0.00065, XPu = 0.013, BPu = 0.3136/2, GPu = 0)
    annotation(Placement(transformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Lines.Line lineAC2(RPu = 0.00065, XPu = 0.013, BPu = 0.3136/2, GPu = 0)
    annotation(Placement(transformation(origin = {-140, -60}, extent = {{-10, -10}, {10, 10}})));

// B-C (Line5/Line6)
 Dynawo.Electrical.Lines.DynLine_pi lineBC1(
    RPu = 0.0007, XPu = 0.014, BPu = 0.336/2, GPu = 0,
    U01Pu = 1.01845, UPhase01 = 0.21668, P01Pu = 15.75887,  Q01Pu = 2.04163,
    U02Pu = 1.00055, UPhase02 = 0.00000, P02Pu = -15.58796, Q02Pu = 1.03420)
    annotation(Placement(transformation(origin = {100, -30}, extent = {{10, -10}, {-10, 10}})));

 Dynawo.Electrical.Lines.DynLine_pi lineBC2(
    RPu = 0.0007, XPu = 0.014, BPu = 0.336/2, GPu = 0,
    U01Pu = 1.01845, UPhase01 = 0.21668, P01Pu = 15.75887,  Q01Pu = 2.04163,
    U02Pu = 1.00055, UPhase02 = 0.00000, P02Pu = -15.58796, Q02Pu = 1.03420)
    annotation(Placement(transformation(origin = {140, -60}, extent = {{10, -10}, {-10, 10}})));

 // A2-E (Line7)
  Dynawo.Electrical.Lines.DynLine_pi lineA2E(    RPu = 0.00082963, XPu = 0.0016395, BPu = 9.1125/2, GPu = 0,    U01Pu = 1.05091, UPhase01 = 0.32458, P01Pu = -19.62557, Q01Pu = -6.24039,    U02Pu = 1.06870, UPhase02 = 0.35234, P02Pu = 19.91600,  Q02Pu = -3.42139)    annotation(Placement(transformation(origin = {-220, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

// B2-F (Line8)
 Dynawo.Electrical.Lines.DynLine_pi lineB2F(
    RPu = 0.00082963, XPu = 0.0016395, BPu = 9.1125/2, GPu = 0,
    U01Pu = 1.02590, UPhase01 = 0.33389, P01Pu = -19.60662, Q01Pu = -1.71674,
    U02Pu = 1.03739, UPhase02 = 0.36650, P02Pu = 19.91712,  Q02Pu = -7.36826)
    annotation(Placement(transformation(origin = {220, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // ═══════════════════════════════════════════════════════════════
  // Network buses
  // ═══════════════════════════════════════════════════════════════
   Dynawo.Electrical.Buses.Bus busA  annotation(Placement(transformation(origin = {-180, 60}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Buses.Bus busB  annotation(Placement(transformation(origin = {180, 60}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Buses.Bus busC  annotation(Placement(transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Buses.Bus busA2 annotation(Placement(transformation(origin = {-220, -20}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Buses.Bus busB2 annotation(Placement(transformation(origin = {220, -20}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Buses.Bus busE  annotation(Placement(transformation(origin = {-220, -100}, extent = {{-10, -10}, {10, 10}})));
   Dynawo.Electrical.Buses.Bus busF  annotation(Placement(transformation(origin = {220, -100}, extent = {{-10, -10}, {10, 10}})));

  // ═══════════════════════════════════════════════════════════════
  // Infinite bus at Bus C (represents the slack load "_LOAD__1" /
  // InfiniteBusWithImpedance from the .dyd/.par files). U0Pu, UPhase
  // taken from the "InfBusWithImpedance" set; no voltage/frequency event.
  // ═══════════════════════════════════════════════════════════════
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(
    U0Pu = 1.00055, UPhase = 0.0, omega0Pu = 1.0,
    UEvtPu = 1.00055, tUEvtStart = 1e6, tUEvtEnd = 1e6,
    omegaEvtPu = 1.0, tOmegaEvtStart = 1e6, tOmegaEvtEnd = 1e6)
    annotation(Placement(transformation(origin = {0, -140}, extent = {{-10, -10}, {10, 10}})));
  // Series impedance of the infinite bus (RPu=0, XPu=0.005 from the .par file)
   Dynawo.Electrical.Lines.Line lineInfBus(RPu = 0, XPu = 0.005, BPu = 0, GPu = 0)
    annotation(Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Common frequency reference (PLL) shared by all converters
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1.0) annotation(Placement(transformation(origin = {-6, 166}, extent = {{-10, -10}, {10, 10}})));

  // ═══════════════════════════════════════════════════════════════
  // Three-phase fault at Bus A (set "Fault" from the .par file:
  // tBegin=5, tEnd=5.1, RPu=0, XPu=0.01)
  // ═══════════════════════════════════════════════════════════════


   Dynawo.Electrical.Events.NodeFault fault(
    tBegin = 5, tEnd = 5.1, RPu = 0, XPu = 0)
    annotation(Placement(transformation(origin = {-180, 126}, extent = {{-10, -10}, {10, 10}})));

 // ═══════════════════════════════════════════════════════════════
  // Shunts (approximated as constant Q injection - see TODO)
  // Bus C: bPerSection=0.0025 -> BPu=0.0025*1600=4.0 pu (capacitive)
  // Bus E: bPerSection=-0.0031604939999999998 -> BPu=-1.6 pu (inductive)
  // ═══════════════════════════════════════════════════════════════
  Dynawo.Electrical.Shunts.ShuntB ShuntE( BPu = 1.6,
    u0Pu = Complex(1.003047, 0.368799),
    s0Pu = Complex(0.0, 1.827385),
    i0Pu = Complex(0.590079, -1.604875)) annotation(
    Placement(transformation(origin = {-194, -114}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Shunts.ShuntB ShuntC(
    BPu = -4.0,u0Pu = Complex(1.000550, 0.0),
    s0Pu = Complex(0.0, -4.004401),
    i0Pu = Complex(0.0, 4.002200)) annotation(
    Placement(transformation(origin = {48, -80}, extent = {{-10, -10}, {10, 10}})));

  // Transformers A2-A and B2-B: 1:1 ratio in per unit (ratedU matches the
  // nominal voltages of the buses) -> modeled as equivalent impedance
   Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafoA2A(RPu = 0.0002083, XPu = 0.00625, GPu = 0, BPu = 0, rTfoPu = 1.02)  annotation(
    Placement(transformation(origin = {-220, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio trafoB2B (BPu = 0, GPu = 0, RPu = 0.0002083, XPu = 0.00625, rTfoPu = 1.05) annotation(
    Placement(transformation(origin = {220, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
// All lines always in service (no opening event)
  lineAB1.switchOffSignal1 = false;
  lineAB1.switchOffSignal2 = false;
  lineAB2.switchOffSignal1 = false;
  lineAB2.switchOffSignal2 = false;
  lineAC1.switchOffSignal1 = false;
  lineAC1.switchOffSignal2 = false;
  lineAC2.switchOffSignal1 = false;
  lineAC2.switchOffSignal2 = false;
  lineBC1.switchOffSignal1 = false;
  lineBC1.switchOffSignal2 = false;
  lineBC2.switchOffSignal1 = false;
  lineBC2.switchOffSignal2 = false;
  lineA2E.switchOffSignal1 = false;
  lineA2E.switchOffSignal2 = false;
  lineB2F.switchOffSignal1 = false;
  lineB2F.switchOffSignal2 = false;
  lineInfBus.switchOffSignal1 = false;
  lineInfBus.switchOffSignal2 = false;

  lineBC1.omegaPu = 1;
  lineBC2.omegaPu = 1;
  lineA2E.omegaPu = 1;
  lineB2F.omegaPu = 1;
// Converters always connected
  gFL_HVDC1.switchOffSignal1 = false;
  gFL_HVDC1.switchOffSignal2 = false;
  gFL_HVDC1.switchOffSignal3 = false;
  gFL_HVDC2.switchOffSignal1 = false;
  gFL_HVDC2.switchOffSignal2 = false;
  gFL_HVDC2.switchOffSignal3 = false;
  gFL_WP1.switchOffSignal1 = false;
  gFL_WP1.switchOffSignal2 = false;
  gFL_WP1.switchOffSignal3 = false;
  gFL_WP2.switchOffSignal1 = false;
  gFL_WP2.switchOffSignal2 = false;
  gFL_WP2.switchOffSignal3 = false;

// Shunts switch off
  ShuntC.switchOffSignal1 = false;
  ShuntC.switchOffSignal2 = false;
  ShuntE.switchOffSignal1 = false;
  ShuntE.switchOffSignal2 = false;
//Trafo switch off
 trafoA2A.switchOffSignal1 = false;
 trafoA2A.switchOffSignal2 = false;
 trafoB2B.switchOffSignal1 = false;
 trafoB2B.switchOffSignal2 = false;
// ═══════════════════════════════════════════════════════════════
// Electrical connections - mirror the IIDM topology
// ═══════════════════════════════════════════════════════════════
  connect(gFL_HVDC1.terminalPcc, busA.terminal) annotation(
    Line(points = {{-206, 105}, {-206, 109.5}, {-180, 109.5}, {-180, 60}}, color = {0, 0, 255}));
  connect(gFL_HVDC2.terminalPcc, busB.terminal) annotation(
    Line(points = {{182, 105}, {182, 60}, {180, 60}}, color = {0, 0, 255}));
  connect(gFL_WP1.terminalPcc, busE.terminal) annotation(
    Line(points = {{-220, -151}, {-220, -100}}, color = {0, 0, 255}));
  connect(gFL_WP2.terminalPcc, busF.terminal) annotation(
    Line(points = {{214, -143}, {214, -120.5}, {220, -120.5}, {220, -100}}, color = {0, 0, 255}));
  connect(busA.terminal, lineAB1.terminal1) annotation(
    Line(points = {{-180, 60}, {-140, 60}, {-140, 82}, {-10, 82}}, color = {0, 0, 255}));
  connect(lineAB1.terminal2, busB.terminal) annotation(
    Line(points = {{10, 82}, {140, 82}, {140, 60}, {180, 60}}, color = {0, 0, 255}));
  connect(busA.terminal, lineAB2.terminal1) annotation(
    Line(points = {{-180, 60}, {-110, 60}, {-110, 30}, {-8, 30}}, color = {0, 0, 255}));
  connect(lineAB2.terminal2, busB.terminal) annotation(
    Line(points = {{12, 30}, {110, 30}, {110, 60}, {180, 60}}, color = {0, 0, 255}));
  connect(busA.terminal, lineAC2.terminal1) annotation(
    Line(points = {{-180, 60}, {-160, 60}, {-160, -60}, {-150, -60}}, color = {0, 0, 255}));
  connect(lineAC2.terminal2, busC.terminal) annotation(
    Line(points = {{-130, -60}, {0, -60}}, color = {0, 0, 255}));
  connect(busA.terminal, lineAC1.terminal1) annotation(
    Line(points = {{-180, 60}, {-110, 60}, {-110, -30}}, color = {0, 0, 255}));
  connect(lineAC1.terminal2, busC.terminal) annotation(
    Line(points = {{-90, -30}, {0, -30}, {0, -60}}, color = {0, 0, 255}));
  connect(busB.terminal, lineBC2.terminal1) annotation(
    Line(points = {{180, 60}, {160, 60}, {160, -60}, {150, -60}}, color = {0, 0, 255}));
  connect(lineBC2.terminal2, busC.terminal) annotation(
    Line(points = {{130, -60}, {0, -60}}, color = {0, 0, 255}));
  connect(busB.terminal, lineBC1.terminal1) annotation(
    Line(points = {{180, 60}, {110, 60}, {110, -30}}, color = {0, 0, 255}));
  connect(lineBC1.terminal2, busC.terminal) annotation(
    Line(points = {{90, -30}, {0, -30}, {0, -60}}, color = {0, 0, 255}));
  connect(busA2.terminal, lineA2E.terminal1) annotation(
    Line(points = {{-220, -20}, {-220, -30}}, color = {0, 0, 255}));
  connect(lineA2E.terminal2, busE.terminal) annotation(
    Line(points = {{-220, -50}, {-220, -100}}, color = {0, 0, 255}));
  connect(busB2.terminal, lineB2F.terminal1) annotation(
    Line(points = {{220, -20}, {220, -30}}, color = {0, 0, 255}));
  connect(lineB2F.terminal2, busF.terminal) annotation(
    Line(points = {{220, -50}, {220, -100}}, color = {0, 0, 255}));
  connect(busC.terminal, lineInfBus.terminal1) annotation(
    Line(points = {{0, -60}, {0, -90}}, color = {0, 0, 255}));
  connect(lineInfBus.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{0, -110}, {0, -140}}, color = {0, 0, 255}));
// Three-phase fault at Bus A
  connect(busA.terminal, fault.terminal) annotation(
    Line(points = {{-180, 60}, {-180, 126}}, color = {0, 0, 255}));
// Common frequency reference to all converters
  connect(omegaRefPu.y, gFL_HVDC1.omegaRefPu) annotation(
    Line(points = {{5, 166}, {-260.562, 166}, {-260.562, 90}, {-246, 90}}, color = {198, 70, 0}, thickness = 0.75));
  connect(omegaRefPu.y, gFL_HVDC2.omegaRefPu) annotation(
    Line(points = {{5, 166}, {222, 166}, {222, 90}}, color = {198, 70, 0}, thickness = 0.75));
  connect(omegaRefPu.y, gFL_WP1.omegaRefPu) annotation(
    Line(points = {{5, 166}, {-286, 166}, {-286, -165.5}, {-260, -165.5}, {-260, -166}}, color = {230, 97, 0}, thickness = 0.75));
  connect(omegaRefPu.y, gFL_WP2.omegaRefPu) annotation(
    Line(points = {{5, 166}, {254, 166}, {254, -158}}, color = {198, 70, 0}, thickness = 0.75));
// ═══════════════════════════════════════════════════════════════
// Setpoints (held constant at the initial load-flow value - use a
// Step/Ramp source instead if you want to reproduce specific
// transients)
// ═══════════════════════════════════════════════════════════════
  gFL_HVDC1.PRefPu = 0.95375;
  gFL_HVDC1.URefPu = 1.024319;
  gFL_HVDC2.PRefPu = 0.82006;
  gFL_HVDC2.URefPu = 1.072794;
  gFL_WP1.PRefPu = 0.82983;
  gFL_WP1.URefPu = 1.069218;
  gFL_WP2.PRefPu = 0.82988;
  gFL_WP2.URefPu =1.010584;
  connect(busE.terminal, ShuntE.terminal) annotation(
    Line(points = {{-220, -100}, {-194, -100}, {-194, -114}}, color = {0, 0, 255}));
  connect(ShuntC.terminal, busC.terminal) annotation(
    Line(points = {{48, -80}, {0, -80}, {0, -60}}, color = {0, 0, 255}));
  connect(busA2.terminal, trafoA2A.terminal1) annotation(
    Line(points = {{-220, -20}, {-220, 8}, {-220, 8}}, color = {0, 0, 255}));
  connect(busA.terminal, trafoA2A.terminal2) annotation(
    Line(points = {{-180, 60}, {-220, 60}, {-220, 28}}, color = {0, 0, 255}));
 connect(trafoB2B.terminal2, busB.terminal) annotation(
    Line(points = {{220, 28}, {180, 28}, {180, 60}}, color = {0, 0, 255}));
 connect(busB2.terminal, trafoB2B.terminal1) annotation(
    Line(points = {{220, -20}, {222, -20}, {222, 8}, {220, 8}}, color = {0, 0, 255}));
   annotation(
    experiment(StartTime = 0, StopTime = 7, Tolerance = 1e-5, Interval = 0.0005),
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -180}, {300, 180}})),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Documentation(info = "<html>
<p>
After the fault, oscillations at approximately 20 Hz appear, consistently
with the oscillatory behavior observed in EMTP and reported in Gaia
Bergamaschi's thesis. These oscillations are damped over time.
</p>
</html>"));


end FourVSC_noplant;
