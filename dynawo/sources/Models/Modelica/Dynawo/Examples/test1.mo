within Dynawo.Examples;

model test1

  import Dynawo.Types;
  import Dynawo;
  extends Icons.Example;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;


  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0.05, UPu = 1)  annotation(
    Placement(visible = true, transformation(origin = {76, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 0.8)  annotation(
    Placement(visible = true, transformation(origin = {-84, 8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.DynamicLine dynamicLine(CPu = 0.0000375, GPu = 0, LPu = 0.0375, RPu = 0.00375) annotation(
    Placement(visible = true, transformation(origin = {-2, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  dynamicLine.omegaPu = 1 ;
  dynamicLine.switchOffSignal1.value = false;
  dynamicLine.switchOffSignal2.value = false;
  connect(dynamicLine.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{8, 8}, {76, 8}, {76, 10}}, color = {0, 0, 255}));
  connect(dynamicLine.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-12, 8}, {-84, 8}}, color = {0, 0, 255}));
end test1;
