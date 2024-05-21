within Dynawo.Examples.GridForming;

model TestGridv4


  Types.ActivePowerPu PLoad;
  parameter Types.ActivePowerPu PRefLoadPu =-3 "Active power request for the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";
  Dynawo.Electrical.Lines.Line line(BPu = 0.00003, GPu = 0, RPu = 0.005, XPu = 0.15) annotation(
    Placement(visible = true, transformation(origin = {-3, 39}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Dynawo.Examples.GridForming.AcGrid acGrid(SNom = SystemBase.SnRef * 10) annotation(
    Placement(visible = true, transformation(origin = {-177, 13}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ loadPQ annotation(
    Placement(visible = true, transformation(origin = {145, -29}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(offset = SystemBase.omegaRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-332, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  loadPQ.switchOffSignal1.value = false;
  loadPQ.switchOffSignal2.value = false;
  loadPQ.deltaQ = 0;
  loadPQ.deltaP = 0;
  loadPQ.PRefPu = PRefLoadPu;
  loadPQ.QRefPu = QRefLoadPu;
  
  /*Base SnRef generator convention*/
  PLoad= ComplexMath.real(line.terminal2.V * ComplexMath.conj(line.terminal2.i));
 
  
  connect(line.terminal1, acGrid.aCPower) annotation(
    Line(points = {{-40, 39}, {-134, 39}}, color = {0, 0, 255}));
  connect(line.terminal2, loadPQ.terminal) annotation(
    Line(points = {{34, 39}, {146, 39}, {146, -28}}, color = {0, 0, 255}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-260, 80}, {180, -80}})),
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.06));
end TestGridv4;