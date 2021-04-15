within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model IEEE_SEXS "Automatic Voltage Regulator"

  import Modelica;
  import Modelica.Blocks.Interfaces;
  import Dynawo;
  import Dynawo.Types;

  //Input variables
  Interfaces.RealInput UsRefPu(start = UsRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Interfaces.RealInput UsPu(start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Interfaces.RealInput UpssPu(start = Upss0Pu) annotation(
    Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, -62}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Interfaces.RealOutput EfdPu(start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit K "Controller gain";
  parameter Types.Time Ta "Filter derivative time constant in s";
  parameter Types.Time Tb "Filter delay time constant in s";
  parameter Types.Time Te "Exciter time constant in s";
  parameter Types.VoltageModulePu EMin "Controller minimum output";
  parameter Types.VoltageModulePu EMax "Controller maximum output";
  parameter Types.VoltageModulePu Efd0Pu "Initial voltage output in p.u (base PNom)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage";
  parameter Types.VoltageModulePu Upss0Pu "Initial PSS output voltage";

  final parameter Types.VoltageModulePu UsRef0Pu = Us0Pu + Efd0Pu / K - Upss0Pu "Initial control voltage";

  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderLimiter firstOrderLim(T = Te, K = K, yMax = EMax, yMin = EMin, y_start = Efd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LeadLag leadLag(T1 = Ta, T2 = Tb, y_start = Efd0Pu / K)   annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(UpssPu, add3.u3) annotation(
    Line(points = {{-100, -40}, {-70, -40}, {-70, -8}, {-62, -8}}, color = {0, 0, 127}));
  connect(UsPu, add3.u2) annotation(
    Line(points = {{-100, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, add3.u1) annotation(
    Line(points = {{-100, 40}, {-70, 40}, {-70, 8}, {-62, 8}, {-62, 8}}, color = {0, 0, 127}));
  connect(add3.y, leadLag.u) annotation(
    Line(points = {{-38, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(leadLag.y, firstOrderLim.u) annotation(
    Line(points = {{11, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(firstOrderLim.y, EfdPu) annotation(
    Line(points = {{61, 0}, {100, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")));
end IEEE_SEXS;
