within Dynawo.Examples.Nordic.Components.GeneratorWithControl;

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

package BaseClasses "Base generator models"
  extends Icons.Package;

  annotation(
    Documentation(info = "<html><head></head><body>This package contains the initialized synchronous generator models. These models use the initialization models of dynawo to convert standard parameters given in the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015 into operational parameters needed by the generatorSynchronous model of dynawo.<div>The calculated parameters are then assigned in an initial algorithm section.</div></body></html>"));
end BaseClasses;
