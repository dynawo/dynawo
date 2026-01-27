within Dynawo.Examples.EMTP_OM;

model Osc40Hz
  extends Icons.Example;
  Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 1.87, Kid = 25, Kiq = 25, Kp = 2, Kpc = 0.18, Kpd = 0.1, Kpq = 0.1, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 111, tQFilt = 1 / 111, tUFilt = 1 / 6283, tUqPLL = 1 / 111, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {-64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus InfiniteBus(UNom = 400,UPhase = -0.04, UPu = 1.1) annotation(
    Placement(visible = true, transformation(origin = {2, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Types.VoltageModulePu U1Pu;
  Dynawo.Types.Angle UPhase1;
  Dynawo.Types.VoltageModulePu U2Pu;
  Dynawo.Types.Angle UPhase2;
  Electrical.Lines.DynLine dynLine(LPu = 0.03375, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.003375, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynLine dynLine1(LPu = 0.03375, P01Pu = 5, P02Pu = -4.95, Q01Pu = 0.21, Q02Pu = 0.4804, RPu = 0.003375, U01Pu = 1.1072, U02Pu = 1.099, UPhase01 = 0.098, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.DynLine dynLine2(LPu = 0.01, P01Pu = 0.09, P02Pu = -0.09, Q01Pu = 0.9892, Q02Pu = -0.9892, RPu = 0.001, U01Pu = 1.099, U02Pu = 1.1, UPhase01 = -0.04, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {2, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Buses.Bus Bus annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
parameter Real modif1 = 1;
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = -0.5, startTime = 2)  annotation(
    Placement(visible = true, transformation(origin = {-120, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = -0.1, offset = 0.5, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {142, 2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL2(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 1.87, Kid = 25, Kiq = 25, Kp = 2, Kpc = 0.18, Kpd = 0.1, Kpq = 0.1, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.1072, UPhase0 = 0.098, tPFilt = 1 / 111, tQFilt = 1 / 111, tUFilt = 1 / 6283, tUqPLL = 1 / 111, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {84, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
// No switch-off of the dynLines
  dynLine.switchOffSignal1.value = false;
  dynLine.switchOffSignal2.value = false;
  dynLine1.switchOffSignal1.value = false;
  dynLine1.switchOffSignal2.value = false;
  dynLine2.switchOffSignal1.value = false;
  dynLine2.switchOffSignal2.value = false;
// No modifications in GFL set points
  //der(GFL1.PFilterRefPu) = 0;
  der(GFL1.QFilterRefPu) = 0;
  der(GFL1.omegaRefPu) = 0;
  //der(GFL2.PFilterRefPu) = 0;
  der(GFL2.QFilterRefPu) = 0;
  der(GFL2.omegaRefPu) = 0;
  // No switch GFM
  GFL1.switchOffSignal1.value = false;
  GFL1.switchOffSignal2.value = false;
  GFL1.switchOffSignal3.value = false;


  GFL2.switchOffSignal1.value = false;
  GFL2.switchOffSignal2.value = false;
  GFL2.switchOffSignal3.value = false;
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
  connect(Bus.terminal, dynLine1.terminal2) annotation(
    Line(points = {{2, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, Bus.terminal) annotation(
    Line(points = {{-22, 0}, {2, 0}}, color = {0, 0, 255}));
  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{-52, 0}, {-42, 0}}, color = {0, 0, 255}));
  connect(step.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{-108, 4}, {-90, 4}, {-90, 8}, {-74, 8}}, color = {0, 0, 127}));
  connect(GFL2.PFilterRefPu, step1.y) annotation(
    Line(points = {{95, 8}, {104.5, 8}, {104.5, 2}, {131, 2}}, color = {0, 0, 127}));
  connect(dynLine1.terminal1, GFL2.terminal) annotation(
    Line(points = {{40, 0}, {73, 0}}, color = {0, 0, 255}));

annotation(
    Diagram(coordinateSystem(extent = {{-140, 20}, {140, -80}})),
    Documentation(info = "<html><head></head><body>Last model sent to UPc where oscillations of 40Hz where seen however once I corrected the model DynGFLFilteredMesures no oscillations are seen</body></html>"));

end Osc40Hz;
