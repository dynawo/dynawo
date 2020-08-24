within Dynawo.Electrical.Controls.Shunts;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SectionControl_INIT "Initialization model of section control for shunts with sections"
  extends AdditionalIcons.Init;

protected

  Real section0 "Initial section of the shunt. This variable is equal to the section0 of the shunt.";

equation

annotation(preferredView = "text");
end SectionControl_INIT;
