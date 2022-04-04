within Dynawo.Examples;

model test2
  import Dynawo;
  extends Icons.Example;
  Electrical.Lines.Line Line(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375)  annotation(
    Placement(visible = true, transformation(origin = {2, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 0.8) annotation(
    Placement(visible = true, transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0.05, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {72, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  Line.switchOffSignal1.value = false;
  Line.switchOffSignal2.value = false;
  connect(infiniteBus1.terminal, Line.terminal1) annotation(
    Line(points = {{-70, 10}, {-8, 10}, {-8, -12}}, color = {0, 0, 255}));
  connect(Line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{12, -12}, {12, 10}, {72, 10}}, color = {0, 0, 255}));
end test2;
