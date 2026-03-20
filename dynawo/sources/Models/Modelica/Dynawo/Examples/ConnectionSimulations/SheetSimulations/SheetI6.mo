within Dynawo.Examples.ConnectionSimulations.SheetSimulations;

model SheetI6
  extends Examples.ConnectionSimulations.BaseSheetSimulations.BaseSheetI6(XccPu = 0);
  extends Examples.ConnectionSimulations.BaseUnitModel(XccPu = 0);
equation
  connect(infiniteBusFromTable.terminal, Unit.terminal) annotation(
    Line(points = {{-100, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, Unit.omegaRefPu) annotation(
    Line(points = {{80, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I6")}),
  experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.001),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"));
end SheetI6;
