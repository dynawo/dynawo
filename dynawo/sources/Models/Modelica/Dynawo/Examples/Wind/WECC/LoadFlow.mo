within Dynawo.Examples.Wind.WECC;

model LoadFlow
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed g08(PGen0Pu = 1, QGen0Pu = 0, U0Pu = 1)  annotation(
    Placement(visible = true, transformation(origin = {-99, 0}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.00125, UEvtPu = 0, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  g08.switchOffSignal1.value = false;
  g08.switchOffSignal2.value = false;
  g08.switchOffSignal3.value = false;
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{100, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(g08.terminal, line.terminal2) annotation(
    Line(points = {{-98, 0}, {-20, 0}}, color = {0, 0, 255}));
end LoadFlow;
