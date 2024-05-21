model test
//  extends Icons.Example;
//  parameter Types.ActivePowerPu PRefLoadPu = 11.25 "Active power request for the load in pu (base SnRef)";
//  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";
  
  
  Modelica.Blocks.Sources.Step PRef250Pu(height = 0, offset = 0.6238, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-71, 63}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv250(CFilter = 0.066, Cdc = 0.01, LFilter = 0.15, LTransformer = 0.2, RFilter = 0.005, RTransformer = 0.01, SNom = 250) annotation(
    Placement(visible = true, transformation(origin = {14, 29}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef250Pu(height = 0, offset = 1.0138, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-71, 29}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef250Pu(height = 0, offset = 1.0138, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-71, -5}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef250Pu(height = 0, offset = 0.6153, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-71, 12}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.GridFormingControlDroopControl Droop(CFilter = 0.066, IMaxVI = 1, Kff = 0.01, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, LFilter = 0.15, Mp = 0.02, Mq = 0, RFilter = 0.005, UFilterRef0Pu = 1, UdcSourcePu(fixed = true, start = 1.01369), Wf = 60, Wff = 16.66, XRratio = 5, currentLoop(integratord(y_start = 0.00323126), integratorq(y_start = -0.000164394)), droopControl(firstOrder(y_start = -7.3445e-5), firstOrder1(y_start = 0.102988), firstOrder2(y_start = 0.00622874), firstOrder3(y_start = -0.0010158), integrator(y_start = -0.0502873)), idConvPu(fixed = true, start = 0.622806), idPccPu(fixed = true, start = 0.622873), iqConvPu(fixed = true, start = -0.035099), iqPccPu(fixed = true, start = -0.101592), udFilterPu(fixed = true, start = 1.00755), uqFilterPu(fixed = true, start = 0.00101415)) annotation(
    Placement(visible = true, transformation(origin = {-34, 29}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef250Pu(height = 0, offset = 0.0769, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-71, 46}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line annotation(
    Placement(visible = true, transformation(origin = {28, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.6, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 2, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {82, -8}, extent = {{-18, -18}, {18, 18}}, rotation = -90)));
equation
  Conv250.switchOffSignal1.value = false;
  Conv250.switchOffSignal2.value = false;
  Conv250.switchOffSignal3.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line.switchOffSignal3.value = false;
//  loadAlphaBeta.PRefPu = 11.25;
//  loadAlphaBeta.QRefPu = 0;
//  loadAlphaBeta.deltaP = 0;
//  loadAlphaBeta.deltaQ = 0;
//  loadAlphaBeta.switchOffSignal1.value = false;
//  loadAlphaBeta.switchOffSignal2.value = false;
  connect(Conv250.idPccPu, Droop.idPccPu) annotation(
    Line(points = {{30, 38}, {39.75, 38}, {39.75, 47}, {-25.25, 47}, {-25.25, 45}}, color = {0, 0, 127}));
  connect(Conv250.PFilterPu, Droop.PFilterPu) annotation(
    Line(points = {{3.5, 13}, {3.5, 8.25}, {-23.5, 8.25}, {-23.5, 13.25}}, color = {0, 0, 127}));
  connect(PRef250Pu.y, Droop.PRefPu) annotation(
    Line(points = {{-65.5, 63}, {-57.5, 63}, {-57.5, 61}, {-51.5, 61}, {-51.5, 44}, {-50.5, 44}}, color = {0, 0, 127}));
  connect(Conv250.iqPccPu, Droop.iqPccPu) annotation(
    Line(points = {{30, 20}, {43.75, 20}, {43.75, 51}, {-43.25, 51}, {-43.25, 45}}, color = {0, 0, 127}));
  connect(Droop.udConvRefPu, Conv250.udConvRefPu) annotation(
    Line(points = {{-18.25, 35}, {-2, 35}}, color = {0, 0, 127}));
  connect(Droop.IdcSourcePu, Conv250.IdcSourcePu) annotation(
    Line(points = {{-18.25, 29}, {-2, 29}}, color = {0, 0, 127}));
  connect(Droop.uqConvRefPu, Conv250.uqConvRefPu) annotation(
    Line(points = {{-18.25, 23}, {-2, 23}}, color = {0, 0, 127}));
  connect(Droop.omegaPu, Conv250.omegaPu) annotation(
    Line(points = {{-18.25, 15.5}, {-2, 15.5}}, color = {0, 0, 127}));
  connect(UFilterRef250Pu.y, Droop.UFilterRefPu) annotation(
    Line(points = {{-65.5, 29}, {-50.5, 29}}, color = {0, 0, 127}));
  connect(QRef250Pu.y, Droop.QRefPu) annotation(
    Line(points = {{-65.5, 46}, {-56, 46}, {-56, 38}, {-50, 38}}, color = {0, 0, 127}));
  connect(UdcSourceRef250Pu.y, Droop.UdcSourceRefPu) annotation(
    Line(points = {{-65.5, -5}, {-55.5, -5}, {-55.5, 14}, {-50.5, 14}}, color = {0, 0, 127}));
  connect(Conv250.UdcSourcePu, Droop.UdcSourcePu) annotation(
    Line(points = {{30, 29}, {41.75, 29}, {41.75, 49}, {-34.25, 49}, {-34.25, 45}}, color = {0, 0, 127}));
  connect(IdcSourceRef250Pu.y, Droop.IdcSourceRefPu) annotation(
    Line(points = {{-65.5, 12}, {-56, 12}, {-56, 20}, {-50, 20}}, color = {0, 0, 127}));
  connect(Conv250.idConvPu, Droop.idConvPu) annotation(
    Line(points = {{30, 33.5}, {40.75, 33.5}, {40.75, 48}, {-29.25, 48}, {-29.25, 45}, {-29.75, 45}}, color = {0, 0, 127}));
  connect(Conv250.uqFilterPu, Droop.uqFilterPu) annotation(
    Line(points = {{30, 15.5}, {44.75, 15.5}, {44.75, 52}, {-48.25, 52}, {-48.25, 45}}, color = {0, 0, 127}));
  connect(Conv250.udFilterPu, Droop.udFilterPu) annotation(
    Line(points = {{30, 42.5}, {38.75, 42.5}, {38.75, 45}, {-21.25, 45}}, color = {0, 0, 127}));
  connect(Droop.theta, Conv250.theta) annotation(
    Line(points = {{-18.25, 42.5}, {-2, 42.5}}, color = {0, 0, 127}));
  connect(Conv250.QFilterPu, Droop.QFilterPu) annotation(
    Line(points = {{24.5, 13}, {24.5, 4.25}, {-45.5, 4.25}, {-45.5, 13.25}}, color = {0, 0, 127}));
  connect(Conv250.iqConvPu, Droop.iqConvPu) annotation(
    Line(points = {{30, 24.5}, {42.75, 24.5}, {42.75, 50}, {-39.25, 50}, {-39.25, 45}}, color = {0, 0, 127}));
  connect(Droop.UdcSourceRefOutPu, Conv250.UdcSourceRefPu) annotation(
    Line(points = {{-18.25, 18.5}, {-2, 18.5}}, color = {0, 0, 127}));
  connect(Conv250.terminal, line.terminal1) annotation(
    Line(points = {{14, 13}, {18, 13}, {18, -2}}, color = {0, 0, 255}));
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{38, -2}, {82, -2}, {82, -8}}, color = {0, 0, 255}));
  annotation(
    uses(Dynawo(version = "1.0.1"), Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-80, 80}, {100, -40}})),
    version = "");
end test;