within Dynawo.Examples.GridForming;

model TestDynConverter1
  Dynawo.Electrical.Sources.PEIR.Converters.Average.DynConverter1 dynConverter1(SNom = 1000, tVSC = 0.01, RFilterPu = 0.015, LFilterPu = 0.15, CFilterPu = 1e-05, RTransformerPu = 0.006, LTransformerPu = 0.06, i0Pu = Complex(-7.457, -0.691), u0Pu = Complex(0.997, 0.0373), Omega0Pu = SystemBase.omegaRef0Pu, Theta0 = 0.082) annotation(
    Placement(transformation(origin = {-4, -6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaPu(k = 1.05) annotation(
    Placement(transformation(origin = {-26, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant theta(k = 0.082) annotation(
    Placement(transformation(origin = {4, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant udConvRefPu(k = 1.01) annotation(
    Placement(transformation(origin = {-46, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant uqConvRefPu(k = 0.112) annotation(
    Placement(transformation(origin = {-46, -22}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = dynConverter1.refFrameRotation.IdPcc0Pu, IqPcc0Pu = dynConverter1.refFrameRotation.IqPcc0Pu, UdFilter0Pu = dynConverter1.RLTransformer.UdFilter0Pu, UdPcc0Pu = dynConverter1.refFrameRotation.UdPcc0Pu, UqFilter0Pu = dynConverter1.RLTransformer.UqFilter0Pu, UqPcc0Pu = dynConverter1.refFrameRotation.UqPcc0Pu, tUFilt = 0.01) annotation(
    Placement(transformation(origin = {-66, -68}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.88, tOmegaEvtEnd = 6, tOmegaEvtStart = 5, tUEvtEnd = 4, tUEvtStart = 3) annotation(
    Placement(transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005) annotation(
    Placement(transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(uqConvRefPu.y, dynConverter1.uqConvRefPu) annotation(
    Line(points = {{-34, -22}, {-14, -22}, {-14, -10}}, color = {0, 0, 127}));
  connect(udConvRefPu.y, dynConverter1.udConvRefPu) annotation(
    Line(points = {{-34, 6}, {-14, 6}, {-14, -2}}, color = {0, 0, 127}));
  connect(omegaPu.y, dynConverter1.omegaPu) annotation(
    Line(points = {{-14, 34}, {-8, 34}, {-8, 6}}, color = {0, 0, 127}));
  connect(theta.y, dynConverter1.theta) annotation(
    Line(points = {{16, 50}, {2, 50}, {2, 6}}, color = {0, 0, 127}));
  connect(dynConverter1.idPccPu, Measurements.idPccPu) annotation(
    Line(points = {{-12, -16}, {-14, -16}, {-14, -52}, {-44, -52}}, color = {0, 0, 127}));
  connect(dynConverter1.iqPccPu, Measurements.iqPccPu) annotation(
    Line(points = {{-10, -16}, {-12, -16}, {-12, -56}, {-44, -56}}, color = {0, 0, 127}));
  connect(dynConverter1.udPccPu, Measurements.udPccPu) annotation(
    Line(points = {{-8, -16}, {-6, -16}, {-6, -66}, {-44, -66}}, color = {0, 0, 127}));
  connect(dynConverter1.uqPccPu, Measurements.uqPccPu) annotation(
    Line(points = {{-6, -16}, {-4, -16}, {-4, -70}, {-44, -70}}, color = {0, 0, 127}));
  connect(dynConverter1.udFilterPu, Measurements.udFilterPu) annotation(
    Line(points = {{-2, -16}, {-2, -80}, {-44, -80}}, color = {0, 0, 127}));
  connect(dynConverter1.uqFilterPu, Measurements.uqFilterPu) annotation(
    Line(points = {{0, -16}, {0, -82}, {-44, -82}}, color = {0, 0, 127}));
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{54, 0}, {82, 0}}, color = {0, 0, 255}));
  connect(dynConverter1.terminal, line.terminal1) annotation(
    Line(points = {{8, -6}, {28, -6}, {28, 0}, {34, 0}}, color = {0, 0, 255}));
  annotation(
    uses(Dynawo(version = "1.8.0")),
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.004),
    Diagram);
end TestDynConverter1;
