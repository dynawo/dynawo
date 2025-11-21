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
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model Step "Parametrable step model : applies a change of amplitude at a given time"

  Modelica.Blocks.Interfaces.RealOutput step(start = Value0);

  parameter Real Height "Amplitude of the step to be imposed by the model";
  parameter Types.Time tStep "Time instant when the step occurs";

  parameter Real Value0 "Start value of the step model";

equation
  step = Value0 + (if time < tStep then 0 else Height);

  annotation(preferredView = "text");
end Step;
