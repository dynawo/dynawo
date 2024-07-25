within Dynawo.Examples.Nordic.Components;

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

package GeneratorWithControl "Models of generators with control for the Nordic 32 test system"
  extends Icons.Package;

  annotation(
    preferredView = "info",
    Documentation(info = "<html><head></head><body>This package contains the regulated generator models used in the Nordic 32 test system. They are implemented as a generator frame model, where the generator and its controllers are already connected, parameterized and initialized.<div>The frame model only requires initial load flow values and the generator preset.</div><div><div><br></div></div></body></html>"));
end GeneratorWithControl;
