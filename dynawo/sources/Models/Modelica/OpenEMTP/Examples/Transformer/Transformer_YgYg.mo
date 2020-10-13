within OpenEMTP.Examples.Transformer;
model Transformer_YgYg
  extends Modelica.Icons.Example;
  Modelica.Electrical.MultiPhase.Basic.Resistor resistor(R = {250, 150, 350}) annotation (
    Placement(visible = true, transformation(origin = {28, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.YgYg ygyg(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.2, f = 60, v1 = 369.15, v2 = 20) annotation (
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage AC(V = 369.15e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation (
    Placement(visible = true, transformation(origin = {-34, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Inductor inductor(L = {240e-3, 410e-3, 310e-3}) annotation (
    Placement(visible = true, transformation(origin = {54, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Inductor inductor1(L = {240e-3, 410e-3, 310e-3}) annotation (
    Placement(visible = true, transformation(origin = {60, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Resistor resistor1(R = {250, 150, 350}) annotation (
    Placement(visible = true, transformation(origin = {34, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sources.CosineVoltage cosineVoltage(V = 369.15e3 * sqrt(2 / 3) * {1, 1, 1}, freqHz = 60 * {1, 1, 1}, phase = {0, -2.0944, 2.0944}) annotation (
    Placement(visible = true, transformation(origin = {-28, -54}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.Transformers.DD dd(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.2, f = 60, v1 = 369.15, v2 = 20) annotation (
    Placement(visible = true, transformation(origin = {2, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground ground2 annotation (
    Placement(visible = true, transformation(origin = {-60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground4 annotation (
    Placement(visible = true, transformation(origin = {-60, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground1 annotation (
    Placement(visible = true, transformation(origin = {80, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.MultiPhase.Ground ground3 annotation (
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(inductor1.plug_n, ground3.positivePlug1) annotation (
    Line(points = {{70, -54}, {80, -54}, {80, -70}, {80, -70}}, color = {0, 0, 255}));
  connect(inductor.plug_n, ground1.positivePlug1) annotation (
    Line(points = {{64, 60}, {80, 60}, {80, 46}, {80, 46}}, color = {0, 0, 255}));
  connect(cosineVoltage.plug_n, ground4.positivePlug1) annotation (
    Line(points = {{-38, -54}, {-60, -54}, {-60, -64}, {-60, -64}}, color = {0, 0, 255}));
  connect(AC.plug_n, ground2.positivePlug1) annotation (
    Line(points = {{-44, 60}, {-60, 60}, {-60, 50}}, color = {0, 0, 255}));
  connect(resistor.plug_n, inductor.plug_p) annotation (
    Line(points = {{38, 60}, {44, 60}}));
  connect(ygyg.k, AC.plug_p) annotation (
    Line(points = {{-10, 60}, {-24, 60}}, color = {0, 0, 255}));
  connect(resistor.plug_p, ygyg.m) annotation (
    Line(points = {{18, 60}, {10, 60}}, color = {0, 0, 255}));
  connect(cosineVoltage.plug_p, dd.k) annotation (
    Line(points = {{-18, -54}, {-8, -54}, {-8, -54}, {-8, -54}}, color = {0, 0, 255}));
  connect(dd.m, resistor1.plug_p) annotation (
    Line(points = {{12, -54}, {24, -54}, {24, -54}, {24, -54}}, color = {0, 0, 255}));
  connect(resistor1.plug_n, inductor1.plug_p) annotation (
    Line(points = {{44, -54}, {50, -54}, {50, -54}, {50, -54}}, color = {0, 0, 255}));
  annotation (
    uses(Modelica(version = "3.2.3")),
    experiment(StopTime = 0.032, Interval = 1e-06, Tolerance = 1e-05, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end Transformer_YgYg;
