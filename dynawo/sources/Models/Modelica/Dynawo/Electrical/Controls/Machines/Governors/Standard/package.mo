within Dynawo.Electrical.Controls.Machines.Governors;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

package Standard "Standard governors"
  extends Icons.Package;

  annotation(
    preferredView = "info",
    Documentation(info = "<html><head></head><body>This package contains different governors models and is organized into different subpackages:<div><ul><li><a href=\"modelica://Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam\">\"Steam\"</a> for steam standard governor models </li><li><a href=\"modelica://Dynawo.Electrical.Controls.Machines.Governors.Standard.Hydraulic\">\"Hydraulic\"</a>&nbsp;for hydraulic standard governor models</li><li><a href=\"modelica://Dynawo.Electrical.Controls.Machines.Governors.Standard.Generic\">\"Generic\"</a>&nbsp;for generic standard governor models (e.g. not clearly assignable to steam, diesel, hydraulic, ...)</li></ul></div></body></html>"));
end Standard;
