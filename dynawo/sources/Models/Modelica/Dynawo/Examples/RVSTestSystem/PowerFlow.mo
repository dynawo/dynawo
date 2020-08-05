within Dynawo.Examples.RVSTestSystem;

model PowerFlow
  extends StaticNetwork;
  Dynawo.Electrical.Machines.GeneratorPV AustenG1 annotation(
    Placement(visible = true, transformation(origin = {122, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
  connect(AustenG1.terminal, Austen123.terminal) annotation(
    Line(points = {{122, 54}, {84, 54}, {84, 50}, {84, 50}, {84, 50}}, color = {0, 0, 255}));
end PowerFlow;
