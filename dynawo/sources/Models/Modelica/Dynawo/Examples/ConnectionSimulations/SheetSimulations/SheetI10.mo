within Dynawo.Examples.ConnectionSimulations.SheetSimulations;

model SheetI10
  extends Examples.ConnectionSimulations.BaseSheetSimulations.BaseSheetI10(XccPu = 0);
  extends Examples.ConnectionSimulations.BaseUnitModel(Unit(P0Pu = -0.8  * SNom / Electrical.SystemBase.SnRef), XccPu = 0);
equation
  connect(bus.terminal, Unit.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(inertialGrid1.omegaPu, Unit.omegaRefPu) annotation(
    Line(points = {{-58, 76}, {60, 76}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I10")}),
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"));
end SheetI10;
