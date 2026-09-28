within Dynawo.Examples.DynamicLine;

model DynLineTest "Dynamic Line testing - KinAlgRestoration reproducer"

  Electrical.Buses.InfiniteBus source1(UPu = 1.0, UPhase = 0)
    annotation(Placement(transformation(origin = {-76, 12}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.DynLine dynLine(RPu = 0.1, LPu = 1)
    annotation(Placement(transformation(origin = {-42, 12}, extent = {{-14, -14}, {14, 14}})));
  Electrical.Buses.Bus bus
    annotation(Placement(transformation(origin = {10, 12}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line(RPu = 0.1, XPu = 0, GPu = 0, BPu = 0)
    annotation(Placement(transformation(origin = {44, 12}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBus source2(UPu = 1.0, UPhase = 0.1)
    annotation(Placement(transformation(origin = {80, 12}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line2(RPu = 0.2, XPu = 0, GPu = 0, BPu = 0)
    annotation(Placement(transformation(origin = {10, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Buses.InfiniteBus source3(UPu = 0.95, UPhase = -0.05)
    annotation(Placement(transformation(origin = {10, -70}, extent = {{-10, -10}, {10, 10}})));

  Real didtLine(start = 0) "Rate of change of the algebraic branch's current - the der() under test";

equation
  connect(source1.terminal, dynLine.terminal1) annotation(
    Line(points = {{-76, 12}, {-56, 12}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, bus.terminal) annotation(
    Line(points = {{-28, 12}, {10, 12}}, color = {0, 0, 255}));
  connect(bus.terminal, line.terminal1) annotation(
    Line(points = {{10, 12}, {34, 12}}, color = {0, 0, 255}));
  connect(line.terminal2, source2.terminal) annotation(
    Line(points = {{54, 12}, {80, 12}}, color = {0, 0, 255}));
  connect(bus.terminal, line2.terminal1) annotation(
    Line(points = {{10, 12}, {10, -24}}, color = {0, 0, 255}));
  connect(line2.terminal2, source3.terminal) annotation(
    Line(points = {{10, -44}, {10, -70}}, color = {0, 0, 255}));

  didtLine = der(line.terminal1.i.re);

  line.switchOffSignal1=false;
  line.switchOffSignal2=false;
  line2.switchOffSignal1 = false;
  line2.switchOffSignal2 = false;
  dynLine.switchOffSignal1=false;
  dynLine.switchOffSignal2=false;

end DynLineTest;
