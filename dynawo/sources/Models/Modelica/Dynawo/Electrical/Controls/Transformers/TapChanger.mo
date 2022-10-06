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
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseTapChangerPhaseShifter_TARGET(targetValue = UTarget, deadBand = UDeadBand, valueToMonitor0 = U0, Type = BaseClasses.TapChangerPhaseShifterParams.Automaton.TapChanger);

  parameter Types.VoltageModule UTarget "Voltage set-point";
  parameter Types.VoltageModule UDeadBand(min = 0) "Voltage dead-band";
  parameter Types.VoltageModule U0 "Initial voltage";

  Connectors.ImPin UMonitored(value(start = U0)) "Initial voltage";

equation
  connect(UMonitored, valueToMonitor);
  when (valueToMonitor.value < valueMin) and not(locked) then
    Timeline.logEvent1(TimelineKeys.TapChangerBelowMin);
  elsewhen (valueToMonitor.value > valueMax) and not(locked) then
    Timeline.logEvent1(TimelineKeys.TapChangerAboveMax);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The tap changer controls a monitored voltage to keep it within a voltage range defined by [UMin ; UMax]. When the voltage goes above UMax or below UMin, the tap-changer is ready to begin increasing its tap until the voltage value comes back to an acceptable value.<div><br></div><div>The time interval before the first time change is specified with a first timer and a second timer indicates the time interval between further changes. The automaton can be locked by an external controller: in this case, it stops acting.&nbsp;</div><div><br></div><div>The detailed tap-changer behavior is explained in the following state diagram:

<figure>
    <img width=\"450\" src=\"modelica://Dynawo/Electrical/Controls/Transformers/Images/TapChanger.png\">
</figure>

</div><div><br></div><div><br></div><div><br></div></body></html>"));
end TapChanger;
