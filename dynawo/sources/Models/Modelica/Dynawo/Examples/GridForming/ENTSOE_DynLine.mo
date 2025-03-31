within Dynawo.Examples.GridForming;

model ENTSOE_DynLine

  parameter Types.Time tOmegaEvtStart = 10;
  parameter Types.Time tOmegaEvtEnd = 10.0001;
  parameter Types.Time tMagnitudeEvtstart = 20;
  parameter Types.Time tMagnitudeEvtEnd = 20 + 3;

  Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = -7.4663, Q0Pu = 0.4119, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9984, UPhase0 = 0.0374, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0, kVSM = 155.955, OmegaSetPu = 1, tVSC = 0.0004)  annotation(
    Placement(visible = true, transformation(origin = {-9, -1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.88, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.25, offset = 0.75, startTime = 5)  annotation(
    Placement(visible = true, transformation(origin = {-112, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.DynLine dynLine(LPu = 0.005, RPu = 0.000166667, U01Pu = 0.9984, UPhase01 = 0.0374, P01Pu = 7.4663, Q01Pu = -0.4119, U02Pu = 1, UPhase02 = 0, P02Pu = -7.457, Q02Pu = 0.692)  annotation(
    Placement(visible = true, transformation(origin = {42, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  dynLine.switchOffSignal1.value = false;
  dynLine.switchOffSignal2.value = false;
  dynLine.omegaPu.value = 1;

  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{-101, 20}, {-65.5, 20}, {-65.5, 6}, {-30, 6}}, color = {0, 0, 127}));
  connect(PRefPu.y, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{-101, 60}, {-40, 60}, {-40, 14}, {-30, 14}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-66, -20}, {-66, -8}, {-30, -8}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMVSM.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-40, -60}, {-40, -16}, {-30, -16}}, color = {0, 0, 127}));
  connect(DynGFMVSM.terminal, dynLine.terminal1) annotation(
    Line(points = {{12, 0}, {32, 0}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{52, 0}, {82, 0}}, color = {0, 0, 255}));
end ENTSOE_DynLine;
