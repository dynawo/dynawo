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

model SVarC

  annotation(
    Icon(graphics = {Text(origin = {-1, -120}, lineColor = {0, 0, 255}, extent = {{-81, 10}, {81, -10}}, textString = "%name"), Rectangle(origin = {0, 18}, fillPattern = FillPattern.Solid, extent = {{-40, 2}, {40, -2}}), Rectangle(origin = {-20, -18}, fillPattern = FillPattern.Solid, extent = {{-20, 2}, {60, -2}}), Line(origin = {0, -21}, points = {{0, 81}, {0, -59}}), Line(origin = {-0.0916367, -80.3386}, points = {{-40, 0}, {40, 0}}), Line(origin = {-2.83665, -2.96415}, points = {{-44, -44}, {52, 52}}, thickness = 1), Line(origin = {39.2032, 49.0758}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {49.6216, 39.4941}, points = {{0, -10}, {0, 10}}, thickness = 1)}, coordinateSystem(initialScale = 0.1)));
end SVarC;
