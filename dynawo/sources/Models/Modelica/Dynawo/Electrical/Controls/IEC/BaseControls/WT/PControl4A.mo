within Dynawo.Electrical.Controls.IEC.BaseControls.WT;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PControl4A "Active power control module for type 4A wind turbines (IEC N°61400-27-1)"
  extends Dynawo.Electrical.Controls.IEC.BaseClasses.BasePControl4(absLimRateLimFirstOrderAntiWindup.tI = tPOrdP4A, absLimRateLimFirstOrderAntiWindup.DyMax = DPMaxP4APu, absLimRateLimFirstOrderAntiWindup.UseLimits = true);

  //PControl parameters
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4APu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4APu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPWTRef4A "Reference power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));

  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderAntiWindup absLimRateLimFirstOrderAntiWindup1(DyMax = DPRefMax4APu, DyMin = DPRefMin4APu, Kaw = 0, UseLimits = false, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = 999, tI = tPWTRef4A) annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(PWTRefPu, absLimRateLimFirstOrderAntiWindup1.u) annotation(
    Line(points = {{-180, -100}, {-122, -100}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderAntiWindup1.y, product.u1) annotation(
    Line(points = {{-98, -100}, {-80, -100}, {-80, -134}, {-62, -134}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderAntiWindup1.y, switch1.u3) annotation(
    Line(points = {{-98, -100}, {-40, -100}, {-40, -92}, {-2, -92}}, color = {0, 0, 127}));
  connect(switch1.y, absLimRateLimFirstOrderAntiWindup.u) annotation(
    Line(points = {{22, -100}, {78, -100}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {83, 35}, extent = {{-14, 21}, {14, -20}}, textString = "A")}));
end PControl4A;
