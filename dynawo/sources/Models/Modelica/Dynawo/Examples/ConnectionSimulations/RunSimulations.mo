within Dynawo.Examples.ConnectionSimulations;

model RunSimulations
  extends Modelica.Icons.Example;

  SheetSimulations.SheetI2Xcca sheetI2Xcca annotation(
    Placement(transformation(origin = {-90, 30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI2Xccb sheetI2Xccb annotation(
    Placement(transformation(origin = {-30, 30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI5 sheetI5 annotation(
    Placement(transformation(origin = {30, 30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI6 sheetI6 annotation(
    Placement(transformation(origin = {90, 30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI7QMax sheetI7QMax annotation(
    Placement(transformation(origin = {-90, -30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI7QMin sheetI7QMin annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{-20, -20}, {20, 20}})));
  SheetSimulations.SheetI10 sheetI10 annotation(
    Placement(transformation(origin = {30, -30}, extent = {{-20, -20}, {20, 20}})));
equation

annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"),
  Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})),
  Icon(coordinateSystem(extent = {{-120, -100}, {120, 100}})),
  Documentation(info = "<html><head></head><body>Run this simulation to run at the same time all the simulation test cases fom the french grid code.<div><br></div><div>
<p data-start=\"61\" data-end=\"96\"><strong data-start=\"61\" data-end=\"96\">Ideas for package improvements:</strong></p><p style=\"margin: 0px;\">
</p><ul data-start=\"98\" data-end=\"297\">
<li data-section-id=\"1is4hjg\" data-start=\"98\" data-end=\"230\">
<p data-start=\"100\" data-end=\"230\">Expose parameters at a higher level to allow direct modification while visualizing curves across all simulations simultaneously.</p>
</li>
<li data-section-id=\"18yh7n5\" data-start=\"231\" data-end=\"269\">
<p data-start=\"233\" data-end=\"269\">Identify and fix the issue in I10.</p>
</li>
<li data-section-id=\"1vussqs\" data-start=\"270\" data-end=\"297\">
<p data-start=\"272\" data-end=\"297\">Perform the Zone 1 tests.</p></li></ul><p style=\"margin: 0px;\"><!--EndFragment--></p></div></body></html>"));
end RunSimulations;
