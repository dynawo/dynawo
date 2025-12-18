within Dynawo.Electrical.Controls.Basics;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
* for power systems.
*/

model SineWave "Parameterizable sine wave model"

  Dynawo.Connectors.ImPin source(value(start = Offset));

  parameter Real K "Amplitude of the sine wave";
  parameter Real Offset "Average value of the sine wave";
  parameter Types.AngularVelocity Omega "Pulsation of the sine wave in rad/s";
  parameter Types.Angle Phi "Phase of the sine wave in rad";

equation
  source.value = Offset + K * sin(Omega * time + Phi);

  annotation(preferredView = "text");
end SineWave;
