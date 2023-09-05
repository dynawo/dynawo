within Dynawo.Electrical.Controls.Machines.Protections;

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

model UVA "Under-Voltage Automaton"
  /* When the monitored voltage goes below a threshold (UMin)
     and does not go back above this threshold within a given time lag
     a tripping order is sent to the generator */
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.VoltageModulePu UMinPu "Voltage threshold under which the automaton is activated in pu (base UNom)";
  parameter Types.Time tLagAction "Time-lag due to the actual trip action in s";

  Types.VoltageModulePu UMonitoredPu "Monitored voltage in pu (base UNom)";
  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the generator";

protected
  Types.Time tThresholdReached(start = Constants.inf) "Time when the threshold was reached";

equation
  // Voltage comparison with the minimum accepted value
  when UMonitoredPu <= UMinPu and not(pre(switchOffSignal.value)) then
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.UVAArming);
  elsewhen UMonitoredPu > UMinPu and pre(tThresholdReached) <> Constants.inf and not(pre(switchOffSignal.value)) then
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.UVADisarming);
  end when;

  // Delay before tripping the generator
  when time - tThresholdReached >= tLagAction then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.UVATripped);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This model will send a tripping order to a generator if the voltage stays below a threshold during a certain amount of time.</body></html>"));
end UVA;
