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

model Hvdc

  annotation(
    Icon(graphics = {Rectangle(origin = {1, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-61, 21}, {-21, -19}}), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{-20, 0}, {20, 0}}), Text(origin = {0, 30}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Rectangle(origin = {40, 0}, extent = {{-20, 20}, {20, -20}}), Line(origin = {0, 10}, points = {{-20, 0}, {20, 0}, {20, 0}}), Line(origin = {0, -10}, points = {{-20, 0}, {20, 0}}), Line(origin = {40, 0}, points = {{-20, -20}, {20, 20}}), Line(origin = {-40, 0}, points = {{-20, -20}, {20, 20}})}, coordinateSystem(initialScale = 0.1)));
end Hvdc;
