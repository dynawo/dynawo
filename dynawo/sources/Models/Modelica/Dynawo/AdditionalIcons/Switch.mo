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

model Switch

  annotation(Icon(coordinateSystem(extent = {{-100,-100}, {100,100}},
            preserveAspectRatio = true), graphics = {
          Line(origin = {10,34}, points = {{-100,-60}, {-54,-60}}),
          Ellipse(origin = {10,34}, extent = {{-54,-64}, {-46,-56}}),
          Line(origin = {10,34}, points = {{-47,-58}, {30,-10}}),
          Line(origin = {10,34}, points = {{30,-40}, {30,-60}}),
          Line(origin = {10,34}, points = {{30,-60}, {80,-60}})}));
end Switch;
