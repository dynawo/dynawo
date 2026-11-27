within Dynawo.Electrical.Controls.Current;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PhaseShifterBlockingI "Phase Shifter blocking model"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.CurrentModule IMax "Maximum current on the monitored component";
  parameter Types.Time tLagBeforeActing "Time lag before taking action";

  input Types.CurrentModule IMonitored "Monitored current";

  output Boolean locked "Is phase shifter locked?";

protected
  discrete Types.Time tThresholdReached(start = Constants.inf) "Time when I > IMax was first reached";

equation
  when IMonitored > IMax and not(pre(locked)) then
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBlockingIArming);
  elsewhen IMonitored <= IMax and pre(tThresholdReached) <> Constants.inf and not(pre(locked)) then
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBlockingIDisarming);
  end when;

  when time - tThresholdReached >= tLagBeforeActing then
    locked = true;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBlockingIActing);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The automaton will block a Phase Shifter when the current stays higher than a predefined threshold during a certain amount of time on a monitored and controlled component (line, transformer, etc.)</body></html>"));
end PhaseShifterBlockingI;
