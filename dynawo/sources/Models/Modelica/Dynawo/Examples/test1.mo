within Dynawo.Examples;

model test1
  import Dynawo;
  extends Icons.Example;
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0.05, UPu = 1)  annotation(
    Placement(visible = true, transformation(origin = {72, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 0.8)  annotation(
    Placement(visible = true, transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.dynamicLine dynamicLine(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375)  annotation(
    Placement(visible = true, transformation(origin = {-2, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  dynamicLine.switchOffSignal1.value = false;
  dynamicLine.switchOffSignal2.value = false;
  connect(infiniteBus1.terminal, dynamicLine.terminal1) annotation(
    Line(points = {{-70, 10}, {-12, 10}, {-12, -14}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, dynamicLine.terminal2) annotation(
    Line(points = {{72, 10}, {8, 10}, {8, -14}}, color = {0, 0, 255}));
end test1;
