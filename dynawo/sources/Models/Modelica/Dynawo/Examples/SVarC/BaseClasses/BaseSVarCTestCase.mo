within Dynawo.Examples.SVarC.BaseClasses;
model BaseSVarCTestCase "Base model for SVarC test cases"

  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {102, 20}, extent = {{-18, -18}, {18, 18}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.027654) annotation(
    Placement(visible = true, transformation(origin = {46, 20}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.SVarCStandard sVarCStandard(
    B0Pu = 0,
    BMaxPu = 1.0678,
    BMinPu = -1.0466,
    BShuntPu = 0,
    G0Pu = 0,
    IMaxPu = 1,
    IMinPu = -1,
    KCurrentLimiter = 8,
    Kp = 1.75,
    Lambda = 0.01,
    P0Pu = 0,
    Q0Pu = 0,
    SNom = 250,
    Ti = 0.003428,
    U0Pu = 1,
    UBlock = 5,
    UNom = 225,
    URef0 = 225,
    URefDown = 220,
    URefUp = 230,
    UThresholdDown = 218,
    UThresholdUp = 240,
    UUnblockDown = 180,
    UUnblockUp = 270,
    i0Pu = Complex(0, 0),
    s0Pu = Complex(0, 0),
    tThresholdDown = 0,
    tThresholdUp = 60,
    u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-28, 20}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  sVarCStandard.injector.switchOffSignal1 = false;
  sVarCStandard.injector.switchOffSignal2 = false;
  sVarCStandard.injector.switchOffSignal3 = false;

  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{72, 20}, {102, 20}}, color = {0, 0, 255}));
  connect(sVarCStandard.terminal, line.terminal1) annotation(
    Line(points = {{0, 20}, {20, 20}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})));
end BaseSVarCTestCase;
