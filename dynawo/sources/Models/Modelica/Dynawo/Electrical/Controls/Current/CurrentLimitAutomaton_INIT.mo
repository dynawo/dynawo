within Dynawo.Electrical.Controls.Current;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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


model CurrentLimitAutomaton_INIT "initialization model for Current Limit Automaton (CLA)"
  extends AdditionalIcons.Init;

  Types.Time time0 "Initial time of the simulation";

equation
  time0 = time;

  annotation(preferredView = "text");
end CurrentLimitAutomaton_INIT;
