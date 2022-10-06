within Dynawo.Electrical.Controls.Basics;

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

model Perturbation_INIT "Initialization for the perturbation model"
  extends AdditionalIcons.Init;

  parameter Real ValueIn "Start value of the output given as a parameter";

  Real Value0(start = ValueIn) "Start value of the output of the initialization process";

  annotation(preferredView = "text");
end Perturbation_INIT;
