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
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model PhaseShifterI "Phase-shifter monitoring the current so that it remains under iMax"
  extends BaseClasses.BaseTapChangerPhaseShifterMax(valueMax = iMax, valueStop = iStop, valueToMonitor0 = I0, factorValueToDisplay = factorValue, unitValueToDisplay = "A", Type = BaseClasses.TapChangerPhaseShifterParams.Automaton.PhaseShifter);

  parameter Types.CurrentModule iMax "Maximum allowed current";
  parameter Types.CurrentModule iStop "Current below which the phase-shifter will stop action";
  parameter Types.CurrentModule I0 "Initial current module";
  parameter Types.VoltageModule UNom = 0 "Nominal voltage in kV";
  final parameter Real factorValue = if UNom <> 0 then 1000 * SystemBase.SnRef/(sqrt(3) * UNom) else 1 "Multiplying factor for log messages of valueToMonitor (Pu to unit)";


  Dynawo.Connectors.ImPin iMonitored(value(start = I0)) "Monitored current";

equation
  connect(iMonitored, valueToMonitor);

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The phase shifter I ensures that the current on a line remains lower than a predefined threshold called valueMax. When the current monitored goes above IMax, the phase-shifter will act to modify its tap to bring back the current in an acceptable range.<div><div>The time interval before the first time change is specified with a first timer and a second timer indicates the time interval between further changes. The automaton can be locked by an external controller: in this case, it stops acting.&nbsp;</div><div><br></div><div>The detailed phase-shifter I behavior is explained in the following state diagram:
<figure>
    <img width=\"450\" src=\"modelica://Dynawo/Electrical/Controls/Transformers/Images/PhaseShifterI.png\">
</figure>

</div></div></body></html>"));
end PhaseShifterI;
