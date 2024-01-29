within Dynawo.Examples;

package KundurTwoArea "Nordic 32 test system used for voltage stability studies"
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
    Documentation(info = "<html><head></head><body>This package contains the Nordic 32 test system as described in&nbsp;<span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">the&nbsp;</span><span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015 (PES-TR19)</span>. The included test case investigates the long term dynamic response.</body></html>"));
end KundurTwoArea;
