within Dynawo.EMTP_OM;

model OneDynGFLDynLine
  extends Icons.Example;
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 2.1972, Kid = 25, Kiq = 25, Kp = 2, Kpc = 0.20981, Kpd = 0.1, Kpq = 0.1, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = 0.28, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 111, tQFilt = 1 / 111, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {0, 12}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  // Dynawo.Types.VoltageModulePu U1Pu;
  // Dynawo.Types.Angle UPhase1;
  // Dynawo.Types.VoltageModulePu U2Pu;
  // Dynawo.Types.Angle UPhase2;
  Dynawo.Electrical.Lines.DynLine dynLine(LPu = 0.005, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.0005, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {60, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Real modif1 = 1;
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.5, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0.01, offset = 0.021, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {-126, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus InfiniteBus(UNom = 400, UPhase = -0.04, UPu = 1.1) annotation(
    Placement(visible = true, transformation(origin = {102, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.1, offset = 0, startTime = 3) annotation(
    Placement(visible = true, transformation(origin = {-122, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-70, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(height = 0.01, offset = 0, startTime = 7) annotation(
    Placement(visible = true, transformation(origin = {-126, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-68, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step4(height = 0.1, offset = 0, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-120, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  dynLine.switchOffSignal1.value = false;
  dynLine.switchOffSignal2.value = false;
  der(GFL1.omegaRefPu) = 0;
  GFL1.switchOffSignal1.value = false;
  GFL1.switchOffSignal2.value = false;
  GFL1.switchOffSignal3.value = false;
  dynLine.omegaPu.value = 1;
//  U1Pu = Modelica.ComplexMath.'abs'(GFL1.terminal.V);
// UPhase1 = Modelica.ComplexMath.arg(GFL1.terminal.V);
  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{20, 12}, {50, 12}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, InfiniteBus.terminal) annotation(
    Line(points = {{70, 12}, {102, 12}, {102, 36}}, color = {0, 0, 255}));
  connect(add1.y, GFL1.QFilterRefPu) annotation(
    Line(points = {{-58, -26}, {-42, -26}, {-42, 4}, {-20, 4}}, color = {0, 0, 127}));
  connect(step2.y, add1.u1) annotation(
    Line(points = {{-114, -28}, {-96, -28}, {-96, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(step3.y, add1.u2) annotation(
    Line(points = {{-114, -64}, {-92, -64}, {-92, -32}, {-82, -32}}, color = {0, 0, 127}));
  connect(step.y, add3.u1) annotation(
    Line(points = {{-109, 80}, {-80, 80}, {-80, 36}}, color = {0, 0, 127}));
  connect(step1.y, add3.u3) annotation(
    Line(points = {{-110, 6}, {-80, 6}, {-80, 20}}, color = {0, 0, 127}));
  connect(add3.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{-56, 28}, {-20, 28}, {-20, 26}}, color = {0, 0, 127}));
  connect(step4.y, add3.u2) annotation(
    Line(points = {{-108, 42}, {-92, 42}, {-92, 28}, {-80, 28}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 100}, {120, -80}}), graphics = {Text(origin = {-121, -30}, extent = {{5, 0}, {-5, 0}}, textString = "text")}));
end OneDynGFLDynLine;
