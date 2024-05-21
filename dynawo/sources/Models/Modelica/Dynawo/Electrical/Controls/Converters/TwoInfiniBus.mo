within Dynawo.Electrical.Controls.Converters;

model TwoInfiniBus
Types.PerUnit PLine1Pu;
Types.PerUnit  QLine1Pu;

Types.PerUnit PLinePu;
Types.PerUnit  QLinePu;

  parameter Types.ActivePowerPu PRefLoadPu = 1 "Active power request for the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";
  Dynawo.Electrical.Lines.Line line(BPu = 0.00003, GPu = 0, RPu = 0.005, XPu = 0.5) annotation(
    Placement(visible = true, transformation(origin = {-68, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ loadPQ(PPu(fixed = false, start = 1), u0Pu = Complex(1, 0))  annotation(
    Placement(visible = true, transformation(origin = {-13, 17}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0.00003, GPu = 0, RPu = 0.005, XPu = 0.5) annotation(
    Placement(visible = true, transformation(origin = {28, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 0.9)  annotation(
    Placement(visible = true, transformation(origin = {-159, 41}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 0.9)  annotation(
    Placement(visible = true, transformation(origin = {127, 41}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  loadPQ.switchOffSignal1.value = false;
  loadPQ.switchOffSignal2.value = false;
  loadPQ.deltaQ = 0;
  loadPQ.deltaP = 0;
  loadPQ.PRefPu = PRefLoadPu;
  loadPQ.QRefPu = QRefLoadPu;
  /*Base SnRef generator convention*/
  PLinePu = ComplexMath.real(line.terminal1.V * ComplexMath.conj(line.terminal1.i));
  QLinePu = ComplexMath.imag(line.terminal1.V * ComplexMath.conj(line.terminal1.i));
 
 
  /*Base SnRef generator convention*/
  PLine1Pu = ComplexMath.real(line1.terminal2.V * ComplexMath.conj(line1.terminal2.i));
  QLine1Pu = ComplexMath.imag(line1.terminal2.V * ComplexMath.conj(line1.terminal2.i));
 
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-159, 41}, {-159, 74}, {-78, 74}}, color = {0, 0, 255}));
  connect(line1.terminal2, infiniteBus1.terminal) annotation(
    Line(points = {{38, 72}, {127, 72}, {127, 41}}, color = {0, 0, 255}));
  connect(loadPQ.terminal, line1.terminal1) annotation(
    Line(points = {{-12, 18}, {18, 18}, {18, 72}}, color = {0, 0, 255}));
  connect(loadPQ.terminal, line.terminal2) annotation(
    Line(points = {{-12, 18}, {-58, 18}, {-58, 74}}, color = {0, 0, 255}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-280, 180}, {260, -80}})),
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.001));
end TwoInfiniBus;