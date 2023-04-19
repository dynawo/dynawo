within Dynawo.NonElectrical.Blocks.Continuous;

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

block AbsLimRateLimFirstOrderFreezeLimDetection "First order filter with absolute and rate limits, a freezing flag, and limitation detection flags"
  extends Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreeze;

  Modelica.Blocks.Interfaces.BooleanOutput fMax "Outputs true if upper limit or maximum rising rate is reached" annotation(
    Placement(visible = true, transformation(origin = {210, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput fMin "Outputs true if lower limit or maximum falling rate is reached" annotation(
    Placement(visible = true, transformation(origin = {210, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater2 annotation(
    Placement(visible = true, transformation(origin = {140, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater3 annotation(
    Placement(visible = true, transformation(origin = {140, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or2 annotation(
    Placement(visible = true, transformation(origin = {170, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

equation
  connect(or2.y, fMin) annotation(
    Line(points = {{181, -80}, {190, -80}, {190, -60}, {210, -60}}, color = {255, 0, 255}));
  connect(or1.y, fMax) annotation(
    Line(points = {{182, 80}, {190, 80}, {190, 60}, {210, 60}}, color = {255, 0, 255}));
  connect(greater1.y, or2.u1) annotation(
    Line(points = {{41, -80}, {158, -80}}, color = {255, 0, 255}));
  connect(greater3.y, or2.u2) annotation(
    Line(points = {{151, -40}, {154, -40}, {154, -72}, {158, -72}}, color = {255, 0, 255}));
  connect(greater2.y, or1.u2) annotation(
    Line(points = {{151, 40}, {154, 40}, {154, 72}, {158, 72}}, color = {255, 0, 255}));
  connect(greater.y, or1.u1) annotation(
    Line(points = {{41, 80}, {158, 80}}, color = {255, 0, 255}));
  connect(limiter.y, greater.u2) annotation(
    Line(points = {{-38, 0}, {-20, 0}, {-20, 72}, {18, 72}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain.y, greater.u1) annotation(
    Line(points = {{-98, 0}, {-80, 0}, {-80, 80}, {18, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(variableLimiter.y, greater2.u2) annotation(
    Line(points = {{122, 0}, {124, 0}, {124, 32}, {128, 32}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(integrator.y, greater2.u1) annotation(
    Line(points = {{82, 0}, {86, 0}, {86, 40}, {128, 40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain.y, greater1.u2) annotation(
    Line(points = {{-98, 0}, {-80, 0}, {-80, -88}, {18, -88}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(limiter.y, greater1.u1) annotation(
    Line(points = {{-38, 0}, {-20, 0}, {-20, -80}, {18, -80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(variableLimiter.y, greater3.u1) annotation(
    Line(points = {{122, 0}, {124, 0}, {124, -40}, {128, -40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(integrator.y, greater3.u2) annotation(
    Line(points = {{82, 0}, {86, 0}, {86, -48}, {128, -48}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  annotation(
  preferredView = "diagram");
end AbsLimRateLimFirstOrderFreezeLimDetection;
