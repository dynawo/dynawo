within Dynawo.Examples.TwoConverters;

model TwoConvertersCsGFL
  extends Icons.Example;
  Electrical.Buses.Bus Bus annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.InfiniteBus InfiniteBus(UPhase = -0.04, UPu = 1.1) annotation(
    Placement(visible = true, transformation(origin = {2, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005 + 0.001875, XPu = 0.015 + 0.01875) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.006, XPu = 0.08) annotation(
    Placement(visible = true, transformation(origin = {2, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Types.VoltageModulePu U1Pu;
  Dynawo.Types.Angle UPhase1;
  Dynawo.Types.VoltageModulePu U2Pu;
  Dynawo.Types.Angle UPhase2;
  Electrical.PEIR.Converters.General.Average.GridFollowing.csGFL csGFL1(Ki = 10, Kid = 50, Kiq = 50, Kp = 2, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.csGFL csGFL2(Ki = 10, Kid = 50, Kiq = 50, Kp = 2, Kpd = 0.11, Kpq = 0.11, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.1072, UPhase0 = 0.098, XTransformerPu = 0.05, tPFilt = 0.01, tQFilt = 0.01) annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
// No switch-off of the lines
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
// No modifications in GFL set points
  der(csGFL1.PFilterRefPu) = 0;
  der(csGFL1.QFilterRefPu) = 0;
  der(csGFL1.omegaRefPu) = 0;
  der(csGFL2.PFilterRefPu) = 0;
  der(csGFL2.QFilterRefPu) = 0;
  der(csGFL2.omegaRefPu) = 0;
  U1Pu = Modelica.ComplexMath.'abs'(csGFL1.terminal.V);
  U2Pu = Modelica.ComplexMath.'abs'(csGFL2.terminal.V);
  UPhase1 = Modelica.ComplexMath.arg(csGFL1.terminal.V);
  UPhase2 = Modelica.ComplexMath.arg(csGFL2.terminal.V);
  connect(line1.terminal2, Bus.terminal) annotation(
    Line(points = {{-22, 0}, {2, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, Bus.terminal) annotation(
    Line(points = {{2, -10}, {2, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, InfiniteBus.terminal) annotation(
    Line(points = {{2, -30}, {2, -40}}, color = {0, 0, 255}));
  connect(Bus.terminal, line.terminal2) annotation(
    Line(points = {{2, 0}, {24, 0}}, color = {0, 0, 255}));
  connect(csGFL1.terminal, line1.terminal1) annotation(
    Line(points = {{-52, 0}, {-42, 0}}, color = {0, 0, 255}));
  connect(csGFL2.terminal, line.terminal1) annotation(
    Line(points = {{62, 0}, {44, 0}}, color = {0, 0, 255}));
end TwoConvertersCsGFL;
