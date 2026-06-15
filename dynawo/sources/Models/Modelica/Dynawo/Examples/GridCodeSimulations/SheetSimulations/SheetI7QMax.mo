within Dynawo.Examples.GridCodeSimulations.SheetSimulations;
model SheetI7QMax
  extends Icons.Example;
  extends Examples.GridCodeSimulations.BaseSheetSimulations.BaseSheetI7(XccPu = 0, Q0Pu = -0.3*SNom/Electrical.SystemBase.SnRef);
  extends Examples.GridCodeSimulations.BaseUnitModel(XccPu = 0, Q0Pu = -0.3*SNom/Electrical.SystemBase.SnRef);

equation
  connect(infiniteBusFromTable.terminal, Unit.terminal) annotation(
    Line(points = {{-100, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, Unit.omegaRefPu) annotation(
    Line(points = {{80, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I7 QMax")}),
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"),
    Documentation(info = "<html><head></head><body><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The event simulated is a voltage surge imposed with an infinite bus at the production unit's connection point. The production unit should not disconnect and should absorb reactive current during the surge if it follows the grid code's requirements. The production unit's operating condition is at QMax in this test case. The test is described thoroughly in fiche I7 from the french grid code.&nbsp;</span></body></html>"));
end SheetI7QMax;
