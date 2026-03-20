within Dynawo.Examples.ConnectionSimulations.BaseSheetSimulations;

model BaseSheetI10
  extends Modelica.Icons.Example;
  extends BaseParameters;

  Electrical.Buses.Bus bus annotation(
    Placement(transformation(origin = {-20, 0},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Electrical.Loads.LoadAlphaBeta loadAlphaBeta(u0Pu = Complex(1, 0), s0Pu = Complex(0.8*SNom/Electrical.SystemBase.SnRef, 0), i0Pu = Modelica.ComplexMath.conj(loadAlphaBeta.s0Pu/loadAlphaBeta.u0Pu), alpha = 0, beta = 0) annotation(
    Placement(transformation(origin = {-20, -60}, extent = {{-20, -20}, {20, 20}})));
  Electrical.Sources.InertialGrid.InertialGrid inertialGrid1(DPu = 0, Fh = 1, H = 1, Km = 1, P0Pu = 0, Q0Pu = 0, R = 999999, SNom = SNom, Tr = 0.1, U0Pu = 1, UPhase0 = 0) annotation(
    Placement(transformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}})));
  Electrical.Lines.Line line(RPu = 0, GPu = 0, BPu = 0, XPu = XbPu) annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
equation
// No variations in PspPu for the inertial grid
  der(inertialGrid1.reducedOrderSFR.PspPu) = 0;
  loadAlphaBeta.PRefPu = if time < 2 then 0.8 * SNom / Electrical.SystemBase.SnRef else 0.9 * SNom / Electrical.SystemBase.SnRef;
  loadAlphaBeta.QRefPu = if time < 2 then 0 else 0.04  * SNom / Electrical.SystemBase.SnRef;
  der(loadAlphaBeta.deltaQ) = 0;
  der(loadAlphaBeta.deltaP) = 0;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  inertialGrid1.injectorURI.switchOffSignal1.value = false;
  inertialGrid1.injectorURI.switchOffSignal2.value = false;
  inertialGrid1.injectorURI.switchOffSignal3.value = false;
  loadAlphaBeta.switchOffSignal1.value = false;
  loadAlphaBeta.switchOffSignal2.value = false;
  connect(loadAlphaBeta.terminal, bus.terminal) annotation(
    Line(points = {{-20, -60}, {-20, 0}}, color = {0, 0, 255}));
  connect(inertialGrid1.omegaPu, inertialGrid1.omegaRefPu) annotation(
    Line(points = {{-58, 76}, {-40, 76}, {-40, 100}, {-80, 100}, {-80, 84}}, color = {0, 0, 127}));
  connect(inertialGrid1.terminal, line.terminal2) annotation(
    Line(points = {{-80, 60}, {-80, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, bus.terminal) annotation(
    Line(points = {{-40, 0}, {-20, 0}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 0.0001, Interval = 0.0004),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"),
    Diagram);
end BaseSheetI10;
