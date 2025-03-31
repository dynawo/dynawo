within Dynawo.Examples.GridForming;

model ENTSOE_DynVcGFMVSM

  parameter Types.Time tOmegaEvtStart = 10;
  parameter Types.Time tOmegaEvtEnd = 10.0001;
  parameter Types.Time tMagnitudeEvtstart = 20;
  parameter Types.Time tMagnitudeEvtEnd = 20 + 3;
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.88, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005)  annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1.01726) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.25, offset = 0.75, startTime = 5)  annotation(
    Placement(visible = true, transformation(origin = {-112, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynVcGFMVSM dynVcGFMVSM(CFilterPu = 1e-5, H = 3, IMaxVI = 1.2, Kff = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaSetPu = 1, P0Pu = -7.4663, Q0Pu = 0.4119, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9984, UPhase0 = 0.0374, Wf = 31.4159, Wff = 60, XRratio = 10, kVSM = 155.955, tVSC = 0.0004) annotation(
    Placement(visible = true, transformation(origin = {-21, -1}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
 connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{54, 0}, {82, 0}}, color = {0, 0, 255}));
 connect(dynVcGFMVSM.terminal, line.terminal1) annotation(
    Line(points = {{-2, 0}, {34, 0}}, color = {0, 0, 255}));
 connect(dynVcGFMVSM.PFilterRefPu, PRefPu.y) annotation(
    Line(points = {{-40, 12}, {-52, 12}, {-52, 60}, {-100, 60}}, color = {0, 0, 127}));
 connect(dynVcGFMVSM.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{-40, 6}, {-80, 6}, {-80, 20}, {-100, 20}}, color = {0, 0, 127}));
 connect(dynVcGFMVSM.QFilterRefPu, QRefPu.y) annotation(
    Line(points = {{-40, -8}, {-80, -8}, {-80, -20}, {-101, -20}}, color = {0, 0, 127}));
 connect(URefPu.y, dynVcGFMVSM.UConvRefPu) annotation(
    Line(points = {{-100, -60}, {-60, -60}, {-60, -14}, {-40, -14}}, color = {0, 0, 127}));
end ENTSOE_DynVcGFMVSM;
