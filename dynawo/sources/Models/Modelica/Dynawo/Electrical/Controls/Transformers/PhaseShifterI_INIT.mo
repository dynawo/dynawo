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
  extends BaseClasses_INIT.BaseTapChangerPhaseShifter_MAX_INIT (valueMax = iMax, valueStop = iStop);
  extends AdditionalIcons.Init;

  public
    parameter Types.CurrentModule iMax  "Maximum allowed current";
    parameter Types.CurrentModule iStop  "Current below which the phase-shifter will not take action";
    parameter Types.CurrentModule I0 "Initial current module";
    parameter Real sign;
    parameter Integer increasePhase;

  protected
    parameter Real valueToMonitor0 = I0  "Initial monitored value";
    parameter Boolean increaseTapToIncreaseValue = (sign * increasePhase < 0) "Whether a tap increase will lead to an increase in the monitored value";

annotation(preferredView = "text");
end PhaseShifterI_INIT;
