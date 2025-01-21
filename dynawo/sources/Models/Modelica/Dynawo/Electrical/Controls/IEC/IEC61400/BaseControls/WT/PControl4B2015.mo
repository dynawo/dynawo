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

model PControl4B2015 "Active power control module for type 4B wind turbines (IEC N°61400-27-1:2015)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BasePControl4(absLimRateLimFirstOrderAntiWindup.UseLimits = true, absLimRateLimFirstOrderAntiWindup.tI = tPOrdP4B, absLimRateLimFirstOrderAntiWindup.DyMax = DPMaxP4BPu);

  //PControl parameters
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPAero "Aerodynamic power response time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4B "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tUFiltP4B "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "PControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omega0Pu) "Generator angle frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PAeroPu(start = -P0Pu * SystemBase.SnRef / SNom) "Aerodynamic power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tPAero, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-20, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFiltP4B, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-86, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(UWTPu, product1.u2) annotation(
    Line(points = {{-180, 100}, {-20, 100}, {-20, 66}, {-2, 66}}, color = {0, 0, 127}));
  connect(PWTRefPu, product.u2) annotation(
    Line(points = {{-180, -100}, {-98, -100}}, color = {0, 0, 127}));
  connect(omegaGenPu, product.u1) annotation(
    Line(points = {{-180, -60}, {-120, -60}, {-120, -88}, {-98, -88}}, color = {0, 0, 127}));
  connect(product.y, absLimRateLimFirstOrderAntiWindup.u) annotation(
    Line(points = {{-74, -94}, {60, -94}, {60, -100}, {78, -100}}, color = {0, 0, 127}));
  connect(PWTRefPu, firstOrder.u) annotation(
    Line(points = {{-180, -100}, {-120, -100}, {-120, -140}, {-32, -140}}, color = {0, 0, 127}));
  connect(firstOrder.y, PAeroPu) annotation(
    Line(points = {{-8, -140}, {170, -140}}, color = {0, 0, 127}));
  connect(UWTPu, firstOrder1.u) annotation(
    Line(points = {{-180, 100}, {-2, 100}}, color = {0, 0, 127}));
  connect(firstOrder1.y, max.u2) annotation(
    Line(points = {{22, 100}, {40, 100}, {40, 114}, {58, 114}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {83, 35}, extent = {{-14, 21}, {14, -20}}, textString = "B"), Text(origin = {-1, -16}, extent = {{-54, 26}, {54, -23}}, textString = "2015")}));
end PControl4B2015;
