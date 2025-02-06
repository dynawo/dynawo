within Dynawo.Examples.FiveBusSystem.TestCases;

model FiveBusSystemCase2
extends Dynawo.Examples.FiveBusSystem.BaseClasses.FiveBusSystemOpt1;
  Modelica.Blocks.Sources.Ramp UsRefPu(duration = 2, height = 0.05, offset = gen.Efd0Pu / 70 + gen.UStator0Pu, startTime = 61)  annotation(
    Placement(visible = true, transformation(origin = {-10, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(UsRefPu.y, voltageRegulatorPssOel.UsRefPu) annotation(
    Line(points = {{1, -52}, {38, -52}}, color = {0, 0, 127}));

annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 120, Tolerance = 1e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_NLS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>toto</body></html>"));
end FiveBusSystemCase2;
