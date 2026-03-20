within Dynawo.Examples.ConnectionSimulations.SheetSimulations;

model SheetI5
  extends Examples.ConnectionSimulations.BaseSheetSimulations.BaseSheetI5(XccPu = XccPu_To_Be_Defined);
  extends Examples.ConnectionSimulations.BaseUnitModel(XccPu = XccPu_To_Be_Defined);

  parameter Types.PerUnit XccPu_To_Be_Defined = 3/4*XbPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

equation
  connect(line22.terminal2, Unit.terminal) annotation(
    Line(points = {{-26, -20}, {-20, -20}, {-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, Unit.terminal) annotation(
    Line(points = {{-30, 20}, {-20, 20}, {-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, Unit.omegaRefPu) annotation(
    Line(points = {{80, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I5")}),
  experiment(StartTime = 0, StopTime = 20, Tolerance = 0.001, Interval = 0.001),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"));
end SheetI5;
