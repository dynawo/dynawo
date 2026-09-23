within Dynawo.AdditionalIcons;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model Transformer

  annotation(
    Icon(graphics = {Ellipse(origin = {-15, -7}, extent = {{-45, 47}, {35, -33}}, endAngle = 360), Ellipse(origin = {3, -9}, extent = {{57, 49}, {-23, -31}}, endAngle = 360), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{-20, 0}, {20, 0}}), Text(origin = {0, 61}, lineColor = {0, 0, 255}, extent = {{-80, 11}, {80, -11}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));
end Transformer;
