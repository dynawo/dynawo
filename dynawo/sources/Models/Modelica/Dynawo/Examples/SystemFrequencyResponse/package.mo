within Dynawo.Examples;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

package SystemFrequencyResponse "Examples demonstrating the behavior of the SystemFrequencyResponse models"
  extends Icons.Package;
  annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This test case consists in one Wind Turbine park connected to an infinite bus through a line. Several events are simulated.</body></html>"));
end SystemFrequencyResponse;
