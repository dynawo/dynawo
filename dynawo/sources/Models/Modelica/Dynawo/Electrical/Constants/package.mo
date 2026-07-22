within Dynawo.Electrical;

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

package Constants "Defining constants for network components"
  extends Icons.Package;

  final constant Real Open = 1 " Component disconnected";
  final constant Real Closed = 2 "Component connected";
  final constant Real Closed1 = 3 "Component connected on side 1";
  final constant Real Closed2 = 4 "Component connected on side 2";
  final constant Real Closed3 = 5 "Component connected on side 3";
  final constant Real Undefined = 6 "Component status undefined";

  type state = enumeration(
    Open "Component disconnected",
    Closed "Component connected",
    Closed1 "Component connected on side 1",
    Closed2 "Component connected on side 2",
    Closed3 "Component connected on side 3",
    Undefined "Component status undefined");

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
    This package enables to express the connection status for any component in a similar way between C++ and Modelica.</body></html>"));
end Constants;
