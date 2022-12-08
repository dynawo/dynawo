within Dynawo.Examples.Nordic;

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

package Data "Parameter records of the Nordic 32 test system"
  extends Icons.Package;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body>The Data package contains the parameter records for the generators, the shunts and the transformers used in the full dynamic grid model.</body></html>"));
end Data;
