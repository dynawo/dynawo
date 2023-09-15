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

model Perturbation "Parameterizable perturbation model : adds a constant signal at a given time"

  Dynawo.Connectors.ImPin signal(value(start = Value0));
  Dynawo.Connectors.ImPin perturbatedSignal(value(start = Value0));

  parameter Real Height "Amplitude of the peturbation to be added";
  parameter Types.Time tStep "Time instant when the perturbation occurs";

  parameter Real Value0 "Start value of the output";

equation
  perturbatedSignal.value = signal.value + (if time < tStep then 0 else Height);

  annotation(preferredView = "text");
end Perturbation;
