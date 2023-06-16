within Dynawo.Electrical.Controls.Generic;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package GenericAutomatonConstants "Defining constants for Generic automaton"
  extends Icons.Package;

  final constant Integer inputsMaxSize = 1000;
  final constant Integer outputsMaxSize = 500;

  annotation(preferredView = "text");
end GenericAutomatonConstants;
