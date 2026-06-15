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

model PhaseShifterI_INIT "Initialisation model for a phase-shifter monitoring the current"
  extends BaseClasses_INIT.BaseTapChangerPhaseShifterMax_INIT(valueMax = iMax, valueStop = iStop, valueToMonitor0 = I0, increaseTapToIncreaseValue = (sign0 * increasePhase < 0));
  extends AdditionalIcons.Init;

  parameter Types.CurrentModule iMax "Maximum allowed current (unit depending on the monitored current unit)";
  parameter Types.CurrentModule iStop "Current below which the phase-shifter will not take action (unit depending on the monitored current unit)";
  parameter Types.CurrentModule I0 "Initial current module (unit depending on the monitored current unit)";
  parameter Types.ActivePower P0 "Initial active power (unit depending on the monitored active power unit)";
  parameter Integer sign0 = if P0 < 0 then 1 else -1 "Initial sign of the active power flowing through the phase-shifter transformer";
  parameter Integer increasePhase "Whether the phase shifting is increased when the tap is increased";

  annotation(preferredView = "text");
end PhaseShifterI_INIT;
