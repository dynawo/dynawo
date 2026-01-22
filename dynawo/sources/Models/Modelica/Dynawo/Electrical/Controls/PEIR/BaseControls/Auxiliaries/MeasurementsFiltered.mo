within Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries;

model MeasurementsFiltered "Measurements block for PEIR models"

  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";
  parameter Types.Time tUqPLL "Filter time constant for voltage q measurement specially designed for the PLL in s";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current at the converter in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, -160}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current at the converter in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, -180}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -120}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idFilteredConvPu(start = IdConv0Pu) "Filtered d-axis current at the converter in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, -160}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput idFilteredPccPu(start = IdPcc0Pu) "Filtered d-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqFilteredConvPu(start = IqConv0Pu) "Filtered q-axis current at the converter in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, -180}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqFilteredPccPu(start = IqPcc0Pu) "Filtered q-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput PFilterPu(start = PFilter0Pu) "Active power at the filter in pu (base SNom)" annotation(
    Placement(transformation(origin = {110, -82}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QFilterPu(start = QFilter0Pu) "Reactive power at the filter in pu (base SNom)" annotation(
    Placement(transformation(origin = {110, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QPccPu(start = QFilter0Pu) "Reactive power at the Pcc in pu (base SNom)" annotation(
    Placement(transformation(origin = {110, -122}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput udFilteredFilterPu(start = UdFilter0Pu) "Filtered d-axis voltage at the RLC filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqFilteredFilterPu(start = UqFilter0Pu) "Filtered q-axis voltage at the RLC filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqFilteredPLLPu(start = UqFilter0Pu) "Filtered q-axis voltage at the filter for PLL in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Dynawo.Types.ReactivePowerPu QPccPu  "reactive power at the Pcc in pu (base SNom)";
  Dynawo.Types.VoltageModulePu UPccPu "voltage module at the Pcc in pu (base UNom)";

  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tUFilt, k = 1, y_start = IdPcc0Pu) annotation(
    Placement(transformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tUFilt, k = 1, y_start = IqPcc0Pu) annotation(
    Placement(transformation(origin = {-10, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tUFilt, k = 1, y_start = IdConv0Pu) annotation(
    Placement(transformation(origin = {-10, -150}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder5(T = tUFilt, k = 1, y_start = IqConv0Pu) annotation(
    Placement(transformation(origin = {-10, -190}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder6(T = tUqPLL, k = 1, y_start = UqFilter0Pu) annotation(
    Placement(transformation(origin = {-10, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFilt, k = 1, y_start = UqFilter0Pu) annotation(
    Placement(transformation(origin = {-10, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tUFilt, k = 1, y_start = UdFilter0Pu) annotation(
    Placement(transformation(origin = {-10, 10}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current at the converter in pu (base UNom, SNom) in generator convention";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current at the converter in pu (base UNom, SNom) in generator convention";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the filter in pu (base UNom)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at PCC in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the filter in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at PCC in pu (base UNom)";

  final parameter Types.PerUnit PFilter0Pu = UdFilter0Pu*IdPcc0Pu + UqFilter0Pu*IqPcc0Pu "Start value of active power at the filter in pu (base SNom)";
  final parameter Types.PerUnit QFilter0Pu = UqFilter0Pu*IdPcc0Pu - UdFilter0Pu*IqPcc0Pu "Start value of reactive power at the filter in pu (base SNom)";
  final parameter Types.PerUnit udFilteredPcc0Pu = UdPcc0Pu;
  final parameter Types.PerUnit uqFilteredPcc0Pu = UqPcc0Pu;

equation
  PFilterPu = udFilterPu*idPccPu + uqFilterPu*iqPccPu;
  QFilterPu = uqFilterPu*idPccPu - udFilterPu*iqPccPu;
  QPccPu = uqPccPu*idPccPu - udPccPu*iqPccPu;
  UPccPu = uqPccPu^2 + udPccPu^2;

  connect(firstOrder1.y, uqFilteredFilterPu) annotation(
    Line(points = {{1, -30}, {40.5, -30}, {40.5, -20}, {110, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, udFilteredFilterPu) annotation(
    Line(points = {{1, 10}, {39.5, 10}, {39.5, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(idPccPu, firstOrder2.u) annotation(
    Line(points = {{-110, 80}, {-60, 80}, {-60, 90}, {-22, 90}}, color = {0, 0, 127}));
  connect(firstOrder2.y, idFilteredPccPu) annotation(
    Line(points = {{1, 90}, {39.5, 90}, {39.5, 80}, {110, 80}}, color = {0, 0, 127}));
  connect(iqPccPu, firstOrder3.u) annotation(
    Line(points = {{-110, 60}, {-60, 60}, {-60, 50}, {-22, 50}}, color = {0, 0, 127}));
  connect(firstOrder3.y, iqFilteredPccPu) annotation(
    Line(points = {{1, 50}, {39.5, 50}, {39.5, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(udFilterPu, firstOrder.u) annotation(
    Line(points = {{-110, 0}, {-60, 0}, {-60, 10}, {-22, 10}}, color = {0, 0, 127}));
  connect(uqFilterPu, firstOrder1.u) annotation(
    Line(points = {{-110, -20}, {-60, -20}, {-60, -30}, {-22, -30}}, color = {0, 0, 127}));
  connect(firstOrder6.u, uqFilterPu) annotation(
    Line(points = {{-22, -70}, {-80, -70}, {-80, -20}, {-110, -20}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(firstOrder6.y, uqFilteredPLLPu) annotation(
    Line(points = {{1, -70}, {39.5, -70}, {39.5, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(idConvPu, firstOrder4.u) annotation(
    Line(points = {{-110, -160}, {-62, -160}, {-62, -150}, {-22, -150}}, color = {0, 0, 127}));
  connect(firstOrder4.y, idFilteredConvPu) annotation(
    Line(points = {{1, -150}, {39, -150}, {39, -160}, {110, -160}}, color = {0, 0, 127}));
  connect(iqConvPu, firstOrder5.u) annotation(
    Line(points = {{-110, -180}, {-60, -180}, {-60, -190}, {-22, -190}}, color = {0, 0, 127}));
  connect(firstOrder5.y, iqFilteredConvPu) annotation(
    Line(points = {{1, -190}, {40, -190}, {40, -180}, {110, -180}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 100}})));
end MeasurementsFiltered;
