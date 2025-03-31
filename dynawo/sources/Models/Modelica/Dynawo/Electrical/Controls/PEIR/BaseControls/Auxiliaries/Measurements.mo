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

model Measurements "Measurements block for PEIR models"

  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -79}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -59}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)"annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -9}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 9}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 57}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 75}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PFilterPu(start = PFilter0Pu) "Active power at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QFilterPu(start = QFilter0Pu) "Reactive power at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilteredPccPu(start = UdPcc0Pu) "Filtered d-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilteredPccPu(start = UqPcc0Pu) "Filtered q-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFilt, k = 1, y_start = UqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {1.33227e-15, -80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder( T = tUFilt,k = 1, y_start = UdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {1.33227e-15, -40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at PCC in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at PCC in pu (base UNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the filter in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the filter in pu (base UNom)";

  final parameter Types.PerUnit PFilter0Pu = UdFilter0Pu * IdPcc0Pu + UqFilter0Pu * IqPcc0Pu "Start value of active power at the filter in pu (base SNom)";
  final parameter Types.PerUnit QFilter0Pu = UqFilter0Pu * IdPcc0Pu - UdFilter0Pu * IqPcc0Pu "Start value of reactive power at the filter in pu (base SNom)";

equation
  PFilterPu = udFilterPu * idPccPu + uqFilterPu * iqPccPu;
  QFilterPu = uqFilterPu * idPccPu - udFilterPu * iqPccPu;

  connect(firstOrder1.y, uqFilteredPccPu) annotation(
    Line(points = {{8, -80}, {110, -80}}, color = {0, 0, 127}));
  connect(uqPccPu, firstOrder1.u) annotation(
    Line(points = {{-110, -80}, {-10, -80}}, color = {0, 0, 127}));
  connect(udPccPu, firstOrder.u) annotation(
    Line(points = {{-110, -40}, {-10, -40}}, color = {0, 0, 127}));
  connect(firstOrder.y, udFilteredPccPu) annotation(
    Line(points = {{8.8, -40}, {110.8, -40}}, color = {0, 0, 127}));

end Measurements;
