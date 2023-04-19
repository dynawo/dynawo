within Dynawo.Electrical.Controls.Frequency;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SecondaryFrequencyRegulation "Model for Secondary Frequency Regulation based on SignalN"

  parameter Types.Time tSFR "Time constant of the secondary frequency regulation in s";

  input Types.PerUnit N "Signal to change the active power reference setpoint of the generators participating in the primary frequency regulation in pu (base SnRef)";

  output Types.PerUnit NSFR "Signal to change the active power reference setpoint of the generators participating in the secondary frequency regulation in pu (base SnRef)";

equation
  tSFR * der(NSFR) = N;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This model calculates a signal NSFR to give to the generators participating in the secondary frequency regulation. The generators that participate receive the signal N + NSFR, while the generators that only participate in the primary frequency regulation only receive the signal N. In steady-state, der(NSFR) = N = 0, which means that, after the transient, only the generators that receive NSFR have changed their active power reference setpoint to compensate the active power mismatch. The other generators went back to their initial active power generation. When the secondary frequency regulation is modelled, the signal N behaves like a primary frequency control.</body></html>"));
end SecondaryFrequencyRegulation;
