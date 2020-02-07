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

model TapChanger "Tap-changer monitoring the voltage so that it remains within [UTarget - UDeadBand ; UTarget + UDeadBand]"
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends BaseClasses.BaseTapChangerPhaseShifter_TARGET (targetValue = UTarget, deadBand = UDeadBand, valueToMonitor0 = U0, tapChangerType = tapChangerType0 );
  extends SwitchOff.SwitchOffTapChanger;

  public
    parameter Types.VoltageModule UTarget "Voltage set-point";
    parameter Types.VoltageModule UDeadBand (min = 0) "Voltage dead-band";
    parameter Types.VoltageModule U0  "Initial voltage";

    Connectors.ImPin UMonitored (value (start = U0)) "Initial voltage";
  protected
    parameter TapChangerType tapChangerType0 = TapChangerType.TapChanger;

equation

    connect (UMonitored.value, valueToMonitor.value);

annotation(preferredView = "text");
end TapChanger;
