within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block AbsLimRateLimFeedthroughFreezeLimDetection "First order feed-through with absolute and rate limits, a freezing flag, and limitation detection flags"
  import Modelica;
  import Dynawo;

  extends Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreeze;

  Modelica.Blocks.Interfaces.BooleanOutput fMax "Outputs true if upper limit is reached" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput fMin "Outputs true if lower limit is reached" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = YMax) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = YMin) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.FixedBooleanDelay fixedBooleanDelay(Y0 = U0 > YMax, tDelay = tS) annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.FixedBooleanDelay fixedBooleanDelay1(Y0 = U0 < YMin, tDelay = tS) annotation(
    Placement(visible = true, transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(u, greaterThreshold.u) annotation(
    Line(points = {{-120, 0}, {-80, 0}, {-80, 40}, {-62, 40}}, color = {0, 0, 127}));
  connect(u, lessThreshold.u) annotation(
    Line(points = {{-120, 0}, {-80, 0}, {-80, -40}, {-62, -40}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, fixedBooleanDelay.u) annotation(
    Line(points = {{-38, 40}, {-22, 40}}, color = {255, 0, 255}));
  connect(fixedBooleanDelay.y, fMax) annotation(
    Line(points = {{2, 40}, {110, 40}}, color = {255, 0, 255}));
  connect(lessThreshold.y, fixedBooleanDelay1.u) annotation(
    Line(points = {{-38, -40}, {-22, -40}}, color = {255, 0, 255}));
  connect(fixedBooleanDelay1.y, fMin) annotation(
    Line(points = {{2, -40}, {110, -40}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram");
end AbsLimRateLimFeedthroughFreezeLimDetection;
