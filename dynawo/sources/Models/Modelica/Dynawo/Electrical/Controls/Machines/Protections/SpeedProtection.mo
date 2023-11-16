within Dynawo.Electrical.Controls.Machines.Protections;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SpeedProtection "Sends a tripping signal to the generator when the frequency goes outside a safe region"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.AngularVelocityPu OmegaMinPu "Frequency threshold under which the automaton is activated in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMaxPu "Frequency threshold above which the automaton is activated in pu (base omegaNom)";
  parameter Types.Time tLagAction "Time-lag due to the actual trip action in s";

  input Types.AngularVelocityPu omegaMonitoredPu "Monitored frequency in pu (base omegaNom)" annotation(
  Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the generator";

protected
  Types.Time tThresholdReachedMin(start = Constants.inf) "Time when the minimum frequency threshold was reached in s";
  Types.Time tThresholdReachedMax(start = Constants.inf) "Time when the maximum frequency threshold was reached in s";

equation
  // Frequency comparison with the minimum accepted value
  when omegaMonitoredPu <= OmegaMinPu and not(pre(switchOffSignal.value)) then
    tThresholdReachedMin = time;
    Timeline.logEvent1(TimelineKeys.UnderspeedArming);
  elsewhen omegaMonitoredPu > OmegaMinPu and pre(tThresholdReachedMin) <> Constants.inf and not(pre(switchOffSignal.value)) then
    tThresholdReachedMin = Constants.inf;
    Timeline.logEvent1(TimelineKeys.UnderspeedDisarming);
  end when;

  // Frequency comparison with the maximum accepted value
  when omegaMonitoredPu >= OmegaMaxPu and not(pre(switchOffSignal.value)) then
    tThresholdReachedMax = time;
    Timeline.logEvent1(TimelineKeys.OverspeedArming);
  elsewhen omegaMonitoredPu < OmegaMaxPu and pre(tThresholdReachedMax) <> Constants.inf and not(pre(switchOffSignal.value)) then
    tThresholdReachedMax = Constants.inf;
    Timeline.logEvent1(TimelineKeys.OverspeedDisarming);
  end when;

  // Delay before tripping the generator
  when time - tThresholdReachedMin >= tLagAction then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.UnderspeedTripped);
  elsewhen time - tThresholdReachedMax >= tLagAction then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.OverspeedTripped);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This model will send a tripping order to a generator if the frequency stays below a min threshold or above a max threshold during a certain amount of time.</body></html>"));
end SpeedProtection;
