within Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model MeasurementsFiltered "Measurements block for PEIR models"

  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";
  parameter Types.Time tUqPLL "Filter time constant for voltage q measurement specially designed for the PLL in s";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -85}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -67}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)"annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 7}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 25}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 57}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 75}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PFilterPu(start = PFilter0Pu) "Active power at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QFilterPu(start = QFilter0Pu) "Reactive power at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilteredFilterPu(start = udFilteredPcc0Pu) "Filtered d-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilteredFilterPu(start = uqFilteredPcc0Pu) "Filtered q-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFilt, k = 1, y_start = UqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {1.33227e-15, -80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder( T = tUFilt,k = 1, y_start = UdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {1.33227e-15, -40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

Modelica.Blocks.Interfaces.RealOutput QPccPu(start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


  // Initial parameters
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at PCC in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at PCC in pu (base UNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the filter in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the filter in pu (base UNom)";

  final parameter Types.PerUnit PFilter0Pu = UdFilter0Pu * IdPcc0Pu + UqFilter0Pu * IqPcc0Pu "Start value of active power at the filter in pu (base SNom)";
  final parameter Types.PerUnit QFilter0Pu = UqFilter0Pu * IdPcc0Pu - UdFilter0Pu * IqPcc0Pu "Start value of reactive power at the filter in pu (base SNom)";
  final parameter Types.PerUnit udFilteredPcc0Pu = UdPcc0Pu;
  final parameter Types.PerUnit uqFilteredPcc0Pu = UqPcc0Pu;

  //Dynawo.Types.ReactivePowerPu QPccPu  "reactive power at the Pcc in pu (base SNom)";
  Dynawo.Types.VoltageModulePu UPccPu  "voltage module at the Pcc in pu (base UNom)";
 Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tUFilt, k = 1, y_start = UdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-8, 80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tUFilt, k = 1, y_start = UqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-12, 50}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput idFilteredPccPu(start = udFilteredPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {52, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Interfaces.RealOutput iqFilteredPccPu(start = uqFilteredPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-16, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Interfaces.RealInput iqConvPu(start = UqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-114, -146}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -21}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput idConvPu(start = UdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-112, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -39}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput idFilteredConvPu(start = PFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -116}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Interfaces.RealOutput iqFilteredConvPu(start = PFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -136}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-52, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tUFilt, k = 1, y_start = UdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-4, -116}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder5(T = tUFilt, k = 1, y_start = UdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-4, -152}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder6(T = tUqPLL, k = 1, y_start = UqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-6, -186}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput uq_PLLPu(start = uqFilteredPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {108, -186}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {52, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));  equation
  PFilterPu = udFilterPu * idConvPu + uqFilterPu * iqConvPu;
  QFilterPu = uqFilterPu * idConvPu - udFilterPu * iqConvPu;
  QPccPu    = uqPccPu * idPccPu - udPccPu * iqPccPu;
  UPccPu    = uqPccPu^2 + udPccPu^2;

  connect(firstOrder1.y, uqFilteredFilterPu) annotation(
    Line(points = {{8, -80}, {110, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, udFilteredFilterPu) annotation(
    Line(points = {{8.8, -40}, {110.8, -40}}, color = {0, 0, 127}));
 connect(idPccPu, firstOrder2.u) annotation(
    Line(points = {{-110, 80}, {-18, 80}}, color = {0, 0, 127}));
 connect(firstOrder2.y, idFilteredPccPu) annotation(
    Line(points = {{1, 80}, {54.5, 80}, {54.5, 82}, {110, 82}}, color = {0, 0, 127}));
 connect(iqPccPu, firstOrder3.u) annotation(
    Line(points = {{-110, 56}, {-22, 56}, {-22, 50}}, color = {0, 0, 127}));
 connect(firstOrder3.y, iqFilteredPccPu) annotation(
    Line(points = {{-4, 50}, {110, 50}, {110, 58}}, color = {0, 0, 127}));
 connect(udFilterPu, firstOrder.u) annotation(
    Line(points = {{-110, 16}, {-58, 16}, {-58, -40}, {-10, -40}}, color = {0, 0, 127}));
 connect(uqFilterPu, firstOrder1.u) annotation(
    Line(points = {{-110, -6}, {-70, -6}, {-70, -80}, {-10, -80}}, color = {0, 0, 127}));
 connect(firstOrder6.u, uqFilterPu) annotation(
    Line(points = {{-16, -186}, {-78, -186}, {-78, -6}, {-110, -6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
 connect(firstOrder6.y, uq_PLLPu) annotation(
    Line(points = {{2, -186}, {108, -186}}, color = {0, 0, 127}));
 connect(idConvPu, firstOrder4.u) annotation(
    Line(points = {{-112, -112}, {-18, -112}, {-18, -116}, {-14, -116}}, color = {0, 0, 127}));
 connect(firstOrder4.y, idFilteredConvPu) annotation(
    Line(points = {{4, -116}, {110, -116}}, color = {0, 0, 127}));
 connect(iqConvPu, firstOrder5.u) annotation(
    Line(points = {{-114, -146}, {-32, -146}, {-32, -152}, {-14, -152}}, color = {0, 0, 127}));
 connect(firstOrder5.y, iqFilteredConvPu) annotation(
    Line(points = {{4, -152}, {48, -152}, {48, -136}, {110, -136}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(extent = {{-120, 100}, {120, -200}})));
end MeasurementsFiltered;
