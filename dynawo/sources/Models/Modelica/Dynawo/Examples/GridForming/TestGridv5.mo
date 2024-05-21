within Dynawo.Examples.GridForming;

model TestGridv5
  parameter Types.ActivePowerPu PRefLoadPu = 1 "Active power request for the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";
  Electrical.Lines.Line line(BPu = 0.00003, GPu = 0, RPu = 0.005, XPu = 0.5) annotation(
    Placement(visible = true, transformation(origin = {104, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ loadPQ annotation(
    Placement(visible = true, transformation(origin = {145, -29}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0.96) annotation(
    Placement(visible = true, transformation(origin = {-212, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GridForming_test_4_v2_Syncr_v3 gridForming_test_4_v2_Syncr_v3(Fsw = 1000, SNom = SystemBase.SnRef * 10) annotation(
    Placement(visible = true, transformation(origin = {-51, 75}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(height = 1) annotation(
    Placement(visible = true, transformation(origin = {-214, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step4(height = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-216, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.3) annotation(
    Placement(visible = true, transformation(origin = {-210, 168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  loadPQ.switchOffSignal1.value = false;
  loadPQ.switchOffSignal2.value = false;
  loadPQ.deltaQ = 0;
  loadPQ.deltaP = 0;
  loadPQ.PRefPu = PRefLoadPu;
  loadPQ.QRefPu = QRefLoadPu;
  connect(step2.y, gridForming_test_4_v2_Syncr_v3.UFilterRefPu) annotation(
    Line(points = {{-201, 132}, {-170, 132}, {-170, 84}, {-84, 84}}, color = {0, 0, 127}));
   connect(step3.y, gridForming_test_4_v2_Syncr_v3.PrefPu) annotation(
    Line(points = {{-203, 98}, {-184, 98}, {-184, 72}, {-84, 72}}, color = {0, 0, 127}));
  connect(step1.y, gridForming_test_4_v2_Syncr_v3.QrefPu) annotation(
    Line(points = {{-199, 168}, {-158, 168}, {-158, 98}, {-84, 98}}, color = {0, 0, 127}));
  connect(step4.y, gridForming_test_4_v2_Syncr_v3.OmegaRefPu) annotation(
    Line(points = {{-205, 54}, {-154, 54}, {-154, 58}, {-85, 58}}, color = {0, 0, 127}));
  connect(gridForming_test_4_v2_Syncr_v3.PCC, line.terminal2) annotation(
    Line(points = {{-16, 78}, {114, 78}, {114, 12}}, color = {0, 0, 255}));
  connect(loadPQ.terminal, line.terminal1) annotation(
    Line(points = {{146, -28}, {94, -28}, {94, 12}}, color = {0, 0, 255}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-280, 180}, {260, -80}})),
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.06));
end TestGridv5;