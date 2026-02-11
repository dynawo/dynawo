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

  parameter Types.Time tUFilt "Filter time constant for voltage measurement that goes to the current control block in s";
  parameter Types.Time tUqPLL "Filter time constant for voltage q measurement specially designed for the PLL in s";
  parameter Types.Time tPQFilt "Filter time constant for voltage/current measurement that goes to the PQ calculation in s";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-122, 218}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -85}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -67}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)"annotation(
    Placement(visible = true, transformation(origin = {-128, -124}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 7}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-128, -156}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 25}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 57}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-122, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 75}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PFilterPu(start = PFilter0Pu) "Active power at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QFilterPu(start = QFilter0Pu) "Reactive power at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilteredFilterPu(start = UdFilter0Pu) "Filtered d-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilteredFilterPu(start = UqFilter0Pu) "Filtered q-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {144, -124}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFilt, k = 1, y_start = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {4, -114}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder( T = tUFilt,k = 1, y_start = UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {1, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

/*Modelica.Blocks.Interfaces.RealOutput QPccPu(start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));*/


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
 Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tUFilt, k = 1, y_start = IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 248}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tUFilt, k = 1, y_start = IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {3, 131}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput idFilteredPccPu(start = IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {134, 218}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {52, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Interfaces.RealOutput iqFilteredPccPu(start = IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 134}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {22, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-116, -284}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -21}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-112, -208}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -39}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput idFilteredConvPu(start = IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -212}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Interfaces.RealOutput iqFilteredConvPu(start = IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {144, -286}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-52, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tUFilt, k = 1, y_start = IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {6, -242}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder5(T = tUFilt, k = 1, y_start = IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {4, -300}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder6(T = tUqPLL, k = 1, y_start = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-7, -357}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput uq_PLLPu(start = uqFilteredPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {218, -356}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {52, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder7(T = tPQFilt, k = 1, y_start = IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-4, 192}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput idPccPQCalculPu(start = IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-42, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder8(T = tPQFilt, k = 1, y_start = IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {6, 64}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput iqPccPQCalculPu(start = IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {108, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-68, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Interfaces.RealOutput udFilterPQCalculPu(start = UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {114, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput uqFilterPQCalculPu(start = uqFilteredPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {148, -156}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder9(T = tPQFilt, k = 1, y_start = UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {7, -51}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder10(T = tPQFilt, k = 1, y_start = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {4, -172}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));  equation
  PFilterPu = udFilterPQCalculPu * idPccPQCalculPu + uqFilterPQCalculPu * iqPccPQCalculPu;
  QFilterPu = uqFilterPQCalculPu * idPccPQCalculPu - udFilterPQCalculPu * iqPccPQCalculPu;
 // QPccPu    = uqPccPu * idPccPu - udPccPu * iqPccPu;
  UPccPu    = uqPccPu^2 + udPccPu^2;
 connect(firstOrder1.y, uqFilteredFilterPu) annotation(
    Line(points = {{24, -114}, {82, -114}, {82, -124}, {144, -124}}, color = {0, 0, 127}));
 connect(firstOrder.y, udFilteredFilterPu) annotation(
    Line(points = {{17.5, 5}, {59.8, 5}, {59.8, -40}, {110.8, -40}}, color = {0, 0, 127}));
 connect(idPccPu, firstOrder2.u) annotation(
    Line(points = {{-122, 218}, {-72.5, 218}, {-72.5, 248}, {-19, 248}}, color = {0, 0, 127}));
 connect(firstOrder2.y, idFilteredPccPu) annotation(
    Line(points = {{17.6, 248}, {73.6, 248}, {73.6, 218}, {133.6, 218}}, color = {0, 0, 127}));
 connect(iqPccPu, firstOrder3.u) annotation(
    Line(points = {{-110, 132}, {-65, 132}, {-65, 131}, {-20, 131}}, color = {0, 0, 127}));
 connect(firstOrder3.y, iqFilteredPccPu) annotation(
    Line(points = {{24, 131}, {63.6, 131}, {63.6, 134}, {109.6, 134}}, color = {0, 0, 127}));
 connect(firstOrder6.u, uqFilterPu) annotation(
    Line(points = {{-25, -357}, {-78, -357}, {-78, -76}, {-122, -76}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
 connect(firstOrder6.y, uq_PLLPu) annotation(
    Line(points = {{9.5, -357}, {55, -357}, {55, -356}, {218, -356}}, color = {0, 0, 127}));
 connect(idConvPu, firstOrder4.u) annotation(
    Line(points = {{-112, -208}, {-18, -208}, {-18, -242}, {-16, -242}}, color = {0, 0, 127}));
 connect(firstOrder4.y, idFilteredConvPu) annotation(
    Line(points = {{26, -242}, {57.3, -242}, {57.3, -212}, {109.8, -212}}, color = {0, 0, 127}));
 connect(iqConvPu, firstOrder5.u) annotation(
    Line(points = {{-116, -284}, {-66.5, -284}, {-66.5, -300}, {-15, -300}}, color = {0, 0, 127}));
 connect(firstOrder5.y, iqFilteredConvPu) annotation(
    Line(points = {{22, -300}, {81.8, -300}, {81.8, -286}, {143.6, -286}}, color = {0, 0, 127}));
 connect(udFilterPu, firstOrder.u) annotation(
    Line(points = {{-110, 16}, {-30, 16}, {-30, 5}, {-17, 5}}, color = {0, 0, 127}));
 connect(uqFilterPu, firstOrder1.u) annotation(
    Line(points = {{-122, -76}, {-70, -76}, {-70, -114}, {-18, -114}}, color = {0, 0, 127}));
 connect(firstOrder7.u, idPccPu) annotation(
    Line(points = {{-23.2, 192}, {-121.2, 192}, {-121.2, 218}}, color = {0, 0, 127}));
 connect(firstOrder7.y, idPccPQCalculPu) annotation(
    Line(points = {{13.6, 192}, {57.6, 192}, {57.6, 186}, {129.6, 186}}, color = {0, 0, 127}));
 connect(firstOrder8.u, iqPccPu) annotation(
    Line(points = {{-14, 64}, {-110, 64}, {-110, 132}}, color = {0, 0, 127}));
 connect(firstOrder8.y, iqPccPQCalculPu) annotation(
    Line(points = {{24, 64}, {62, 64}, {62, 76}, {108, 76}}, color = {0, 0, 127}));
 connect(firstOrder9.u, udFilterPu) annotation(
    Line(points = {{-10, -50}, {-110, -50}, {-110, 16}}, color = {0, 0, 127}));
 connect(firstOrder9.y, udFilterPQCalculPu) annotation(
    Line(points = {{24, -50}, {46, -50}, {46, -76}, {114, -76}}, color = {0, 0, 127}));
 connect(firstOrder10.u, uqFilterPu) annotation(
    Line(points = {{-18, -172}, {-88, -172}, {-88, -76}, {-122, -76}}, color = {0, 0, 127}));
 connect(firstOrder10.y, uqFilterPQCalculPu) annotation(
    Line(points = {{24, -172}, {66, -172}, {66, -156}, {148, -156}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(extent = {{-140, 280}, {240, -380}})));
end MeasurementsFiltered;
