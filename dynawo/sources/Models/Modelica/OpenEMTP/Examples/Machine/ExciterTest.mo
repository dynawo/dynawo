within OpenEMTP.Examples.Machine;

model ExciterTest
  Modelica.Blocks.Sources.Constant constant3(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-36, -30}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Electrical.Exciters_Governor.PSS1A pss1a(A1 = 1e-15, A2 = 1e-15,T6 = 1e-15, VSinit = 1)  annotation(
    Placement(visible = true, transformation(origin = {16, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(pss1a.VSI, constant3.y) annotation(
    Line(points = {{4, -30}, {-30, -30}, {-30, -30}, {-30, -30}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-06, Interval = 1.00002e-05),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=initialization ",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end ExciterTest;
