within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls;

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

model QSEM "Quasi-Static Electrical Model"

  parameter Real RFilter "Filter resistance in pu (base UNom, SNom)";
  parameter Real XFilter "Filter impedance in pu (base UNom, SNom)";
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control";

  Modelica.Blocks.Interfaces.RealInput udFilteredPCCPu(start = UdPcc0Pu) "Filtered d-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-30.5, -109.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterRefPu(start = UdFilter0Pu) "d-axis voltage reference after the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-109, 41}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterRefPu(start = UqFilter0Pu) "q-axis voltage reference after the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilteredPCCPu(start = UqPcc0Pu) "Filtered q-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {29, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";

equation
  [idConvRefPu; iqConvRefPu] = 1/(RFilter^2 + (XFilter + XVI)^2)*[RFilter, XFilter + XVI; -(XFilter + XVI), RFilter] * [udFilterRefPu-udFilteredPCCPu; uqFilterRefPu-uqFilteredPCCPu];

annotation(preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1})));
end QSEM;
