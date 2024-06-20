within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

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

model QLimiter2020 "Reactive power limitation module for wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseQLimiter;

  //Input variables
  Modelica.Blocks.Interfaces.IntegerInput fFrt(start = 0) "Fault status (0: Normal operation, 1: During fault, 2: Post-fault)" annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTCFiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreeze absLimRateLimFeedthroughFreeze(DyMax = 999, U0 = U0Pu, Y0 = U0Pu, YMax = 999, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreeze absLimRateLimFeedthroughFreeze1(DyMax = 999, U0 = -P0Pu * SystemBase.SnRef / SNom, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = 999, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(absLimRateLimFeedthroughFreeze1.y, combiTable1Ds3.u) annotation(
    Line(points = {{-58, -60}, {-50, -60}, {-50, -80}, {-42, -80}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreeze1.y, combiTable1Ds2.u) annotation(
    Line(points = {{-58, -60}, {-50, -60}, {-50, -40}, {-42, -40}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreeze.y, combiTable1Ds.u) annotation(
    Line(points = {{-58, 60}, {-50, 60}, {-50, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreeze.y, combiTable1Ds1.u) annotation(
    Line(points = {{-58, 60}, {-50, 60}, {-50, 40}, {-42, 40}}, color = {0, 0, 127}));
  connect(integerToBoolean.y, absLimRateLimFeedthroughFreeze1.freeze) annotation(
    Line(points = {{-78, 0}, {-70, 0}, {-70, -48}}, color = {255, 0, 255}));
  connect(integerToBoolean.y, absLimRateLimFeedthroughFreeze.freeze) annotation(
    Line(points = {{-78, 0}, {-70, 0}, {-70, 50}}, color = {255, 0, 255}));
  connect(UWTCFiltPu, absLimRateLimFeedthroughFreeze.u) annotation(
    Line(points = {{-140, 60}, {-80, 60}}, color = {0, 0, 127}));
  connect(PWTCFiltPu, absLimRateLimFeedthroughFreeze1.u) annotation(
    Line(points = {{-140, -60}, {-80, -60}}, color = {0, 0, 127}));
  connect(fFrt, integerToBoolean.u) annotation(
    Line(points = {{-140, 0}, {-102, 0}}, color = {255, 127, 0}));

  annotation(
    Icon(graphics = {Text(origin = {-19, -26}, extent = {{-25, 22}, {61, -60}}, textString = "2020")}));
end QLimiter2020;
