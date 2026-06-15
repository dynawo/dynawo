within Dynawo.Electrical.PEIR.Plants.Average;

model TwoConvertersStaticLine

  // ═══════════════════════════════════════════════════════════════
  // Frequenze di taglio target — modifica solo questi
  // ═══════════════════════════════════════════════════════════════
  parameter Real OmegaCC          = 1200;  // inner current loop  [rad/s]
  parameter Real w_cc_outer       = 10;    // outer P/Q loop      [rad/s]
  parameter Real w_cc_plant       = 2;     // plant controller    [rad/s]
  parameter Real OmegaPLL         = 100;    // PLL                 [rad/s]
  parameter Real KsiPLL           = 1.0;   // PLL
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
  final parameter Real ki_plant_1 = kp_plant_1 * w_cc_plant;

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
  final parameter Real ki_plant_2 = kp_plant_2 * w_cc_plant;

  // ═══════════════════════════════════════════════════════════════
  // GFL1
  // ═══════════════════════════════════════════════════════════════
  GFLmodel gFLmodel(
    SNom = 1000, U0Pu = 1.091230, Uphase = 0.063246,
    P0_pcc = -5.010676, Q0_pcc = -0.21, Omega0Pu = 1.0,
    tVSC = 1e-3,
    RfPu = 0.003, LfPu = 0.1, CfPu = 1e-5,
    omegaNom = 2 * Modelica.Constants.pi * 50,
    RPuLV = 0.001, LPuLV = 0.025,
    RPuHV = 0.001, LPuHV = 0.025,
    k_filter = 1, T_filter = T_filter,
    k_p_d_current = kp_cc_1, k_i_d_current = ki_cc_1,
    k_p_q_current = kp_cc_1, k_i_q_current = ki_cc_1,
    k_p_d_outer = kp_outer_1, k_i_d_outer = ki_outer_1,
    k_p_q_outer = kp_outer_1, k_i_q_outer = ki_outer_1,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 0,
    Imax = 2, PQFlag = false,
    IqBoostMax = 0.5, IqBoostMin = -0.5,
    K_p_q_plant = kp_plant_1, K_i_q_plant = ki_plant_1,
    K_p_p_plant = kp_plant_1, K_i_p_plant = ki_plant_1,
    Lambda = 0.417, Kdroop = 15,
    QMaxPu = 0.3, QMinPu = -0.3,
    PMaxPu = 2,   PMinPu = 0,
    FEMaxPu = 999, FEMinPu = -999,
    FDbd1Pu = 0.005, FDbd2Pu = 0.1,
    DbdPu = 0.0001,
    K_p_pll = kp_pll_1, K_i_pll = ki_pll_1,
    OmegaMaxPu = 1.1, OmegaMinPu = 0.9,
    DyMax_pi_d = 10000.0, DyMax_pi_q = 100000.0,
    DuMax_idref = 10.0,   DuMin_idref = -10.0,
    tS_idref = 1e-4,
    delay_time_plant = delay_time_plant,
    voltagefeedforwardflag = 1
  ) annotation(
    Placement(transformation(origin = {-80, 16}, extent = {{-20, -20}, {20, 20}})));

  // ═══════════════════════════════════════════════════════════════
  // GFL2
  // ═══════════════════════════════════════════════════════════════
  GFLmodel gFLmodel1(
    SNom = 1000, U0Pu = 1.086638, Uphase = -0.063421,
    P0_pcc = 4.989324, Q0_pcc = -0.21, Omega0Pu = 1.0,
    tVSC = 1e-3,
    RfPu = 0.003, LfPu = 0.1, CfPu = 1e-5,
    omegaNom = 2 * Modelica.Constants.pi * 50,
    RPuLV = 0.001, LPuLV = 0.025,
    RPuHV = 0.001, LPuHV = 0.025,
    k_filter = 1, T_filter = T_filter,
    k_p_d_current = kp_cc_2, k_i_d_current = ki_cc_2,
    k_p_q_current = kp_cc_2, k_i_q_current = ki_cc_2,
    k_p_d_outer = kp_outer_2, k_i_d_outer = ki_outer_2,
    k_p_q_outer = kp_outer_2, k_i_q_outer = ki_outer_2,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 0,
    Imax = 2, PQFlag = false,
    IqBoostMax = 0.5, IqBoostMin = -0.5,
    K_p_q_plant = kp_plant_2, K_i_q_plant = ki_plant_2,
    K_p_p_plant = kp_plant_2, K_i_p_plant = ki_plant_2,
    Lambda = 0.417, Kdroop = 15,
    QMaxPu = 0.3, QMinPu = -0.3,
    PMaxPu = 0,   PMinPu = -2,
    FEMaxPu = 999, FEMinPu = -999,
    FDbd1Pu = 0.005, FDbd2Pu = 0.1,
    DbdPu = 0.0001,
    K_p_pll = kp_pll_2, K_i_pll = ki_pll_2,
    OmegaMaxPu = 1.1, OmegaMinPu = 0.9,
    DyMax_pi_d = 10000.0, DyMax_pi_q = 100000.0,
    DuMax_idref = 100000.0, DuMin_idref = -10000.0,
    tS_idref = 1e-4,
    delay_time_plant = delay_time_plant,
    voltagefeedforwardflag = 1
  ) annotation(
    Placement(transformation(origin = {80, 24}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // ═══════════════════════════════════════════════════════════════
  // Rete
  // ═══════════════════════════════════════════════════════════════
  Lines.Line line(RPu = 0.00144, XPu = 0.0144, BPu = 0, GPu = 0) annotation(
    Placement(transformation(origin = {-34, 20}, extent = {{-10, -10}, {10, 10}})));
  Lines.Line line1(RPu = 0.00144, XPu = 0.0144, BPu = 0, GPu = 0) annotation(
    Placement(transformation(origin = {26, 20}, extent = {{-10, -10}, {10, 10}})));
  Lines.Line line2(RPu = 0.01, XPu = 0.1, BPu = 0, GPu = 0) annotation(
    Placement(transformation(origin = {-4, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Lines.Line line3(RPu = 0.0077775, XPu = 0.077775, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
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
  Modelica.Blocks.Sources.Step step(offset = 0.5, height = 0.1, startTime = 50) annotation(
    Placement(transformation(origin = {-162, 68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(height = 0.1*URef0Pu, offset = URef0Pu, startTime = 480) annotation(
    Placement(transformation(origin = {-178, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step2(height = 0.1, offset = -0.5, startTime = 50) annotation(
    Placement(transformation(origin = {130, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant UrefPu1(k = URef0Pu1) annotation(
    Placement(transformation(origin = {152, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  final parameter Real URef0Pu  = gFLmodel.U0Pu  - gFLmodel.Lambda  * gFLmodel.Q0_pcc  * SystemBase.SnRef / gFLmodel.SNom;
  final parameter Real URef0Pu1 = gFLmodel1.U0Pu - gFLmodel1.Lambda * gFLmodel1.Q0_pcc * SystemBase.SnRef / gFLmodel1.SNom;

equation
  line.switchOffSignal1.value  = false;
  line.switchOffSignal2.value  = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = if time >= 51.5 then true else false;
  line3.switchOffSignal2.value = false;
  gFLmodel.switchOffSignal1.value  = false;
  gFLmodel.switchOffSignal2.value  = false;
  gFLmodel.switchOffSignal3.value  = false;
  gFLmodel1.switchOffSignal1.value = false;
  gFLmodel1.switchOffSignal2.value = false;
  gFLmodel1.switchOffSignal3.value = false;

  connect(gFLmodel.terminalPcc,  line.terminal1) annotation(
    Line(points = {{-64, 19}, {-64, 20}, {-44, 20}}, color = {0, 0, 255}));
  connect(line.terminal2,        bus.terminal) annotation(
    Line(points = {{-24, 20}, {-4, 20}}, color = {0, 0, 255}));
  connect(bus.terminal,          line1.terminal1) annotation(
    Line(points = {{-4, 20}, {16, 20}}, color = {0, 0, 255}));
  connect(line1.terminal2,       gFLmodel1.terminalPcc) annotation(
    Line(points = {{36, 20}, {64, 21}}, color = {0, 0, 255}));
  connect(bus.terminal,          line2.terminal1) annotation(
    Line(points = {{-4, 20}, {-4, -18}}, color = {0, 0, 255}));
  connect(line2.terminal2,       infiniteBusWithVariations.terminal) annotation(
    Line(points = {{-4, -38}, {-4, -74}}, color = {0, 0, 255}));
  connect(line3.terminal1,       line2.terminal1) annotation(
    Line(points = {{-40, -20}, {-4, -20}, {-4, -18}}, color = {0, 0, 255}));
  connect(line3.terminal2,       line2.terminal2) annotation(
    Line(points = {{-40, -40}, {-4, -40}, {-4, -38}}, color = {0, 0, 255}));
  connect(omegaRefPu.y,  gFLmodel.omegaRefPu) annotation(
    Line(points = {{-119, -38}, {-119, 4}, {-104, 4}}, color = {0, 0, 127}));
  connect(step.y,        gFLmodel.PRefPu) annotation(
    Line(points = {{-151, 68}, {-151, 30}, {-104, 30}}, color = {0, 0, 127}));
  connect(step1.y,       gFLmodel.UREfPu) annotation(
    Line(points = {{-167, 16}, {-104, 16}}, color = {0, 0, 127}));
  connect(omegaRefPu1.y, gFLmodel1.omegaRefPu) annotation(
    Line(points = {{121, 84}, {121, 36}, {104, 36}}, color = {0, 0, 127}));
  connect(UrefPu1.y,     gFLmodel1.UREfPu) annotation(
    Line(points = {{141, 34}, {120.5, 34}, {120.5, 24}, {104, 24}}, color = {0, 0, 127}));
  connect(step2.y,       gFLmodel1.PRefPu) annotation(
    Line(points = {{141, -56}, {141, 10}, {104, 10}}, color = {0, 0, 127}));

  annotation(
    experiment(StartTime = 0, StopTime = 70, Tolerance = 1e-5, Interval = 0.0005),
    preferredView = "diagram");

end TwoConvertersStaticLine;