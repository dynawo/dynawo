within Dynawo.Electrical.Controls.Transformers;

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

model PhaseShifterP_INIT "Initialisation model for a phase-shifter monitoring the active power"
  extends BaseClasses_INIT.BaseTapChangerPhaseShifterTarget_INIT (targetValue = PTarget, deadBand = PDeadBand, increaseTapToIncreaseValue = (increasePhase > 0));
  extends AdditionalIcons.Init;

  parameter Types.ActivePower PTarget "Target active power";
  parameter Types.ActivePower PDeadBand(min = 0) "Active-power dead-band around the target";
  parameter Types.ActivePower P0 "Initial active power";
  parameter Integer increasePhase;

equation
  valueToMonitor0 = P0;

  annotation(preferredView = "text");
end PhaseShifterP_INIT;
