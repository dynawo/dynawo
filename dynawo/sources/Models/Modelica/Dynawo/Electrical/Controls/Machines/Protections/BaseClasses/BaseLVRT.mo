within Dynawo.Electrical.Controls.Machines.Protections.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model BaseLVRT "Low-voltage ride-through protection"
  /* Disconnects the generator when the voltage pass below the LVRT curve of the machine. The curve created by linking a series of (tLagAction, UMinPu) points that should be given in increasing order of tLagAction. */
  import Modelica.Constants;
  import Dynawo.Connectors;
  import Modelica.Math.BooleanVectors.anyTrue;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Integer NbPoints "Number of points used to describe the LVRT curve";

  parameter Types.VoltageModulePu[NbPoints] UMinPu = fill(0, NbPoints) "Voltage threshold under which the automaton is activated in pu (base UNom) (for each point used to describe the LVRT curve)";
  parameter Types.Time[NbPoints] tLagAction = fill(0, NbPoints) "Time-lag due to the actual tripping action in s (for each point used to describe the LVRT curve)";

  input Types.VoltageModulePu UMonitoredPu "Monitored voltage in pu (base UNom)";

  Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the generator";

  Types.Time tThresholdReached(start = Constants.inf) "Time when the threshold was reached in s";
  Boolean[NbPoints] tripped(each start = false) "true if the protection tripped (for each point used to describe the LVRT curve)";

equation
  // Voltage comparison with the minimum long-term sustainable value (i.e. last point, so highest point of the LVRT curve)
  when UMonitoredPu <= UMinPu[NbPoints] and not (pre(switchOffSignal.value)) then
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.LVRTArming);
  elsewhen UMonitoredPu > UMinPu[NbPoints] and pre(tThresholdReached) <> Constants.inf and not (pre(switchOffSignal.value)) then
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.LVRTDisarming);
  end when;

  // Delay before tripping the generator
  when UMonitoredPu < UMinPu[1] and time - tThresholdReached >= tLagAction[1] and not(pre(tripped[1])) then
    tripped[1] = true;
  end when;

  for i in 1:NbPoints-1 loop
    assert(tLagAction[i] <= tLagAction[i+1], "values of tLagAction should be in increasing order");
    assert(UMinPu[i] <= UMinPu[i+1], "values of UMinPu should be in increasing order");

    when UMonitoredPu < UMinPu[i+1] and UMonitoredPu > UMinPu[i] and time - tThresholdReached >= tLagAction[i] + (tLagAction[i+1] - tLagAction[i]) * (UMonitoredPu-UMinPu[i])/max(UMinPu[i+1]-UMinPu[i], 1e-6) and not(pre(tripped[i+1])) then
      tripped[i+1] = true;
    end when;
  end for;

  when anyTrue(tripped) then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.LVRTTripped);
  end when;

  annotation(preferredView = "text");
end BaseLVRT;
