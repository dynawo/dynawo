within Dynawo.Electrical.Controls.Converters.InnerControls;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model VCQSEM
  import Modelica.Constants.pi;

  parameter Real RFilter "Filter resistance in pu (base UNom, SNom)";
  parameter Real LFilter "Filter inductance in pu (base UNom, SNom)";
  parameter Real Wqsem "Bande passante du filtre QSEM";
  parameter Real Lv_QSEM "virtual impedance added to the QSEM directly";

  final parameter Types.Frequency fNom = 50 "System AC frequency Hz";
  final parameter Types.AngularVelocity Wn  = 2 * pi * fNom  "nominal angular frequency rad/s";

  Types.PerUnit alpha;
  Types.PerUnit beta;
  Types.PerUnit udFiltMeasPu(start = udFilter0Pu) "The d-axis voltage at the inverter bridge output in pu (base UNom, SNom)";
  Types.PerUnit uqFiltMeasPu(start = uqFilter0Pu) "The d-axis voltage at the inverter bridge output in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput omegaPu annotation(
    Placement(visible = true, transformation(origin = {-240, 12}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {10, 190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterRefPu(start = uqFilterRef0Pu) "q-axis voltage reference after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-109, 105}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterRefPu(start = udFilterRef0Pu) "d-axis voltage reference after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 94}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = udFilter0Pu) "d-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = uqFilter0Pu) "q-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -150}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = idConvRef0Pu) "d-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {150, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = iqConvRef0Pu) "q-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {152, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit udFilterRef0Pu "Start value of the d-axis voltage reference after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit uqFilterRef0Pu "Start value of the q-axis voltage reference after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit udFilter0Pu "Start value of the d-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit uqFilter0Pu "Start value of the q-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit idConvRef0Pu "Start value of the d-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iqConvRef0Pu "Start value of the q-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";

equation
  der(udFiltMeasPu) * 1/Wqsem + udFiltMeasPu = udPccPu;
  der(uqFiltMeasPu) * 1/Wqsem + uqFiltMeasPu = uqPccPu;

  alpha = RFilter/(RFilter^2+(omegaPu*(LFilter+Lv_QSEM))^2);
  beta = (omegaPu*(LFilter+Lv_QSEM))/(RFilter^2+(omegaPu*(LFilter+Lv_QSEM))^2);

  idConvRefPu = alpha*(udFilterRefPu-udFiltMeasPu)+beta*(uqFilterRefPu-uqFiltMeasPu);
  iqConvRefPu = -beta*(udFilterRefPu-udFiltMeasPu)+alpha*(uqFilterRefPu-uqFiltMeasPu);

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-260, 120}, {160, -260}})),
    Icon(graphics = {Text(origin = {-183, 170}, lineColor = {97, 53, 131}, extent = {{-65, 22}, {65, -22}}, textString = "udFilterRefPu"), Text(origin = {-183, 128}, lineColor = {97, 53, 131}, extent = {{-65, 22}, {65, -22}}, textString = "uqFilterRefPu"), Text(origin = {-201, -78}, lineColor = {255, 120, 0}, lineThickness = 0.75, extent = {{-65, 22}, {65, -22}}, textString = "udPccPu"), Text(origin = {-197, -128}, lineColor = {255, 120, 0}, lineThickness = 0.75, extent = {{-65, 22}, {65, -22}}, textString = "uqPccPu"), Rectangle(extent = {{-100, 180}, {100, -180}}), Text(origin = {77, 220}, extent = {{-61, 16}, {61, -16}}, textString = "omegaPu"), Text(origin = {183, 66}, lineColor = {38, 162, 105}, extent = {{-65, 22}, {65, -22}}, textString = "idConvRefPu"), Text(origin = {181, -6}, lineColor = {38, 162, 105}, extent = {{-65, 22}, {65, -22}}, textString = "iqConvRefPu"), Text(origin = {0, 1}, extent = {{-98, 179}, {98, -179}}, textString = "QSEM")}, coordinateSystem(extent = {{-100, -180}, {100, 180}})));
end VCQSEM;
