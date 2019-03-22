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
  extends BaseClasses_INIT.BaseTapChangerPhaseShifter_TARGET_INIT (targetValue = PTarget, deadBand = PDeadBand, tapChangerType = tapChangerType0);

  public
    parameter Types.AC.ActivePower PTarget  "Target active power";
    parameter Types.AC.ActivePower PDeadBand (min = 0) "Active-power dead-band around the target";
    parameter Types.AC.ActivePower P0  "Initial active power";
    parameter Real sign;
    parameter Integer increasePhase;

  protected
    parameter Real valueToMonitor0 = P0  "Initial monitored value";
    parameter Boolean increaseTapToIncreaseValue = (sign * increasePhase < 0) "Whether a tap increase will lead to an increase in the monitored value";
    parameter TapChangerType tapChangerType0 = TapChangerType.PhaseShifter;

end PhaseShifterP_INIT;
