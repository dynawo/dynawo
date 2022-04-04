within Dynawo.Examples;

model test1
  import Dynawo;
  extends Icons.Example;
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0.05, UPu = 1)  annotation(
    Placement(visible = true, transformation(origin = {72, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 0.8)  annotation(
    Placement(visible = true, transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.dynamicLine dynamicLine(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375) annotation(
    Placement(visible = true, transformation(origin = {-2, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  dynamicLine.switchOffSignal1.value = false;
  dynamicLine.switchOffSignal2.value = false;
  connect(dynamicLine.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{8, 6}, {72, 6}, {72, 10}}, color = {0, 0, 255}));
  connect(dynamicLine.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-12, 6}, {-70, 6}, {-70, 10}}, color = {0, 0, 255}));
end test1;
