within Dynawo.Connectors;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

connector ACPower "Connector for AC power (described using complex V and i variables)"
  Types.ComplexVoltagePu V "Complex AC voltage";
  flow Types.ComplexCurrentPu i "Complex AC current (positive when entering the device)";

  annotation(preferredView = "text", Icon(graphics = {Rectangle(lineColor = {0, 0, 255}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 98}, {100, -102}})}, coordinateSystem(initialScale = 0.1)));
end ACPower;
