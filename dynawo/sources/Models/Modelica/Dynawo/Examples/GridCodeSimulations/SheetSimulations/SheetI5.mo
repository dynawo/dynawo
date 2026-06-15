within Dynawo.Examples.GridCodeSimulations.SheetSimulations;
model SheetI5
  extends Icons.Example;
  extends Examples.GridCodeSimulations.BaseSheetSimulations.BaseSheetI5(XccPu = XccPu_To_Be_Defined);
  extends Examples.GridCodeSimulations.BaseUnitModel(XccPu = XccPu_To_Be_Defined);

  parameter Types.PerUnit XccPu_To_Be_Defined = 3/4*XbPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

equation
  connect(line22.terminal2, Unit.terminal) annotation(
    Line(points = {{-26, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, Unit.terminal) annotation(
    Line(points = {{-30, 50}, {-20, 50}, {-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, Unit.omegaRefPu) annotation(
    Line(points = {{80, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I5")}),
    experiment(StartTime = 0, StopTime = 20, Tolerance = 0.001, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"),
    Documentation(info = "<html><head></head><body>The event simulated is a bolted fault of 150ms at t=2s and close to the installation. In this simulation, the fault is eliminated by switching off the line concerned. The production unit should inject reactive current during the fault and recover its active power in less than 2s if it follows the grid code's requirements. The test is described thoroughly in fiche I5 from the french grid code.</body></html>"));
end SheetI5;
