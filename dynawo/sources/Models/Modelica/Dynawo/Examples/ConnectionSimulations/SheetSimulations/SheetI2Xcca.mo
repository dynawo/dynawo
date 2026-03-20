within Dynawo.Examples.ConnectionSimulations.SheetSimulations;

model SheetI2Xcca
  extends Dynawo.Examples.ConnectionSimulations.BaseSheetSimulations.BaseSheetI2(XccPu = XccPu_To_Be_Defined);
  extends Dynawo.Examples.ConnectionSimulations.BaseUnitModel(URef(height = 0.02), XccPu = XccPu_To_Be_Defined);

  parameter Types.PerUnit XccPu_To_Be_Defined = XaPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

equation
  connect(Xcc_a.terminal2, Unit.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, Unit.omegaRefPu) annotation(
    Line(points = {{80, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I2 Xcc = a")}),
  experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.001),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"));
end SheetI2Xcca;
