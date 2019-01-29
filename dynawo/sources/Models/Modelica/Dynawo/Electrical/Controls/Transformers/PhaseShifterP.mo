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

model PhaseShifterP "Phase-shifter monitoring the active power so that it remains within [PTarget - PDeadBand ; PTarget + PDeadBand]"
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  
  extends BaseClasses.BaseTapChangerPhaseShifter_TARGET (targetValue = PTarget, deadBand = PDeadBand, valueToMonitor0 = P0, tapChangerType = tapChangerType0);
  extends SwitchOff.SwitchOffPhaseShifter;
  
  protected
    parameter TapChangerType tapChangerType0 = TapChangerType.phaseShifter;

  public
    parameter Types.AC.ActivePower PTarget  "Target active power";
    parameter Types.AC.ActivePower PDeadBand (min = 0) "Active-power dead-band around the target";
    parameter Types.AC.ActivePower P0  "Initial active power";

    Connectors.ImPin PMonitored (value (start = P0)) "Monitored active power";

equation
  connect (PMonitored.value, valueToMonitor.value);

end PhaseShifterP;

