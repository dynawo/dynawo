within Dynawo.Examples.Nordic.Components.TransformerWithControl;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

package BaseClasses "Base transformer models"
  extends Icons.Package;

  annotation(
    preferredView = "info",
    Documentation(info = "<html><head></head><body>This package contains the initialized transformer with variable tap models. These models use the initialization models of dynawo to calculate transformer parameters.<div>The calculated parameters are then assigned in an initial algorithm section.</div></body></html>"));
end BaseClasses;
