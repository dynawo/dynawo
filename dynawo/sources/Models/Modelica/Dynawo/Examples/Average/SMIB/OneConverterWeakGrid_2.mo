within Dynawo.Examples.Average.SMIB;

model OneConverterWeakGrid_2
  final parameter Real U0Pu = 1.03713742957;
  final parameter Real Uphase = 0.203890124;
  final parameter Real URef0Pu = U0Pu - gFLmodelnodyn.LambdaPu*gFLmodelnodyn.Q0Pu*Electrical.SystemBase.SnRef/gFLmodelnodyn.SNom;

  Dynawo.Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFLmodelnodyn(
   // Initial conditions — PCC node
  SNom = 1000, U0Pu = U0Pu, UPhase0 = Uphase, P0Pu = -7, Q0Pu = -2, Omega0Pu = 1.0,
  // VSC Pade delay
  tVSC = 1e-5,
  // LC filter realistic values, fr ≈ 712 Hz
  RFilterPu = 0.00003,  // realistic conduction losses ~0.3 %
  LFilterPu = 0.01,  // 5 % filter reactance
  CFilterPu = 1e-5,  // 1 % filter susceptance  →  fr ≈ 712 Hz
  omegaNom = 2*Modelica.Constants.pi*50,
  // LV transformer (filter → LV node)
  RTransformerLVPu = 0.0005, LTransformerLVPu = 0.008,
  // HV transformer (LV node → PCC)
  RTransformerHVPu = 0.0002, LTransformerHVPu = 0.005,
  // Measurement filter
  KFilter = 1, tFilter = 1e-2,
  // Inner current loop — ω_c = 2000 rad/s
  Kpc = 100.0, Kic = 200000.0,
  // Outer loop — ω_c = 200 rad/s
  KpdOuter = 0.1, KidOuter = 20.0, KpqOuter = 0.01, KiqOuter = 20.0, PControlFlag = false, QControlFlag = false,
  // Current limiter
  UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 2, IMaxPu = 1.2, PQFlag = false, IqBoostMaxPu = 0.5, IqBoostMinPu = -0.5,
  // Plant controller — ω_c = 2 rad/s
  KpqPlant = 0.1, KiqPlant = 1.0, KppPlant = 0.8, KipPlant = 5.0, LambdaPu = 0.417, KDroop = 15, QMaxPu = 0.5, QMinPu = -0.5, PMaxPu = 2, PMinPu = 0, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001,
  // PLL — ω_c = 20 rad/s (weak-grid tuning)
  KpPLL = 0.32, KiPLL = 8, OmegaMaxPu = 1.5,
  // tight clamp — prevents runaway
  OmegaMinPu = 0.5,
  // Rate limiters and delays
  DidMax = 10.0, DidMin = -10.0, tSid = 1e-4, tPlant = 1e-3,
  // Voltage feedforward
  Kfd = 1, Kfq = 1, tBoost = 1e-3) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.7, startTime = 100) annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line(RPu = 0, XPu = 0.03, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(offset = URef0Pu, startTime = 100, height = URef0Pu*0.1) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 0.5, omega0Pu = 1, omegaEvtPu = 1.05, UPhase = 0, tUEvtStart = 10.0, tUEvtEnd = 10.2, tOmegaEvtStart = 100, tOmegaEvtEnd = 105) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
equation
  gFLmodelnodyn.switchOffSignal1 = false;
  gFLmodelnodyn.switchOffSignal2 = false;
  gFLmodelnodyn.switchOffSignal3 = false;
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  connect(omegaRef.y, gFLmodelnodyn.omegaRefPu) annotation(
    Line(points = {{-59, -40}, {-40.5, -40}, {-40.5, -12}, {-22, -12}, {-22, -12}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.PRefPu, step.y) annotation(
    Line(points = {{-22, 12}, {-40.6, 12}, {-40.6, 40}, {-59, 40}}, color = {0, 0, 127}));
  connect(step1.y, gFLmodelnodyn.URefPu) annotation(
    Line(points = {{-59, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(infiniteBusWithVariations.terminal, line.terminal2) annotation(
    Line(points = {{100, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(gFLmodelnodyn.terminal, line.terminal1) annotation(
    Line(points = {{20, 0.4}, {40, 0.4}, {40, 0}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-05, Interval = 0.0005),
    Diagram,
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Documentation(info = "<html><head></head><body><p>Author: Gaia Bergamaschi</p>
<p>SMIB test — GFL converter</p>
<p>Operating point: P = 0.6999 pu, Q = 0.1977 pu, U_pcc = 1.0372 pu, theta = 0.2049 rad</p>
<p>Used in thesis Gaia Bergamaschi for model validation, parametrized
from the time response of PVVoltageSource4Example. Use solver IDA. See branch 4059_Gflaveragemodel_beforerebase to mimic same results with WECC.</p>

  Four scenario cases (select by adjusting startTime values):

  Case 1 — Active-power step (PRef)
      PRef: offset = 0.7 pu  →  0.8 pu  (step height = +0.1 pu)
      Suggested startTime = 10 s
      [currently inactive: startTime = 1 000 000 s]

  Case 2 — Voltage reference step (URef)
      URef: offset = URef0Pu  →  URef0Pu * 1.1  (step height = +10 %)
      Suggested startTime = 10 s
      [currently inactive: startTime = 10 000 000 000 s]

  Case 3 — Voltage dip (infiniteBusWithVariations)
      Grid voltage: 1.0 pu  →  0.55 pu  from t = 100 s to t = 140 s
      Suggested: tUEvtStart = 10 s, tUEvtEnd = 14 s  (4 s fault)
      [currently fires outside 20 s window: tUEvtStart = 100 s]

  Case 4 — Frequency variation (infiniteBusWithVariations)
      Grid frequency: omegaEvtPu applied from t = 10 000 s to t = 10 001 s
      Suggested: tOmegaEvtStart = 10 s, tOmegaEvtEnd = 10.5 s, omegaEvtPu = 1.02 pu
      [currently inactive: tOmegaEvtStart = 10 000 s] &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</body></html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica --daeMode");
end OneConverterWeakGrid_2;
