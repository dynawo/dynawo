within Dynawo.Electrical.Controls.Machines;

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

package VoltageRegulators "Voltage regulators"
  extends Icons.Package;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body>This package contains different voltage regulators models and is organized into two subpackages:<div><ul><li><a href=\"modelica://Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified\">\"Simplified\"</a> for simplified/equivalent voltage regulator models used for large-scale voltage stability studies for example.</li><li><a href=\"modelica://Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard\">\"Standard\"</a> for standard voltage regulator models (inherited from IEEE norms for example), that can for instance be used for transient stability studies.&nbsp;</li></ul></div></body></html>"));
end VoltageRegulators;
