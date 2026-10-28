within Dynawo.Examples.DynamicLine;

model DynLineTestSingle "Dynamic Line testing - KinAlgRestoration reproducer"

  Electrical.Buses.InfiniteBus source1(UPu = 1.0, UPhase = 0)
    annotation(Placement(transformation(origin = {-76, 12}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.DynLine dynLine(RPu = 0.1, LPu = 1)
    annotation(Placement(transformation(origin = {4, 12}, extent = {{-14, -14}, {14, 14}})));
  Electrical.Buses.InfiniteBus source2(UPu = 1.0, UPhase = 0.1)
    annotation(Placement(transformation(origin = {80, 12}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(source1.terminal, dynLine.terminal1) annotation(
    Line(points = {{-76, 12}, {-10, 12}}, color = {0, 0, 255}));
  dynLine.switchOffSignal1 = false;
  dynLine.switchOffSignal2 = false;
  connect(dynLine.terminal2, source2.terminal) annotation(
    Line(points = {{18, 12}, {80, 12}}, color = {0, 0, 255}));
end DynLineTestSingle;
