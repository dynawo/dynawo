within Dynawo.Electrical.Controls.WECC.Parameters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

record ParamsWTGTb
  parameter Types.Time tp "Lag time constant in s" annotation(
    Dialog(tab="Drive train control"));

  annotation(
  preferredView = "text");
end ParamsWTGTb;
