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
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseTapChangerPhaseShifterTarget(targetValue = PTarget, deadBand = PDeadBand, valueToMonitor0 = P0, Type = BaseClasses.TapChangerPhaseShifterParams.Automaton.PhaseShifter);

  parameter Types.ActivePower PTarget "Target active power";
  parameter Types.ActivePower PDeadBand(min = 0) "Active-power dead-band around the target";
  parameter Types.ActivePower P0 "Initial active power";

  Dynawo.Connectors.ImPin PMonitored(value(start = P0)) "Monitored active power";

equation
  connect(PMonitored, valueToMonitor);

  when (valueToMonitor.value < valueMin) and not(locked) then
    Timeline.logEvent1(TimelineKeys.PhaseShifterBelowMin);
  elsewhen (valueToMonitor.value > valueMax) and not(locked) then
    Timeline.logEvent1(TimelineKeys.PhaseShifterAboveMax);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The phase shifter P controls an active power PMonitored to keep it in a certain desired [PMin;PMax] range. When the active power monitored goes above PMax or under PMin, the phase-shifter will act to modify its tap to bring back the active power in an acceptable range.<div><div>The time interval before the first time change is specified with a first timer and a second timer indicates the time interval between further changes. The automaton can be locked by an external controller: in this case, it stops acting.&nbsp;</div><div><br></div><div>The detailed phase-shifter P behavior is explained in the following state diagram:
<figure>
    <img width=\"450\" src=\"modelica://Dynawo/Electrical/Controls/Transformers/Images/PhaseShifterP.png\">
</figure>

</div></div></body></html>"));
end PhaseShifterP;
