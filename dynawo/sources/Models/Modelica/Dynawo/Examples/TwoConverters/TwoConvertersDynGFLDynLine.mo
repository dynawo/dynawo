within Dynawo.Examples.TwoConverters;

model TwoConvertersDynGFLDynLine
  extends Icons.Example;
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFL GFL1(CFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 0.01, tQFilt = 0.01, tVSC = 0.0004) annotation(
    Placement(visible = true, transformation(origin = {-64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFL GFL2(CFilterPu = 1e-5, Ki = 10, Kic = 7, Kid = 50, Kiq = 50, Kp = 2, Kpc = 0.5, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.1072, UPhase0 = 0.098, tPFilt = 0.01, tQFilt = 0.01, tVSC = 0.0004) annotation(
    Placement(visible = true, transformation(origin = {64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBus InfiniteBus(UPhase = -0.04, UPu = 1.1) annotation(
    Placement(visible = true, transformation(origin = {2, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Types.VoltageModulePu U1Pu;
  Dynawo.Types.Angle UPhase1;
  Dynawo.Types.VoltageModulePu U2Pu;
  Dynawo.Types.Angle UPhase2;
  Electrical.Lines.DynLine dynLine(LPu = 0.015 + 0.01875, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0005 + 0.001875, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynLine dynLine1(LPu = 0.015 + 0.01875, P01Pu = 5, P02Pu = -4.95, Q01Pu = 0.21, Q02Pu = 0.4804, RPu = 0.0005 + 0.001875, U01Pu = 1.1072, U02Pu = 1.099, UPhase01 = 0.098, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.DynLine dynLine2(LPu = 0.06, P01Pu = 0.09, P02Pu = -0.09, Q01Pu = 0.9892, Q02Pu = -0.9892, RPu = 0.005, U01Pu = 1.099, U02Pu = 1.1, UPhase01 = -0.04, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {2, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Buses.Bus Bus annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// No switch-off of the dynLines
  dynLine.switchOffSignal1.value = false;
  dynLine.switchOffSignal2.value = false;
  dynLine1.switchOffSignal1.value = false;
  dynLine1.switchOffSignal2.value = false;
  dynLine2.switchOffSignal1.value = false;
  dynLine2.switchOffSignal2.value = false;
// No modifications in GFL set points
  der(GFL1.PFilterRefPu) = 0;
  der(GFL1.QFilterRefPu) = 0;
  der(GFL1.omegaRefPu) = 0;
  der(GFL2.PFilterRefPu) = 0;
  der(GFL2.QFilterRefPu) = 0;
  der(GFL2.omegaRefPu) = 0;
// OmegaRef = 1
  dynLine.omegaPu.value = 1;
  dynLine1.omegaPu.value = 1;
  dynLine2.omegaPu.value = 1;
  U1Pu = Modelica.ComplexMath.'abs'(GFL1.terminal.V);
  U2Pu = Modelica.ComplexMath.'abs'(GFL2.terminal.V);
  UPhase1 = Modelica.ComplexMath.arg(GFL1.terminal.V);
  UPhase2 = Modelica.ComplexMath.arg(GFL2.terminal.V);
  connect(dynLine2.terminal2, Bus.terminal) annotation(
    Line(points = {{2, -20}, {2, 0}}, color = {0, 0, 255}));
  connect(dynLine2.terminal1, InfiniteBus.terminal) annotation(
    Line(points = {{2, -40}, {2, -66}}, color = {0, 0, 255}));
  connect(dynLine1.terminal1, GFL2.terminal) annotation(
    Line(points = {{40, 0}, {54, 0}}, color = {0, 0, 255}));
  connect(Bus.terminal, dynLine1.terminal2) annotation(
    Line(points = {{2, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, Bus.terminal) annotation(
    Line(points = {{-22, 0}, {2, 0}}, color = {0, 0, 255}));
  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{-52, 0}, {-42, 0}}, color = {0, 0, 255}));
end TwoConvertersDynGFLDynLine;
