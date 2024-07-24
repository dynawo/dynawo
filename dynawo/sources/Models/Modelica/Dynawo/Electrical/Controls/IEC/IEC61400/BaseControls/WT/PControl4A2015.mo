within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PControl4A2015 "Active power control module for type 4A wind turbines (IEC N°61400-27-1:2015)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BasePControl4(absLimRateLimFirstOrderAntiWindup.tI = tPOrdP4A, absLimRateLimFirstOrderAntiWindup.DyMax = DPMaxP4APu, absLimRateLimFirstOrderAntiWindup.UseLimits = true);

  //PControl parameters
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tUFiltP4A "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "PControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UWTPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tUFiltP4A, y_start = U0Pu)  annotation(
    Placement(visible = true, transformation(origin = {10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(UWTPu, product1.u2) annotation(
    Line(points = {{-180, 100}, {-20, 100}, {-20, 66}, {-2, 66}}, color = {0, 0, 127}));
  connect(PWTRefPu, absLimRateLimFirstOrderAntiWindup.u) annotation(
    Line(points = {{-180, -100}, {78, -100}}, color = {0, 0, 127}));
  connect(UWTPu, firstOrder.u) annotation(
    Line(points = {{-180, 100}, {-2, 100}}, color = {0, 0, 127}));
  connect(firstOrder.y, max.u2) annotation(
    Line(points = {{22, 100}, {40, 100}, {40, 114}, {58, 114}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {83, 35}, extent = {{-14, 21}, {14, -20}}, textString = "A"), Text(origin = {-1, -16}, extent = {{-54, 26}, {54, -23}}, textString = "2015")}));
end PControl4A2015;
