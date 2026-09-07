within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package Simplified "Simplified voltage regulators"
  extends Icons.Package;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body>This package contains simplified voltage regulator models, such as <a href=\"modelica://Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportional\"> a proportional model </a> or <a href=\"modelica://Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportionalIntegral\"> a proportional integral model</a>.<div><div><br></div></div></body></html>"));
end Simplified;
