within Dynawo.Examples.GridForming;

model TestDynGFMConverter
  Dynawo.Electrical.Sources.PEIR.Converters.Average.DynConverter2 dynConverter2(SNom = 1000, CFilterPu = 1e-05, LFilterPu = 0.15, LTransformerPu = 0.06, RFilterPu = 0.015, RTransformerPu = 0.006, Theta0 = 0.082, u0Pu = Complex(0.997, 0.0373), i0Pu = Complex(-7.457, -0.691), tVSC = 0.01, Omega0Pu = SystemBase.omegaRef0Pu)  annotation(
    Placement(transformation(origin = {5, -1}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Blocks.Sources.Constant omegaPu(k = 1.05)  annotation(
    Placement(transformation(origin = {-26, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant theta(k = 0.082)  annotation(
    Placement(transformation(origin = {4, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant udConvRefPu(k = 1.01)  annotation(
    Placement(transformation(origin = {-46, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant uqConvRefPu(k = 0.112)  annotation(
    Placement(transformation(origin = {-44, -32}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = dynConverter2.transformRItoDQIPcc.ud0, IqPcc0Pu = dynConverter2.transformRItoDQIPcc.uq0, UdFilter0Pu = dynConverter2.transformRItoDQFilter.ud0, UdPcc0Pu = dynConverter2.transformRItoDQUPcc.ud0, UqFilter0Pu = dynConverter2.transformRItoDQFilter.uq0, UqPcc0Pu = dynConverter2.transformRItoDQUPcc.uq0, tUFilt = 0.01) annotation(
    Placement(transformation(origin = {-62, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.88, tOmegaEvtEnd = 6, tOmegaEvtStart = 5, tUEvtEnd = 4, tUEvtStart = 3) annotation(
    Placement(transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005) annotation(
    Placement(transformation(origin = {58, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(udConvRefPu.y, dynConverter2.udConvRefPu) annotation(
    Line(points = {{-34, 6}, {-16, 6}}, color = {0, 0, 127}));
  connect(uqConvRefPu.y, dynConverter2.uqConvRefPu) annotation(
    Line(points = {{-33, -32}, {-33, -8}, {-16, -8}}, color = {0, 0, 127}));
  connect(omegaPu.y, dynConverter2.omegaPu) annotation(
    Line(points = {{-14, 34}, {-4, 34}, {-4, 20}}, color = {0, 0, 127}));
  connect(theta.y, dynConverter2.theta) annotation(
    Line(points = {{16, 50}, {14, 50}, {14, 20}}, color = {0, 0, 127}));
  connect(dynConverter2.idPccPu, Measurements.idPccPu) annotation(
    Line(points = {{-12, -22}, {-12, -56}, {-40, -56}}, color = {0, 0, 127}));
  connect(dynConverter2.iqPccPu, Measurements.iqPccPu) annotation(
    Line(points = {{-8, -22}, {-8, -60}, {-40, -60}}, color = {0, 0, 127}));
  connect(dynConverter2.udPccPu, Measurements.udPccPu) annotation(
    Line(points = {{-2, -22}, {-2, -70}, {-40, -70}}, color = {0, 0, 127}));
  connect(dynConverter2.uqPccPu, Measurements.uqPccPu) annotation(
    Line(points = {{2, -22}, {0, -22}, {0, -74}, {-40, -74}}, color = {0, 0, 127}));
  connect(dynConverter2.udFilterPu, Measurements.udFilterPu) annotation(
    Line(points = {{8, -22}, {6, -22}, {6, -84}, {-40, -84}}, color = {0, 0, 127}));
  connect(dynConverter2.uqFilterPu, Measurements.uqFilterPu) annotation(
    Line(points = {{12, -22}, {10, -22}, {10, -86}, {-40, -86}}, color = {0, 0, 127}));
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{68, 0}, {82, 0}}, color = {0, 0, 255}));
  connect(dynConverter2.terminal, line.terminal1) annotation(
    Line(points = {{26, 0}, {48, 0}}, color = {0, 0, 255}));
  annotation(
    uses(Dynawo(version = "1.8.0"), Modelica(version = "3.2.3")),
  experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.004));
end TestDynGFMConverter;
