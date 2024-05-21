within Dynawo.Examples.GridForming;

model TestGridv2
  parameter Types.ActivePowerPu PRefLoadPu = 0.1 "Active power request for the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";
  Electrical.Lines.Line line(BPu = 0.00003, GPu = 0, RPu = 0.005, XPu = 0.5) annotation(
    Placement(visible = true, transformation(origin = {104, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.GridForming.AcGrid acGrid(SNom = SystemBase.SnRef * 1) annotation(
    Placement(visible = true, transformation(origin = {-132, -4}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ loadPQ annotation(
    Placement(visible = true, transformation(origin = {145, -29}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0, offset = 1) annotation(
    Placement(visible = true, transformation(origin = {-196, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GridForming_test_4_v2_Syncr_v3 gridForming_test_4_v2_Syncr_v3( Fsw = 1000,SNom = SystemBase.SnRef * 2, Wref_FromPLL = true) annotation(
    Placement(visible = true, transformation(origin = {-51, 75}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(height = 0.2, offset = 0.8, startTime = 15) annotation(
    Placement(visible = true, transformation(origin = {-214, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0, offset = 0.3) annotation(
    Placement(visible = true, transformation(origin = {-174, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));




equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  loadPQ.switchOffSignal1.value = false;
  loadPQ.switchOffSignal2.value = false;
  loadPQ.deltaQ = 0;
  loadPQ.deltaP = 0;
  loadPQ.PRefPu = PRefLoadPu;
  loadPQ.QRefPu = QRefLoadPu;
  connect(line.terminal1, acGrid.aCPower) annotation(
    Line(points = {{94, 12}, {-104, 12}, {-104, 13}}, color = {0, 0, 255}));
  connect(step2.y, gridForming_test_4_v2_Syncr_v3.UFilterRefPu) annotation(
    Line(points = {{-185, 132}, {-170, 132}, {-170, 84}, {-84, 84}}, color = {0, 0, 127}));
  connect(step3.y, gridForming_test_4_v2_Syncr_v3.PrefPu) annotation(
    Line(points = {{-203, 98}, {-184, 98}, {-184, 72}, {-84, 72}}, color = {0, 0, 127}));
  connect(step1.y, gridForming_test_4_v2_Syncr_v3.QrefPu) annotation(
    Line(points = {{-163, 164}, {-158, 164}, {-158, 98}, {-84, 98}}, color = {0, 0, 127}));
  connect(gridForming_test_4_v2_Syncr_v3.PCC, line.terminal2) annotation(
    Line(points = {{-16, 78}, {114, 78}, {114, 12}}, color = {0, 0, 255}));
  connect(loadPQ.terminal, line.terminal1) annotation(
    Line(points = {{146, -28}, {94, -28}, {94, 12}}, color = {0, 0, 255}));
  connect(acGrid.omegaPu, gridForming_test_4_v2_Syncr_v3.OmegaRefPu) annotation(
    Line(points = {{-105, -18}, {-50, -18}, {-50, -70}, {-202, -70}, {-202, 60}, {-84, 60}}, color = {0, 0, 127}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-280, 180}, {260, -80}})),
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.001));
end TestGridv2;