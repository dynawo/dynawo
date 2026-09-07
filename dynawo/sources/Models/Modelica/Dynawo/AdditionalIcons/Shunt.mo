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

model Shunt

  annotation(
    Icon(graphics = {Text(origin = {-1, -120}, lineColor = {0, 0, 255}, extent = {{-81, 10}, {81, -10}}, textString = "%name"), Rectangle(origin = {0, -42}, fillPattern = FillPattern.Solid, extent = {{-40, 2}, {40, -2}}), Rectangle(origin = {-20, -62}, fillPattern = FillPattern.Solid, extent = {{-20, 2}, {60, -2}}), Line(origin = {0, -21}, points = {{0, 21}, {0, -21}}), Line(origin = {0, -100}, points = {{-40, 0}, {40, 0}}), Line(origin = {0, -81}, points = {{0, -19}, {0, 19}})}, coordinateSystem(initialScale = 0.1)));
end Shunt;
