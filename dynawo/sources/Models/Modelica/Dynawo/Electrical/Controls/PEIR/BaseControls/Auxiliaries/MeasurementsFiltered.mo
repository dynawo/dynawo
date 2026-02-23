within Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries;

model MeasurementsFiltered "Measurements block for PEIR models"
  parameter Types.Time tPQFilt "Filter time constant for voltage/current measurement that goes to the PQ calculation in s";
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";
  parameter Types.Time tUqPLL "Filter time constant for voltage q measurement specially designed for the PLL in s";
  // Inputs
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current at the converter in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, -260}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, 140}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current at the converter in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, -300}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -200}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {-112, -120}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -220}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}})));
  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idFilteredConvPu(start = IdConv0Pu) "Filtered d-axis current at the converter in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, -260}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput idFilteredPccPu(start = IdPcc0Pu) "Filtered d-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, 140}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput idFilteredPccPQCalculPu(start = IdPcc0Pu) "Filtered d-axis current at the PCC for PQ calculation in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, 180}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqFilteredConvPu(start = IqConv0Pu) "Filtered q-axis current at the converter in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, -300}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqFilteredPccPu(start = IqPcc0Pu) "Filtered q-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqFilteredPccPQCalculPu(start = IqPcc0Pu) "Filtered q-axis current at the PCC for PQ calculation in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PFilteredFilterPu(start = PFilter0Pu) "Active power at the filter in pu (base SNom)" annotation(
    Placement(transformation(origin = {110, -202}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QFilteredFilterPu(start = QFilter0Pu) "Reactive power at the filter in pu (base SNom)" annotation(
    Placement(transformation(origin = {110, -220}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QPccPu(start = QFilter0Pu) "Reactive power at the Pcc in pu (base SNom)" annotation(
    Placement(transformation(origin = {110, -242}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput udFilteredFilterPu(start = UdFilter0Pu) "Filtered d-axis voltage at the RLC filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput udFilteredFilterPQCalculPu(start = UdFilter0Pu) "Filtered d-axis voltage at the RLC filter for PQ calculation in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqFilteredFilterPu(start = UqFilter0Pu) "Filtered q-axis voltage at the RLC filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqFilteredFilterPQCalculPu(start = UqFilter0Pu) "Filtered q-axis voltage at the RLC filter for PQ calculation in pu (base UNom)"annotation(
    Placement(transformation(origin = {110, -120}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqFilteredFilterPLLPu(start = UqFilter0Pu) "Filtered q-axis voltage at the RLC filter for PLL in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -160}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Dynawo.Types.ReactivePowerPu QPccPu  "reactive power at the Pcc in pu (base SNom)";
  Dynawo.Types.VoltageModulePu UPccPu "voltage module at the Pcc in pu (base UNom)";

  //Blocks
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tUFilt, k = 1, y_start = IdPcc0Pu) annotation(
    Placement(transformation(origin = {-10, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tUFilt, k = 1, y_start = IqPcc0Pu) annotation(
    Placement(transformation(origin = {-10, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tUFilt, k = 1, y_start = IdConv0Pu) annotation(
    Placement(transformation(origin = {-10, -260}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder5(T = tUFilt, k = 1, y_start = IqConv0Pu) annotation(
    Placement(transformation(origin = {-10, -300}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder6(T = tUqPLL, k = 1, y_start = UqFilter0Pu) annotation(
    Placement(transformation(origin = {-10, -160}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFilt, k = 1, y_start = UqFilter0Pu) annotation(
    Placement(transformation(origin = {-10, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tUFilt, k = 1, y_start = UdFilter0Pu) annotation(
    Placement(transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder7(T = tPQFilt, y_start = IdPcc0Pu) annotation(
    Placement(transformation(origin = {-10, 180}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder8(T = tPQFilt, y_start = IqPcc0Pu) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder9(T = tPQFilt, y_start = UdFilter0Pu)  annotation(
    Placement(transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder10(T = tPQFilt, y_start = UqFilter0Pu)  annotation(
    Placement(transformation(origin = {-10, -120}, extent = {{-10, -10}, {10, 10}})));

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
  PFilteredFilterPu = udFilteredFilterPQCalculPu * idFilteredPccPQCalculPu + uqFilteredFilterPQCalculPu * iqFilteredPccPQCalculPu;
  QFilteredFilterPu = uqFilteredFilterPQCalculPu * idFilteredPccPQCalculPu - udFilteredFilterPQCalculPu * iqFilteredPccPQCalculPu;

  QPccPu = uqPccPu*idPccPu - udPccPu*iqPccPu;
  UPccPu = uqPccPu^2 + udPccPu^2;
  connect(firstOrder1.y, uqFilteredFilterPu) annotation(
    Line(points = {{1, -80}, {110, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, udFilteredFilterPu) annotation(
    Line(points = {{1, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(idPccPu, firstOrder2.u) annotation(
    Line(points = {{-110, 140}, {-22, 140}}, color = {0, 0, 127}));
  connect(firstOrder2.y, idFilteredPccPu) annotation(
    Line(points = {{1, 140}, {110, 140}}, color = {0, 0, 127}));
  connect(iqPccPu, firstOrder3.u) annotation(
    Line(points = {{-110, 100}, {-22, 100}}, color = {0, 0, 127}));
  connect(firstOrder3.y, iqFilteredPccPu) annotation(
    Line(points = {{1, 100}, {110, 100}}, color = {0, 0, 127}));
  connect(udFilterPu, firstOrder.u) annotation(
    Line(points = {{-110, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(uqFilterPu, firstOrder1.u) annotation(
    Line(points = {{-112, -120}, {-80, -120}, {-80, -80}, {-22, -80}}, color = {0, 0, 127}));
  connect(firstOrder6.u, uqFilterPu) annotation(
    Line(points = {{-22, -160}, {-80, -160}, {-80, -120}, {-112, -120}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(firstOrder6.y, uqFilteredFilterPLLPu) annotation(
    Line(points = {{1, -160}, {110, -160}}, color = {0, 0, 127}));
  connect(idConvPu, firstOrder4.u) annotation(
    Line(points = {{-110, -260}, {-22, -260}}, color = {0, 0, 127}));
  connect(firstOrder4.y, idFilteredConvPu) annotation(
    Line(points = {{1, -260}, {110, -260}}, color = {0, 0, 127}));
  connect(iqConvPu, firstOrder5.u) annotation(
    Line(points = {{-110, -300}, {-22, -300}}, color = {0, 0, 127}));
  connect(firstOrder5.y, iqFilteredConvPu) annotation(
    Line(points = {{1, -300}, {110, -300}}, color = {0, 0, 127}));
  connect(idPccPu, firstOrder7.u) annotation(
    Line(points = {{-110, 140}, {-80, 140}, {-80, 180}, {-22, 180}}, color = {0, 0, 127}));
  connect(firstOrder7.y, idFilteredPccPQCalculPu) annotation(
    Line(points = {{1, 180}, {110, 180}}, color = {0, 0, 127}));
  connect(iqPccPu, firstOrder8.u) annotation(
    Line(points = {{-110, 100}, {-80, 100}, {-80, 60}, {-22, 60}}, color = {0, 0, 127}));
  connect(firstOrder8.y, iqFilteredPccPQCalculPu) annotation(
    Line(points = {{2, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(uqFilterPu, firstOrder10.u) annotation(
    Line(points = {{-112, -120}, {-22, -120}}, color = {0, 0, 127}));
  connect(udFilterPu, firstOrder9.u) annotation(
    Line(points = {{-110, 0}, {-80, 0}, {-80, -40}, {-22, -40}}, color = {0, 0, 127}));
  connect(firstOrder9.y, udFilteredFilterPQCalculPu) annotation(
    Line(points = {{2, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(firstOrder10.y, uqFilteredFilterPQCalculPu) annotation(
    Line(points = {{2, -120}, {110, -120}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -300}, {100, 200}})));
end MeasurementsFiltered;
