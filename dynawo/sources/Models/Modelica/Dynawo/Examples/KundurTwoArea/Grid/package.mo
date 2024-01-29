within Dynawo.Examples.KundurTwoArea;

package Grid "Grid models of the Nordic 32 test system"
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
  extends Icons.Package;
  annotation(
    preferredView = "info",
    Documentation(info = "<html><head></head><body>The Grid package contains grid models of the Nordic 32 test system. It implements a modular approach, where components like loads, buses and lines are separated from another. The final Nordic 32 test system grid model is constructed by extending base models.</body></html>"));
end Grid;
