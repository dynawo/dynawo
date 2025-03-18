within Dynawo.Examples.Wind.WECC;

model LoadFlow
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed g13(PGen0Pu = 0.8660008104701283, QGen0Pu = -0.2459918952779657, U0Pu = 0.9999984060396585, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0))  annotation(
    Placement(visible = true, transformation(origin = {-99, 0}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.0941753221287507, UEvtPu = 0, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.0333333333333, XPu = 0.3333333333333) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation

  g13.switchOffSignal1.value = false;
  g13.switchOffSignal2.value = false;
  g13.switchOffSignal3.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;

  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{100, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(g13.terminal, line.terminal2) annotation(
    Line(points = {{-98, 0}, {-20, 0}}, color = {0, 0, 255}));
end LoadFlow;
