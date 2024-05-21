within Dynawo.Examples.GridForming;

model TestGridv3
  Dynawo.Electrical.Lines.Line line(BPu = 0.00003, GPu = 0, RPu = 0.005, XPu = 0.5) annotation(
    Placement(visible = true, transformation(origin = {106, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step4(height = 1) annotation(
    Placement(visible = true, transformation(origin = {-234, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(height = 0.2, offset = 0.8, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {-214, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0.96) annotation(
    Placement(visible = true, transformation(origin = {-196, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.3) annotation(
    Placement(visible = true, transformation(origin = {-174, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GridForming_test_4_v2_Syncr_v3 gridForming_test_4_v2_Syncr_v3(SNom = SystemBase.SnRef * 3) annotation(
    Placement(visible = true, transformation(origin = {-51, 75}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 1, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.1, tOmegaEvtEnd = 10, tOmegaEvtStart = 5, tUEvtEnd = 101, tUEvtStart = 101)  annotation(
    Placement(visible = true, transformation(origin = {216, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll1(KiPLL = 795, KpPLL = 3, u0Pu = Complex(1, 0))  annotation(
    Placement(visible = true, transformation(origin = {298, 172}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
  Dynawo.Examples.GridForming.MeasurementPcc measurementPcc annotation(
    Placement(visible = true, transformation(origin = {401.444, 47}, extent = {{-49.4444, -89}, {49.4444, 89}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0) annotation(
    Placement(visible = true, transformation(origin = {208, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(step2.y, gridForming_test_4_v2_Syncr_v3.UFilterRefPu) annotation(
    Line(points = {{-185, 132}, {-170, 132}, {-170, 84}, {-84, 84}}, color = {0, 0, 127}));
  connect(step3.y, gridForming_test_4_v2_Syncr_v3.PrefPu) annotation(
    Line(points = {{-203, 98}, {-184, 98}, {-184, 72}, {-84, 72}}, color = {0, 0, 127}));
  connect(step1.y, gridForming_test_4_v2_Syncr_v3.QrefPu) annotation(
    Line(points = {{-163, 164}, {-158, 164}, {-158, 98}, {-84, 98}}, color = {0, 0, 127}));
  connect(step4.y, gridForming_test_4_v2_Syncr_v3.OmegaRefPu) annotation(
    Line(points = {{-223, 58}, {-85, 58}}, color = {0, 0, 127}));
  connect(gridForming_test_4_v2_Syncr_v3.PCC, line.terminal2) annotation(
    Line(points = {{-16, 78}, {132, 78}, {132, 6}, {116, 6}}, color = {0, 0, 255}));
  connect(line.terminal1, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{96, 6}, {78, 6}, {78, -30}, {216, -30}, {216, 32}}, color = {0, 0, 255}));
  connect(step4.y, pll1.omegaRefPu) annotation(
    Line(points = {{-222, 58}, {-190, 58}, {-190, 0}, {-114, 0}, {-114, 156}, {268, 156}}, color = {0, 0, 127}));
  connect(measurementPcc.terminal, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{366, -46}, {216, -46}, {216, 32}}, color = {0, 0, 255}));
   connect(step.y, measurementPcc.idPccPu) annotation(
    Line(points = {{220, 112}, {276, 112}, {276, 52}, {348, 52}}, color = {0, 0, 127}));
  connect(step.y, measurementPcc.iqPccPu) annotation(
    Line(points = {{220, 112}, {256, 112}, {256, 26}, {348, 26}}, color = {0, 0, 127}));
  connect(pll1.phi, measurementPcc.theta) annotation(
    Line(points = {{328, 174}, {402, 174}, {402, 142}}, color = {0, 0, 127}));
  connect(measurementPcc.uComplexPu, pll1.uPu) annotation(
    Line(points = {{444, -46}, {446, -46}, {446, -70}, {516, -70}, {516, 208}, {234, 208}, {234, 188}, {268, 188}}, color = {85, 170, 255}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-260, 240}, {500, -80}})),
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.001));
end TestGridv3;