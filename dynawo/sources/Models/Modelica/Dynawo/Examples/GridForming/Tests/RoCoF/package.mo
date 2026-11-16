within Dynawo.Examples.GridForming.Tests;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

package RoCoF "Grid-forming converters test cases with a rate of change of frequency of the grid (DTR I18)"
  extends Icons.Package;
  annotation(
    Documentation(info = "<html><head></head><body>This package contains test cases from the DTR I18 information sheet: the grid-forming converter models (VSM, droop and current-controlled VSM) are subjected to a rate of change of frequency (RoCoF) imposed by the AC grid it is connected to.</body></html>"));
end RoCoF;
